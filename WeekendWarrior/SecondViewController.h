//
//  SecondViewController.h
//  Warrior
//
//  Created by Alana Kamahele on 1/31/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SecondViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *hourDistancePicker;
@property (weak, nonatomic) IBOutlet UILabel *hourDistanceLabel;
@property (nonatomic, assign) CLLocationCoordinate2D homebaseCoordinate;

@end
