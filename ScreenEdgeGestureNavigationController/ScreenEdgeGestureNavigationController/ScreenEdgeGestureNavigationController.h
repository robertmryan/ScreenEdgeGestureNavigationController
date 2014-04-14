//
//  PushNavigationController.h
//  ScreenEdgeGestureNavigationController
//
//  Created by Robert Ryan on 4/11/14.
//  Copyright (c) 2014 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/
//

#import <UIKit/UIKit.h>
#import "ScreenEdgeGestureRecognizer.h"

/** Gesture navigation controller delegate.
 
 Protocol adopted by child view controllers if they want to specify some "next view controller"
 so that the "gesture navigation controller" knows whether to enable the "swipe from right edge
 to push" gesture, even in the absence of any previously popped view controller on the stack.

 ## License
 
 Copyright &copy; 2014 Robert Ryan. All rights reserved.
 
<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

 */


@protocol ScreenEdgeGestureNavigationControllerDelegate <NSObject>

/** Next view controller
 
 What is the instance of the view controller that that we should push to. If you want to return
 to the same instance of this view controller every time, you may want to instantiate this
 "next view controller" only once and keep track of it in some instance variable or the like.
 
 #### Usage
 
 For example your view controller might have a method that looks like:
 
    - (UIViewController *)nextViewController
    {
        if (!_nextViewController) {
            UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationStep2"];
            _nextViewController = controller;
        }
 
        return _nextViewController;
    }
 
 @note Often in these cases, one might be inclined to use a `static` but, in most cases it will 
       probably be safer to use an instance variable.
 */
- (UIViewController *) nextViewController;

@end

/** Screen edge gesture navigation controller.
 
 iOS 7 introduced the "swipe from left edge of screen" in order to pop back to the previous
 view controller.
 
 This navigation controller subclass that not only does swipe from left to pop view controllers,
 but can also swipe from right to push back to a view controller from which we previously had popped.
 
 Optionally, a view controller can conform to `ScreenEdgeGestureNavigationController` and
 implement `nextViewController` so that this "push" gesture from the right edge of the screen
 will go to some predetermined view controller.
 
 ##Usage:
 
 1. Add the source files in the `ScreenEdgeGestNavigationController` folder to your project.
    Note, do not add the Demostration files.
 
 2. In your project's Storyboard, change the custom class of the navigation controller to be this
    `ScreenEdgeGestureNavigationController`, custom gesture based navigation controller.

    By doing this, if you enable the basic feature by which it remembers which view controllers
    you've popped from, and in those cases, enable the "push edge swipe" (swipe from right edge
    of the screen).
 
    In the demonstration project, this is what is called the "no predetermined sequence".
 
 3. If you have some predetermined order in which you want to transition between a series of
    scenes, you can simple have each view controller return a `nextViewController`
 
    In the demonstration project, this is what is called the "predetermined sequence".
 
 ## Warning
 
 > In iOS 7, the top and bottom layout guides seem to not work properly with custom transitions, so it
 is probably easiest to simply disable the "extend edges" from underneath the top and bottom bars.

 ## License
 
 Copyright &copy; 2014 Robert Ryan. All rights reserved.
 
<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

 
 */

@interface ScreenEdgeGestureNavigationController : UINavigationController <ScreenEdgeGestureRecognizerDelegate>

/// -------------------------------------
/// @name Configure child view controller
/// -------------------------------------

/** Require edge gestures to fail.
 
 This can be used by any view that has its own gestures, whereby we can configure
 them to require the edge gestures to fail. If you don't call this when you have
 a scroll view based view, you can have problem having the edge gestures from being
 recognized correctly.
 
 #### Usage
 
    [navigationController requireEdgeGesturesToFailForGestures:self.tableView.gestureRecognizers];
 
 @param gestures  The array of `UIGestureRecognizer` objects that will be configured
                  to require the edge gestures to fail before being recognized themselves.
 */

- (void)requireEdgeGesturesToFailForGestures:(NSArray *)gestures;

/// ------------------------------------------------------------------------
/// @name Navigation
/// ------------------------------------------------------------------------

/** Push to next view controller, if any.
 *
 * @param animated Specify YES to animate the transition or NO if you do not want 
 *                 the transition to be animated.
 *
 * @return         Return `YES` is there was a view controller to push to. Return `NO` if not.
 */
- (BOOL)pushToNextViewControllerAnimated:(BOOL)animated;

/// ------------------------------------------------------------------------
/// @name Reset the navigation controller
/// ------------------------------------------------------------------------

/** Remove all previously popped view controllers.
 *
 * This will clear the stack of "previously popped" view controllers, in order to either
 * (a) free them, such as in low memory conditions; or (b) to clear the stack so that
 * the swipe to last popped view controller is prevented.
 *
 * A possible example where this might be needed is if you pushed to a registration process,
 * and then popped back when all done. You might not want the "swipe to push" gesture to
 * start leading the user back through the registration process.
 */
- (void)removeAllPreviouslyPoppedViewControllers;

@end
