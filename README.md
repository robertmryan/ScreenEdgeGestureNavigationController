# Screen Edge Gesture Navigation Controller

--

## Introduction

 iOS 7 introduced the "swipe from left edge of screen" in order to pop back to the previous
 view controller.
 
 This navigation controller subclass that not only does swipe from left to pop view controllers,
 but can also swipe from right to push back to a view controller from which we previously had popped.
 
 Optionally, a view controller can conform to `ScreenEdgeGestureNavigationController` and
 implement `nextViewController` so that this "push" gesture from the right edge of the screen
 will go to some predetermined view controller.

## Class Reference

Please see the [Class Reference](http://robertmryan.github.com/ScreenEdgeGestureNavigationController).

## Usage

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

## Demonstration

There are three scenarios illustrated in the demonstration project:

1. **No Predetermined "Next" Scene:** The first example illustrates the behavior of this `UINavigationController` behavior in a scenario where
    there is no predetermined "next" view controller (the user will pick which to push to), but I have:
    
 - Added a check to see if there is a popped view controller on the navigation controller's stack
   of previously popped view controllers;
      
 - If so, show "next" button that is linked to an `IBOutlet` that will perform `pushToNextViewController`.
    
 - If not, show "done" button that is connected to `IBOutlet` that does unwind segue to `MainViewController`
    
 When you use this, you'll see that the swipe from right edge does not do anything until you've popped from a view controller. 
 But, once you've popped from a view controller, both the "Next" button and the "swipe from right edge" will push to that previous 
 instance of that previously popped view controller.
 
 Also note, all of the view controllers are logging the `dealloc` event, so you can start to understand the memory management in play here.
 For example, if you push to "3", and then to "3.7", and then to "3.7.2", and then pop back twice to "3", you'll see nothing is deallocated. 
 But if you then push from "3" to "3.9", you'll see the view controllers previously associated with 3.7 and 3.7.2 will be deallocated.
 
 If you want to manually purge the stack of previously popped view controllers, you can call `removeAllPreviouslyPoppedViewControllers`.
 By default, this class will hold all previously popped view controllers (so you can push back to them), until you either remove them or
 you push to different view controller along a different path on your storyboard.
 
2. **Predetermined "Next" Scene:** The second example illustrates a scenario where you might have a predetermined series of scenes
 (e.g. "Step 1 of 3", "Step 2 of 3", and "Step 3 of 3"), and you want the "swipe from right edge" to push to the next step in the process
 even if you hadn't previously popped from that view controller.
 
 In this scenario, your child view controller simply needs to implement `nextViewController` method, and the navigation controller
 subclass will see that this method was implemented, and use it to determine what the "next" scene is.
 
 In this second example, I've also connected the "next" button to an `IBOutlet` that calls `pushToNextViewControllerAnimated`. In order
 to have the storyboard show the logical connection between the scenes, I've defined a push segue between the view controllers (not from
 the button to the next view controller, but rather between the view controllers). Note, I'm not using that segue (because segues will 
 generally instantiate a new view controller, which is not what I wanted here), but am using it so the storyboard visually represents 
 the logical relationship between the scenes.
 
3. **Standard push (no code):** In case you just want to use this `UINavigationController` subclass, without any of the code of the 
 previous two examples, this illustrates what happens when you just use this subclass in conjunction with an otherwise standard storyboard.
 Note, because the `nextViewController` method was not implemented, the "swipe from right edge" will not do anything until you've popped
 from a view controller. Also, because we're using standard segues (rather than optionally calling `pushToNextViewController`), it will
 instantiate a new view controller when you use the button on the scene, but it will use the previous popped instance if you use the 
 "swipe from right edge" gesture.

## License

Copyright &copy; 2014 Robert Ryan. All rights reserved.

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

--

11 April 2014