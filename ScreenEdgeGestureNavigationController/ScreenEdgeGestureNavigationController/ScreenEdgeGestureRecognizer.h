//
//  ScreenEdgeGestureRecognizer.h
//  ScreenEdgeGestureNavigationController
//
//  Created by Robert Ryan on 4/11/14.
//  Copyright (c) 2014 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/
//

#import <UIKit/UIKit.h>

@class ScreenEdgeGestureRecognizer;

/** Screen edge gesture recognizer delegate protocol
 
 This protocol is adopted by the navigation controller subclass
 automatically, and is used by the gesture recognizer to determine
 whether the navigation controller subclass "knows" what the next
 view controller should be (either because it has it in its stack
 or because the child view controller has told it, in the absence
 of a view controller on the stack, which view controller is next.
 
 App developers generally will not need to use this protocol themselves,
 as this is merely used to communicate between the gesture recognizer
 and the navigation controller.
 
 ## License
 
 Copyright &copy; 2014 Robert Ryan. All rights reserved.
 
<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

 */
@protocol ScreenEdgeGestureRecognizerDelegate <NSObject>

/** First available previously popped view controller
 *
 * The navigation controller subclass can return to which view controller 
 * this gesture can be push. If there is no available view controller,
 * then the push gesture is disabled.
 *
 * App developers can call this method to divine whether there is a "next"
 * view controller (in case you wanted to present certain UI elements, 
 * like a "next" button) if and only if there was a previously popped or
 * predetermined "next" view controller.
 *
 * @return Return `nil` if there is no existing view controller available to
 *         push to. Otherwise, return the view controller.
 */
- (UIViewController *)firstPoppedViewController;

/** Delegate method to clean up if gesture was canceled.
 *
 * The gesture recognizer will call this clean-up method if the gesture was canceled.
 *
 * @param gesture The gesture recognizer.
 */
- (void)didCancelGesture:(UIGestureRecognizer *)gesture;

@end

/** Screen edge gesture recognizer
 
 This is the gesture recognizer used for both push and pop gestures,
 (swipe from right edge and swipe from left edge, respectively.
 
 This is a subclass of `UIScreenEdgePanGestureRecognizer`, a
 continuous gesture recognizer that will update the interaction
 controller (a `UIPercentDrivenInteractiveTransition`), which is
 used to specify how far to proceed along the animation specified
 in the transition animation controller. You generally will not have
 to interact with this class directly.
 
 Note, if you are using the gesture-based navigation controller, but
 your child view controller is using gestures of its own, you may
 want to call the `requireEdgeGesturesToFailForGestures` on that
 subclassed navigation controller, to make sure that these edge
 gestures take precedence. If you don't, the process of combining
 the edge swipe gesture with a table view, collection view, or
 any scroll view will be a little finicky (feeling a little arbitrary
 as to which gesture is recognized).
 
 ## License
 
 Copyright &copy; 2014 Robert Ryan. All rights reserved.
 
<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

 */
@interface ScreenEdgeGestureRecognizer : UIScreenEdgePanGestureRecognizer

/** Interaction controller
 *
 * This will be a `UIPercentDrivenInteractiveTransition` if an interactive
 * push or pop gesture is in progress, and will otherwise be `nil`.
 *
 * You do not need to interact with this directly (but this is exposed 
 * so the navigation controller subclass can respond to the
 * `interactionControllerForAnimationController` method.
 */

@property (nonatomic, strong, readonly) UIPercentDrivenInteractiveTransition *interactionController;

/* Initialize gesture recognizer
 *
 * @param  edges                 Which edge should the gesture recognizer.
 * @param  navigationController  The navigation controller subclass which will implement 
 *                               the interactive transition animation.
 *
 * @return                       A gesture recognizer
 */
- (instancetype)initWithEdges:(UIRectEdge)edges navigationController:(UINavigationController<ScreenEdgeGestureRecognizerDelegate> *)navigationController;

@end
