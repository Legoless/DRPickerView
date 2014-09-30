//
//  DRPickerView.h
//  DRPickerView
//
//  Created by Dal Rupnik on 01/04/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

@protocol DRPickerDelegate <NSObject>

@optional
- (void)pickerSelectionDidChange:(id)sender toIndex:(NSInteger)index;
- (void)pickerDidFinish:(id)sender withSelectedIndex:(NSInteger)index;
- (void)pickerDidCancel:(id)sender;

@end

@interface DRPickerView : UIView

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *dropDownImageView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicatorView;
@property (nonatomic, weak) id<DRPickerDelegate> delegate;

@property (nonatomic, copy) NSArray *items;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic) BOOL dateSelector;
@property (nonatomic) BOOL allowsTap;
@property (nonatomic) BOOL canCancel;

- (void)displayPicker;

@end
