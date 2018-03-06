//
//  SecondViewController.m
//  Warrior
//
//  Created by Alana Kamahele on 1/31/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

#import "SecondViewController.h"
#import "WeekendWarrior-Swift.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)distanceSliderChanged:(id)sender {
    self.hourDistanceLabel.text = [NSString stringWithFormat:@"%d hr",
                                   (int) roundf(self.hourDistancePicker.value * 9) + 1];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"trailTableSegue"]){
        TrailTableViewController *controller = (TrailTableViewController *)segue.destinationViewController;
        controller.userCoordinate = self.homebaseCoordinate;
    }
}

@end
