//
//  PredeterminedThreeViewController.m
//  ScreenEdgeGestureNavigationController
//
//  Created by Robert Ryan on 4/11/14.
//  Copyright (c) 2014 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/
//

#import "PredeterminedThreeViewController.h"

@interface PredeterminedThreeViewController ()

@end

@implementation PredeterminedThreeViewController

// Just so we can see when this is deallocated

- (void)dealloc
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// Because this is the last view controller, nothing else is needed here

// The "Done" button is linked to an unwind segue, so no code is needed.

@end
