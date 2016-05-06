## LXNSwipeableView

This is the repository for LXNSwipeableView.

## Installation

Add following line to your Podfile

```
pod 'LXNSwipeableView', :git => "https://bitbucket.org/ducker/lxnswipeableview.git"
```

If no cocoapods installed go to http://cocoapods.org for further informations.

## Usage

LXNSwipeableView is category to UIView which adds ability to swipe view using UIPanGestureRecognizer.

```objective-c
    [self.swipeableView lxn_enableSwipeWithDirections:LXNSwipeDirectionVertical | LXNSwipeDirectionHorizontal];
    [self.swipeableView lxn_setSwipeDelegate:self];
```

It adds also protocol LXNSwipeableViewDelegate to UIView.

```objective-c
@protocol LXNSwipeableViewDelegate <NSObject>

@optional
- (BOOL)swipeableViewShouldMoveToOrginalPosition:(UIView * )view orginalTransform:(CGAffineTransform)transform originalCenter:(CGPoint)center;
- (void)swipeableViewDidMove:(UIView * )view orginalTransform:(CGAffineTransform)transform originalCenter:(CGPoint)center;

@end
```