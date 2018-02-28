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
    
//    coordinates of SF
//    CLLocationCoordinate2D trail = CLLocationCoordinate2DMake(37.773972, -122.431297);
//    [self calculateDistance:trail];
}

- (void)calculateDistance:(CLLocationCoordinate2D)trailCoordinates {
    CLLocation *trailLocation = [[CLLocation alloc] initWithLatitude:trailCoordinates.latitude longitude:trailCoordinates.longitude];
    CLLocation *homebaseLocation = [[CLLocation alloc] initWithLatitude:self.homebaseCoordinate.latitude longitude:self.homebaseCoordinate.longitude];
    
    CLLocationDistance meters = [homebaseLocation distanceFromLocation:trailLocation];
    
    NSLog(@"Distance in miles: %f", meters * 0.000621371);
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
