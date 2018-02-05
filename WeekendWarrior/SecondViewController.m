//
//  SecondViewController.m
//  Warrior
//
//  Created by Alana Kamahele on 1/31/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)distanceSliderChanged:(id)sender {
    self.hourDistanceLabel.text = [NSString stringWithFormat:@"%d hr",
                                   (int) roundf(self.hourDistancePicker.value * 9) + 1];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
