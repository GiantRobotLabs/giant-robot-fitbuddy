//
//  UIView+Autolayout.m
//  FitBuddy
//
//  Created by john.neyer on 2/1/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import "UIView+Autolayout.h"

@implementation UIView (Autolayout)
+(id)autolayoutView
{
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}
@end

