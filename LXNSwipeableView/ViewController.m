//
//  ViewController.m
//  LXNSwipeableView
//
//  Created by Leszek Kaczor on 27/03/15.
//  Copyright (c) 2015 Leszek Kaczor. All rights reserved.
//

#import "ViewController.h"
#import "UIView+LXNSwipeableView.h"

@interface ViewController () <LXNSwipeableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *swipeableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.swipeableView lxn_enableSwipeWithDirections:LXNSwipeDirectionVertical | LXNSwipeDirectionHorizontal];
    [self.swipeableView lxn_setSwipeDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LXNSwipeableViewDelegate
- (BOOL)swipeableViewShouldMoveToOrginalPosition:(UIView *)view orginalTransform:(CGAffineTransform)transform originalCenter:(CGPoint)center
{
    return YES;
}

- (void)swipeableViewDidMove:(UIView *)view orginalTransform:(CGAffineTransform)transform originalCenter:(CGPoint)center
{
    view.transform = CGAffineTransformMakeRotation((view.center.x - center.x)/1000);;
}

#pragma mark - UICollectionViewDataSource & Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"testCell" forIndexPath:indexPath];
    return cell;
}

@end
