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

@interface ViewController () <GMSAutocompleteResultsViewControllerDelegate>

@end

@implementation ViewController {
    GMSAutocompleteResultsViewController *_resultsViewController;
    UISearchController *_searchController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _resultsViewController = [[GMSAutocompleteResultsViewController alloc] init];
    _resultsViewController.delegate = self;
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_resultsViewController];
    _searchController.searchResultsUpdater = _resultsViewController;
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 175.0, 250, 32)];
    [subView addSubview:_searchController.searchBar];
    [_searchController.searchBar sizeToFit];
    [self.view addSubview:subView];
    
    self.definesPresentationContext = YES;
    [self becomeFirstResponder];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(130, 258, 170, 32)];
    [button addTarget:self
               action:@selector(buttonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [button setBackgroundColor:[UIColor colorWithRed:252.0f/255.0f
                                               green:194.0f/255.0f
                                                blue:189.0f/255.0f
                                               alpha:1.0f]];
    [button setTitle:@"Plan My Weekend!" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    button.enabled = TRUE;
    button.layer.cornerRadius = 10;
    [self.view addSubview:button];
    self.clickyButton.clipsToBounds = true;
    self.clickyButton.enabled = true;
}
    
- (void)buttonAction:(id)sender {
    [self performSegueWithIdentifier:@"optionsSegue" sender:sender];
}

// Handle the user's selection.
- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    self.coordinates = place.coordinate;
    _searchController.searchBar.text = place.name;
}

- (void)resultsController:(GMSAutocompleteViewController *)viewController
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
- (void)didRequestAutocompletePredictionsForResultsController:(GMSAutocompleteResultsViewController *)resultsController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictionsForResultsController:(GMSAutocompleteResultsViewController *)resultsController {
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
    
    //    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    //    acController.delegate = self;
    //    [self presentViewController:acController animated:YES completion:nil];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
    
- (IBAction)hourDistancePickerr:(id)sender {
}
    
@end

