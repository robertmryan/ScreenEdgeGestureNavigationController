//
//  PushAnimator.h
//  ScreenEdgeGestureNavigationController
//
//  Created by Robert Ryan on 4/11/14.
//  Copyright (c) 2014 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/
//

#import <Foundation/Foundation.h>

/** Push animator
 
 This is the instance of the transition animation controller (an object conforming
 to `UIViewControllerAnimatedTransitioning`), which specifies the duration of
 the animation, as well as what precisely the animation is.
 
 If you want to change the push animation, modify the `animateTransition` method.
 
 ## License
 
 Copyright &copy; 2014 Robert Ryan. All rights reserved.
 
<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

 */
@interface ScreenEdgeGesturePushAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@end
