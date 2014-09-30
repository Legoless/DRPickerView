//
//  DKViewController.m
//  Demo
//
//  Created by Dal Rupnik on 18/05/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

#import <DRPickerView/DRPickerView.h>

#import "DKViewController.h"

@interface DKViewController ()

@property (weak, nonatomic) IBOutlet DRPickerView *customPicker;
@property (weak, nonatomic) IBOutlet DRPickerView *datePicker;

@end

@implementation DKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.customPicker.items = @[ @"Test", @"Test 1", @"Test 2" ];
	
}

@end
