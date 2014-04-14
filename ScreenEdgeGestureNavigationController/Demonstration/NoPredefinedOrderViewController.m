//
//  NoPredeterminedOrderViewController.m
//  ScreenEdgeGestureNavigationController
//
//  Created by Robert Ryan on 4/11/14.
//  Copyright (c) 2014 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/
//

#import "NoPredefinedOrderViewController.h"
#import "ScreenEdgeGestureNavigationController.h"

@interface NoPredefinedOrderViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NoPredefinedOrderViewController

// Just so we can see when this is deallocated

- (void)dealloc
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, self.title);
}

// When the view is loaded, build title from the `NSIndexPath` property, e.g. "3.2.5".
// This is for testing purposes, just so we can see how we got here.

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.indexPath) {
        self.title = [self indexPathString:self.indexPath];
    } else {
        self.title = @"Pick Row";
    }

    [(ScreenEdgeGestureNavigationController *)self.navigationController requireEdgeGesturesToFailForGestures:self.tableView.gestureRecognizers];
}

// utility method to convert indexPath to a pretty string in the form of x.y.z...

- (NSString *)indexPathString:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < self.indexPath.length; i++) {
        [array addObject:[NSString stringWithFormat:@"%lu", (unsigned long)[self.indexPath indexAtPosition:i]]];
    }
    
    return [array componentsJoinedByString:@"."];
}

// When the view (re)appears, show a "next" button if there is an available "next" scene

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UIViewController *nextController = [(ScreenEdgeGestureNavigationController *)self.navigationController firstPoppedViewController];
    if (nextController) {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(didSelectNext:)];
        [self.navigationItem setRightBarButtonItem:button];
    } else {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didSelectDone:)];
        [self.navigationItem setRightBarButtonItem:button];
    }
}

// if the user tapped on next, then push to whatever was on the stack of previously popped view controllers

- (void)didSelectNext:(id)sender
{
    [(ScreenEdgeGestureNavigationController *)self.navigationController pushToNextViewControllerAnimated:YES];
}

- (void)didSelectDone:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

// Populate table view with rows that just bear the numbers 0-99

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];

    return cell;
}

#pragma mark - UITableViewDelegate

/* If row is selected, add selected row to self.indexPath and then push to this same
 * view controller. This is not a pattern that you're likely to use in a production
 * app, but it's just a useful way of allowing us to keep selecting rows from the
 * tableview and have the title reflect the whole history of rows you selected.
 *
 * For example, if, when this is first presented, you tap on the third row, and then 
 * tap on the seventh row of the next table view, and then tap on the second  row of
 * that table view, the resulting scene will bear a title of `3.7.2`. This is just 
 * very useful technique so that when you pop these off and then try to push back to 
 * them, you can see that the app remembers which view controllers you had previously
 * popped off.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *newIndexPath;

    if (self.indexPath) {
        newIndexPath = [self.indexPath indexPathByAddingIndex:indexPath.row];
    } else {
        newIndexPath = [NSIndexPath indexPathWithIndex:indexPath.row];
    }

    NoPredefinedOrderViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"NoPredefinedOrderViewController"];
    controller.indexPath = newIndexPath;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
