//
//  DRPickerView.h
//  DRPickerView
//
//  Created by Dal Rupnik on 01/04/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

#import "DRPickerView.h"

@interface DRPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *recognizer;
@property (nonatomic, strong) UIView *pickerView;
@property (nonatomic, strong) UIView *transparentView;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, readonly) UIView *rootSuperview;

@property (nonatomic) NSInteger index;

@end

@implementation DRPickerView

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        _dateFormatter.dateFormat = @"EEE dd MMMM";
    }
    
    return _dateFormatter;
}

- (void)setSelectedDate:(NSDate *)selectedDate
{
    _selectedDate = selectedDate;
    
    self.textLabel.text = [self.dateFormatter stringFromDate:_selectedDate].uppercaseString;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    //
    // TextLabel
    //
    self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.textLabel.textAlignment = NSTextAlignmentRight;
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.textLabel];
    
    //
    // Loading indicator
    //
    self.loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
    
    [self addSubview:self.loadingIndicatorView];
    self.loadingIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.loadingIndicatorView.hidesWhenStopped = YES;
    
    //
    // Gesture recognizer
    //
    
    self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
    
    [self addGestureRecognizer:self.recognizer];
}

- (void)pickerDeselected:(UITapGestureRecognizer *)recognizer
{
    if ([self.delegate respondsToSelector:@selector(pickerDidFinish:withSelectedIndex:)])
    {
        if (self.dateSelector)
        {
            [self.delegate pickerDidFinish:self withSelectedIndex:-1];
        }
        else
        {
            [self.delegate pickerDidFinish:self withSelectedIndex:self.selectedIndex];
        }
    }
    
    [self cleanUp];
}

- (void)pickerCancel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pickerDidCancel:)])
    {
        [self.delegate pickerDidCancel:self];
    }
    
    [self cleanUp];
}

- (void)cleanUp
{
    [UIView animateWithDuration:0.5 animations:^
    {
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, 216.0 + 44.0);
        self.pickerView.transform = CGAffineTransformMakeTranslation(0, 216 + 44.0);
    }
    completion:^(BOOL finished)
    {
        [self.pickerView removeFromSuperview];
        self.pickerView = nil;
        [self.transparentView removeFromSuperview];
        self.transparentView = nil;

        [self.toolbar removeFromSuperview];
        self.toolbar = nil;
    }];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex = row;
    
    if (row >= 0)
    {
        self.textLabel.text = [self.items[row] uppercaseString];
        
        if ([self.delegate respondsToSelector:@selector(pickerSelectionDidChange:toIndex:)])
        {
            [self.delegate pickerSelectionDidChange:self toIndex:row];
        }
    }
}

- (void)dateSelectionChanged:(id)sender
{
    if ([sender isKindOfClass:[UIDatePicker class]])
    {
        self.selectedDate = ((UIDatePicker *)sender).date;

        self.textLabel.text = [self.dateFormatter stringFromDate:self.selectedDate].uppercaseString;
        
        if ([self.delegate respondsToSelector:@selector(pickerSelectionDidChange:toIndex:)])
        {
            [self.delegate pickerSelectionDidChange:self toIndex:-1];
        }
    }
}

- (void)setItems:(NSArray *)items
{
    _items = items;

    if (items.count)
    {
        self.allowsTap = YES;
        self.selectedIndex = 0;
    }
    else
    {
        self.allowsTap = NO;
        self.selectedIndex = -1;
    }
    
    [self.pickerView reloadInputViews];
}

- (void)displayPicker
{
    [self tapRecognized:nil];
}

- (void)tapRecognized:(UITapGestureRecognizer *)recognizer
{
    if (self.pickerView || !self.allowsTap || (!self.items.count && !self.dateSelector) )
    {
        return;
    }
    
    //
    // We will create UIDatePicker here, and show it.
    //
    
    if (self.dateSelector)
    {
        UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height, 320.0, 216)];
        
        picker.datePickerMode = UIDatePickerModeDate;
        picker.minimumDate = [NSDate date];
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.month = 3;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        calendar.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        
        NSDate *endDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
        picker.maximumDate = endDate;
        
        if (self.selectedDate)
        {
            picker.date = self.selectedDate;
        }
        
        picker.backgroundColor = [UIColor whiteColor];
        
        [picker addTarget:self action:@selector(dateSelectionChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.pickerView = picker;
        [self.rootSuperview addSubview:self.pickerView];
        
        self.toolbar = [self addToolbarForPicker:picker];
        
        [UIView animateWithDuration:0.5 animations:^
        {
            self.toolbar.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - 216.0 - 64.0, 320.0, 44.0);
            self.pickerView.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - 216.0 - 64.0, 320.0, 216);
        }];
        
        [self dateSelectionChanged:picker];
    }
    else
    {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height, 320.0, 216)];
        
        picker.dataSource = self;
        picker.delegate = self;
        
        picker.backgroundColor = [UIColor whiteColor];
        
        self.pickerView = picker;
        [self.rootSuperview addSubview:self.pickerView];
        
        self.toolbar = [self addToolbarForPicker:picker];
        
        [UIView animateWithDuration:0.5 animations:^
        {
            self.toolbar.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - 216.0 - 64.0, 320.0, 44.0);
            self.pickerView.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - 216.0 - 64.0, 320.0, 216);
        }];
        
        if (self.items.count > self.selectedIndex)
        {
            [picker selectRow:self.selectedIndex inComponent:0 animated:YES];
            [self pickerView:(UIPickerView *)self.pickerView didSelectRow:self.selectedIndex inComponent:0];
        }
    }
    
    //
    // Should setup a tap gesture recognizer and a transparent view so we can cancel the picker.
    //
    self.transparentView = [[UIView alloc] initWithFrame:self.rootSuperview.bounds];
    self.transparentView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    UITapGestureRecognizer *tapRecognizer = nil;
    
    if (self.canCancel)
    {
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerCancel:)];
    }
    else
    {
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerDeselected:)];
    }
    
    [self.transparentView addGestureRecognizer:tapRecognizer];
    
    [self.rootSuperview insertSubview:self.transparentView belowSubview:self.pickerView];
}

- (UIToolbar *)addToolbarForPicker:(UIView *)picker
{
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320.0, 44.0)];
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDeselected:)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    if (self.canCancel)
    {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancel:)];
        
        toolBar.items = @[ cancelButton, flexibleSpace, button ];
    }
    else
    {
        toolBar.items = @[ flexibleSpace, button ];
    }

    [self.rootSuperview addSubview:toolBar];
    
    return toolBar;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.items[row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.items.count;
}

/*!
 * This method returns superview, so we do not place pickers inside a table or such.
 */
- (UIView *)rootSuperview
{
    UIView *superview = self.superview;
    
    while (![self isValidSuperview:superview])
    {
        superview = superview.superview;
    }
    
    return superview;
}

- (BOOL)isValidSuperview:(UIView *)view
{
    //
    // Check if we are embedded in scrollview
    //
    
    UIView *superview = view;
    
    while (superview)
    {
        if ([superview isKindOfClass:[UIScrollView class]])
        {
            return NO;
        }
        
        superview = superview.superview;
    }
    
    return YES;
}

@end
