//
//  UIView+LXNSwipeableView.h
//  LXNSwipeableView
//
//  Created by Leszek Kaczor on 27/03/15.
//  Copyright (c) 2015 Leszek Kaczor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LXNSwipeDirectionNone       = 0,
    LXNSwipeDirectionVertical   = 1,
    LXNSwipeDirectionHorizontal = 2,
} LXNSwipeDirection;

@protocol LXNSwipeableViewDelegate <NSObject>

@optional
- (void)swipeableViewStartDragging:(UIView *)view;
- (BOOL)swipeableViewShouldMoveToOrginalPosition:(UIView * )view orginalTransform:(CGAffineTransform)transform originalCenter:(CGPoint)center;
- (void)swipeableViewDidMove:(UIView * )view orginalTransform:(CGAffineTransform)transform originalCenter:(CGPoint)center;

@end

@interface UIView (LXNSwipeableView)

- (void)lxn_enableSwipeWithDirections:(LXNSwipeDirection)directions;
- (void)lxn_setSwipeDelegate:(id<LXNSwipeableViewDelegate>)delegate;

@end
