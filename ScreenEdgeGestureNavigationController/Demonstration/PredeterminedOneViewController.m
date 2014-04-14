//
//  RegistrationOneViewController.m
//  ScreenEdgeGestureNavigationController
//
//  Created by Robert Ryan on 4/11/14.
//  Copyright (c) 2014 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/
//

#import "PredeterminedOneViewController.h"

@interface PredeterminedOneViewController ()

@property (nonatomic, weak) UIViewController *nextViewController;

@end

@implementation PredeterminedOneViewController

// Just so we can see when this is deallocated

- (void)dealloc
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// Because we specify `nextViewController`, you can now do "swipe from right edge"
// to push to that next view controller (even if we hadn't already popped from it).
//
// Because we're saving this in an class property, when you pop back to this, it will
// keep that instance of PredeterminedTwoViewController in memory, so if you push again
// (using the `didTouchUpInsideNextButton` method or via swipe) it won't have to reinstantiate
// it every time.
//
// Alternatively, you could reinstantiate that next view controller every time and
// not use this class property. It just depends upon the desired UX and memory management.

- (UIViewController *)nextViewController
{
    if (!_nextViewController) {
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PredeterminedTwoViewController"];
        self.nextViewController = controller;
    }
    
    return _nextViewController;
}

// When you tap on the "Next" button, it will push to `nextViewController`

- (IBAction)didTouchUpInsideNextButton:(id)sender
{
    [self.navigationController pushViewController:self.nextViewController animated:YES];
}

@end
