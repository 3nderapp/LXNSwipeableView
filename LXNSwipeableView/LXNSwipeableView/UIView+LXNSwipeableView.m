//
//  UIView+LXNSwipeableView.m
//  LXNSwipeableView
//
//  Created by Leszek Kaczor on 27/03/15.
//  Copyright (c) 2015 Leszek Kaczor. All rights reserved.
//

#import "UIView+LXNSwipeableView.h"
#import <objc/runtime.h>

NSString * const lxn_optionsKey     = @"lxn_optionsDictionaryKey";
NSString * const lxn_directionMask  = @"lxn_directionMaskKey";
NSString * const lxn_panRecognizer  = @"lxn_panRecognizerKey";
NSString * const lxn_delegateKey    = @"lxn_delegateKey";

NSString * const lxn_originalTransform = @"lxn_originalTransformKey";
NSString * const lxn_originalCenter    = @"lxn_originalCenterKey";

@implementation UIView (LXNSwipeableView)

#pragma mark - Public API

- (void)lxn_enableSwipeWithDirections:(LXNSwipeDirection)directions
{
    NSMutableDictionary * dict = [[self lxn_options] mutableCopy];
    dict[lxn_directionMask] = @(directions);
    [self lxn_updateOptions:[dict copy]];
    if (directions != LXNSwipeDirectionNone)
        [self lxn_addPanGesture];
    else
        [self lxn_removePanGesture];
}

- (void)lxn_setSwipeDelegate:(id<LXNSwipeableViewDelegate>)delegate
{
    objc_setAssociatedObject(self, (__bridge const void *)(lxn_delegateKey), delegate, OBJC_ASSOCIATION_ASSIGN);
}


#pragma mark - Private API

- (void)lxn_updateOptions:(NSDictionary *)options
{
    objc_setAssociatedObject(self, (__bridge const void *)(lxn_optionsKey), options, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)lxn_options
{
    NSDictionary * options = objc_getAssociatedObject(self, (__bridge const void *)(lxn_optionsKey));
    if (!options)
    {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        dict[lxn_directionMask] = @0;
        options = [dict copy];
    }
    return options;
}

- (id<LXNSwipeableViewDelegate>)lxn_swipeDelegate
{
    return objc_getAssociatedObject(self, (__bridge const void *)(lxn_delegateKey));
}

- (void)lxn_addPanGesture
{
    NSMutableDictionary * options = [[self lxn_options] mutableCopy];
    if (options[lxn_panRecognizer]) return;
    UIPanGestureRecognizer * recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(lxn_panAction:)];
    [recognizer setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:recognizer];
    options[lxn_panRecognizer] = recognizer;
    [self lxn_updateOptions:[options copy]];
}

- (void)lxn_removePanGesture
{
    NSMutableDictionary * options = [[self lxn_options] mutableCopy];
    UIPanGestureRecognizer * recognizer = options[lxn_panRecognizer];
    if (!recognizer) return;
    [self removeGestureRecognizer:recognizer];
    [options removeObjectForKey:lxn_panRecognizer];
    [self lxn_updateOptions:[options copy]];
}

- (NSInteger)lxn_directionMask
{
    NSNumber * directionMaskNumber = [[self lxn_options] valueForKey:lxn_directionMask];
    NSInteger direction = directionMaskNumber.integerValue;
    return direction;
}

- (void)lxn_setOriginalTransform:(CGAffineTransform)originalTransform
{
    NSMutableDictionary * transform = [NSMutableDictionary dictionary];
    transform[@"a"] = @(originalTransform.a);
    transform[@"b"] = @(originalTransform.b);
    transform[@"c"] = @(originalTransform.c);
    transform[@"d"] = @(originalTransform.d);
    transform[@"tx"] = @(originalTransform.tx);
    transform[@"ty"] = @(originalTransform.ty);
    objc_setAssociatedObject(self, (__bridge const void *)(lxn_originalTransform), transform, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGAffineTransform)lxn_originalTransform
{
    NSDictionary * transform = objc_getAssociatedObject(self, (__bridge const void *)(lxn_originalTransform));
    CGAffineTransform originalTransform;
    originalTransform.a = [(NSNumber *)transform[@"a"] floatValue];
    originalTransform.b = [(NSNumber *)transform[@"b"] floatValue];
    originalTransform.c = [(NSNumber *)transform[@"c"] floatValue];
    originalTransform.d = [(NSNumber *)transform[@"d"] floatValue];
    originalTransform.tx = [(NSNumber *)transform[@"tx"] floatValue];
    originalTransform.ty = [(NSNumber *)transform[@"ty"] floatValue];
    return originalTransform;
}

- (void)lxn_setOriginalCenter:(CGPoint)originalCenter
{
    NSMutableDictionary * center = [NSMutableDictionary dictionary];
    center[@"x"] = @(originalCenter.x);
    center[@"y"] = @(originalCenter.y);
    objc_setAssociatedObject(self, (__bridge const void *)(lxn_originalCenter), center, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGPoint)lxn_originalCenter
{
    NSDictionary * center = objc_getAssociatedObject(self, (__bridge const void *)(lxn_originalCenter));
    CGPoint originalPoint;
    originalPoint.x = [(NSNumber *)center[@"x"] floatValue];
    originalPoint.y = [(NSNumber *)center[@"y"] floatValue];
    return originalPoint;
}


#pragma mark - Gesture
- (void)lxn_panAction:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    NSInteger directionMask = [self lxn_directionMask];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self lxn_setOriginalTransform:view.transform];
        [self lxn_setOriginalCenter:view.center];
        if ([self lxn_swipeDelegate] && [[self lxn_swipeDelegate] respondsToSelector:@selector(swipeableViewStartDragging:)])
            [[self lxn_swipeDelegate] swipeableViewStartDragging:self];
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGAffineTransform originalTransform = [self lxn_originalTransform];
        CGPoint originalCenter = [self lxn_originalCenter];
        CGFloat duration = 0.5f;
        void (^animations)(void) = ^{
            view.transform = originalTransform;
            view.center = originalCenter;
        };
        if ([self lxn_swipeDelegate] && [[self lxn_swipeDelegate] respondsToSelector:@selector(swipeableViewShouldMoveToOrginalPosition:orginalTransform:originalCenter:)])
        {
            if ([[self lxn_swipeDelegate] swipeableViewShouldMoveToOrginalPosition:view orginalTransform:originalTransform originalCenter:originalCenter])
                [UIView animateWithDuration:duration animations:animations];
        } else {
            [UIView animateWithDuration:duration animations:animations];
        }
    } else {
        CGAffineTransform originalTransform = [self lxn_originalTransform];
        CGPoint originalCenter = [self lxn_originalCenter];
        CGPoint translation = [panGestureRecognizer translationInView:view];
        CGPoint newCenter = view.center;
        if (directionMask & LXNSwipeDirectionHorizontal)
            newCenter.x += translation.x;
        if (directionMask & LXNSwipeDirectionVertical)
            newCenter.y += translation.y;
        view.center = newCenter;
        [panGestureRecognizer setTranslation:CGPointZero inView:view];
        if ([self lxn_swipeDelegate] && [[self lxn_swipeDelegate] respondsToSelector:@selector(swipeableViewDidMove:orginalTransform:originalCenter:)])
            [[self lxn_swipeDelegate] swipeableViewDidMove:view orginalTransform:originalTransform originalCenter:originalCenter];
    }
}

@end
