//
//  ViewController.m
//  Warrior
//
//  Created by Alana Kamahele on 1/24/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import <GooglePlaces/GooglePlaces.h>

@interface ViewController () <GMSAutocompleteViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.clickyButton.layer.cornerRadius = 10;
    self.clickyButton.clipsToBounds = true;
}

// Present the autocomplete view controller when the button is pressed.
//- (IBAction)onLaunchClicked:(id)sender {
//    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
//    acController.delegate = self;
//    [self presentViewController:acController animated:YES completion:nil];
//}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    self.coordinates = place.coordinate;
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"optionsSegue"]){
        SecondViewController *controller = (SecondViewController *)segue.destinationViewController;
        controller.homebaseCoordinate = self.coordinates;
    }
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
    
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)hourDistancePickerr:(id)sender {
}
@end

