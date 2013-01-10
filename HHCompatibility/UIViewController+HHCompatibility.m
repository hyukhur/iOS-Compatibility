//
//  UIViewController+HHCompatibility.m
//  HHCompatibility
//
//  Created by hyukhur on 13. 1. 9..
//  Copyright (c) 2013년 hyukhur. All rights reserved.
//

#import "UIViewController+HHCompatibility.h"

@implementation UIViewController (HHCompatibility)


- (UIViewController *)hh_presentedViewController
{
    return self.modalViewController;
}


- (void)hh_dismissViewControllerAnimated:(BOOL)flag completion: (void (^)(void))completion
{
    return [self dismissModalViewControllerAnimated:flag];
}


- (void)hh_presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion
{
    return [self presentModalViewController:viewControllerToPresent animated:flag];
}


@end
