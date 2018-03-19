//
//  SDMHorizontalLayoutView.m
//  SDLayoutView
//
//  Created by Tyrone Trevorrow on 18/04/12.
//  Copyright (c) 2012 Sudeium. All rights reserved.
//

#import "SDMHorizontalLayoutView.h"

@implementation SDMHorizontalLayoutView

- (void) layoutSubviews
{
    [super layoutSubviews];
    NSArray *subviewsToLayout = [self subviews];
    UIView *lastSubview = nil;
    CGSize remainingSize = self.bounds.size;
    for (UIView *subview in subviewsToLayout) {
        CGSize subviewSize = [subview sizeThatFits: remainingSize];
        CGFloat subviewWidth = subviewSize.width;
        CGRect subviewFrame = subview.frame;
        subviewFrame.size.width = subviewWidth;
        if (lastSubview) {
            subviewFrame.origin.x = lastSubview.frame.origin.x + lastSubview.frame.size.width + self.spacing;
        } else {
            subviewFrame.origin.x = 0;
        }
        subview.frame = subviewFrame;
        lastSubview = subview;
        remainingSize.width -= subviewWidth;
    }
}

- (CGSize) sizeThatFits: (CGSize) size
{
    NSArray *subviewsToLayout = [self subviews];
    CGFloat runningTotal = 0.0f;
    BOOL first = YES;
    CGSize remainingSize = size;
    for (UIView *subview in subviewsToLayout) {
        if (first) {
            first = NO;
            runningTotal += subview.frame.origin.x;
        }
        CGFloat subviewWidth = [subview sizeThatFits: remainingSize].width;
        runningTotal += subviewWidth;
        remainingSize.width -= subviewWidth;
    }
    return CGSizeMake(MIN(size.width, runningTotal), size.height);
}

@end