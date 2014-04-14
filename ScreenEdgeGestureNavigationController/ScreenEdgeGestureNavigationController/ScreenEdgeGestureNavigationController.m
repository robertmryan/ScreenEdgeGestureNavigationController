//
//  PushNavigationController.m
//  ScreenEdgeGestureNavigationController
//
//  Created by Robert Ryan on 4/11/14.
//  Copyright (c) 2014 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/
//

#import "ScreenEdgeGestureNavigationController.h"
#import "ScreenEdgeGestureRecognizer.h"
#import "ScreenEdgeGesturePushAnimator.h"
#import "ScreenEdgeGesturePopAnimator.h"


static NSString * const kScreenEdgeGestureNavigationControllerVersion = @"1.0.0";


@interface ScreenEdgeGestureNavigationController () <UINavigationControllerDelegate, ScreenEdgeGestureRecognizerDelegate>

// gesture recognizers

@property (nonatomic, strong) ScreenEdgeGestureRecognizer *pushGesture;  // Push gesture recognizer (i.e. swipe from right edge)
@property (nonatomic, strong) ScreenEdgeGestureRecognizer *popGesture;   // Pop gesture recognizer (i.e. swipe from left edge)

// stack of view controllers we have popped from

@property (nonatomic, strong) NSMutableArray *poppedViewControllers;     // Array of previously popped view controllers (if any), most recently popped at the end

// state variables of a push or pop that is in progress

@property (nonatomic) UINavigationControllerOperation transitionType;    // Whether there is a push or pop transition in progress
@property (nonatomic, strong) UIViewController *controllerToPushTo;      // If we're pushing, which view controller are we pushing to.
@property (nonatomic, strong) NSArray *controllersToPopFrom;             // If we're popping, which view controller(s) we're popping off

@end

@implementation ScreenEdgeGestureNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.poppedViewControllers = [[NSMutableArray alloc] init];
    
    [super setDelegate:self];

    self.pushGesture = [[ScreenEdgeGestureRecognizer alloc] initWithEdges:UIRectEdgeRight navigationController:self];
    [self.view addGestureRecognizer:self.pushGesture];

    self.popGesture = [[ScreenEdgeGestureRecognizer alloc] initWithEdges:UIRectEdgeLeft navigationController:self];
    [self.view addGestureRecognizer:self.popGesture];
}

- (void)removeAllPreviouslyPoppedViewControllers
{
    self.poppedViewControllers = nil;
}

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    NSAssert(FALSE, @"You cannot set the delegate for this UINavigationController subclass!");
}

- (void)requireEdgeGesturesToFailForGestures:(NSArray *)gestures
{
    for (UIGestureRecognizer *gesture in gestures) {
        [gesture requireGestureRecognizerToFail:self.pushGesture];
        [gesture requireGestureRecognizerToFail:self.popGesture];
    }
}

- (BOOL)pushToNextViewControllerAnimated:(BOOL)animated
{
    UIViewController *nextController = [self firstPoppedViewController];
    
    if (nextController) {
        [self pushViewController:nextController animated:YES];
        return YES;
    }
    
    return NO;
}

#pragma mark - UINavigationController methods

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    self.transitionType = UINavigationControllerOperationPop;
    self.controllersToPopFrom = @[[super popViewControllerAnimated:animated]];
    self.controllerToPushTo = nil;

    return self.controllersToPopFrom[0];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.transitionType = UINavigationControllerOperationPop;
    self.controllersToPopFrom = [super popToViewController:viewController animated:animated];
    self.controllerToPushTo = nil;

    return self.controllersToPopFrom;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    self.transitionType = UINavigationControllerOperationPop;
    self.controllersToPopFrom = [super popToRootViewControllerAnimated:animated];
    self.controllerToPushTo = nil;

    return self.controllersToPopFrom;
}

- (void)pushViewController:(UIViewController *)controller animated:(BOOL)animated
{
    self.transitionType = UINavigationControllerOperationPush;
    self.controllerToPushTo = controller;
    self.controllersToPopFrom = nil;
    
    [super pushViewController:controller animated:animated];
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPush)
        return [[ScreenEdgeGesturePushAnimator alloc] init];

    if (operation == UINavigationControllerOperationPop)
        return [[ScreenEdgeGesturePopAnimator alloc] init];

    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController*)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController
{
    id <UIViewControllerInteractiveTransitioning>interactionController;
    
    if ((interactionController = self.pushGesture.interactionController))
        return interactionController;
    
    if ((interactionController = self.popGesture.interactionController))
        return interactionController;
    
    return nil;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.transitionType == UINavigationControllerOperationPush) {
        if ([self.poppedViewControllers lastObject] == self.controllerToPushTo) {
            [self.poppedViewControllers removeLastObject];
        } else {
            [self.poppedViewControllers removeAllObjects];
        }
    } else if (self.transitionType == UINavigationControllerOperationPop) {
        [self.controllersToPopFrom enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIViewController *controller, NSUInteger idx, BOOL *stop) {
            [self.poppedViewControllers addObject:controller];
        }];
    }
    
    self.controllerToPushTo   = nil;
    self.controllersToPopFrom = nil;
    self.transitionType       = UINavigationControllerOperationNone;
}

#pragma mark - ScreenEdgeGestureRecognizerDelegate

- (UIViewController *)firstPoppedViewController
{
    UIViewController *next = nil;
    
    if (self.transitionType == UINavigationControllerOperationPush) {                // if we're pushing ...
        if ([self.poppedViewControllers lastObject] == self.controllerToPushTo) {    // ... on to the next item in our stack ...
            NSInteger index = [self.poppedViewControllers count] - 2;
            if (index >= 0) {
                next = [self.poppedViewControllers objectAtIndex:index];             // ... then find the penultimate item.
            }
        }
    } else if (self.transitionType == UINavigationControllerOperationPop) {          // if we're popping ...
        next = [self.controllersToPopFrom firstObject];                              // ... then get item at the top of the pop stack
    } else {
        next = [self.poppedViewControllers lastObject];                              // if we're not in the middle of a transition, then just get top item on stack
    }
    
    // if we have next view controller sitting on the stack, then let's just go there
    
    if (next)
        return next;
    
    // if not, we'll see if view controller wants to volunteer the next view controller, and is so, use it
    
    UIViewController<ScreenEdgeGestureNavigationControllerDelegate> *current = [self.viewControllers lastObject];
    if ([current respondsToSelector:@selector(nextViewController)])
        return [current nextViewController];
    
    // otherwise specify that there is no available/predefined "next" view controller (and thus push gesture will fail)
    
    return nil;
}

- (void)didCancelGesture:(ScreenEdgeGestureRecognizer *)gesture
{
    self.controllerToPushTo   = nil;
    self.controllersToPopFrom = nil;
    self.transitionType       = UINavigationControllerOperationNone;
}

@end
