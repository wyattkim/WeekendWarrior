//
//  ViewController.m
//  Warrior
//
//  Created by Alana Kamahele on 1/24/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.clickyButton.layer.cornerRadius = 10;
    self.clickyButton.clipsToBounds = true;
}

- (IBAction)handleSearchClick:(id)sender {
    self.helloLabel.text = @"Weekend Warrior";
}
- (IBAction)distanceSliderChanged:(id)sender {
    // Set the label text to the value of the slider as it changes
    self.hourDistanceLabel.text = [NSString stringWithFormat:@"%d hr",
                                   (int) roundf(self.hourDistancePicker.value * 9) + 1];
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.customTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)hourDistancePickerr:(id)sender {
}
@end

