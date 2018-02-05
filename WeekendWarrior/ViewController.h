//
//  ViewController.h
//  Warrior
//
//  Created by Alana Kamahele on 1/24/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *customTextField;
@property (weak, nonatomic) IBOutlet UILabel *helloLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickyButton;
@property (weak, nonatomic) IBOutlet UILabel *motto;
@property (weak, nonatomic) IBOutlet UIImageView *background;


@property (weak, nonatomic) IBOutlet UISlider *hourDistancePicker;
@property (weak, nonatomic) IBOutlet UILabel *hourDistanceLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;

@end

