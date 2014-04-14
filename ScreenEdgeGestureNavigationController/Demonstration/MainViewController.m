//
//  MainViewController.m
//  ScreenEdgeGestureNavigationController
//
//  Created by Robert Ryan on 4/11/14.
//  Copyright (c) 2014 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/
//

#import "MainViewController.h"
#import "ScreenEdgeGestureNavigationController.h"

@interface MainViewController ()

@end

@implementation MainViewController

// The transitions to the various scenes is done entirely using segues in the
// storyboard from a static table view, so code needed here

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [(ScreenEdgeGestureNavigationController *)self.navigationController requireEdgeGesturesToFailForGestures:self.tableView.gestureRecognizers];
}

- (IBAction)unwindToHomeScreen:(UIStoryboardSegue *)segue
{
    // nothing needed inside here; just here so we can do unwind segue
}

@end
