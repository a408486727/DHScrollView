//
//  DHScrollView.m
//  DHScrollView
//
//  Created by xuchuanqi on 2016/10/10.
//  Copyright © 2016年 xuchuanqi. All rights reserved.
//

#import "DHScrollView.h"


@interface DHScrollView()
{
    BOOL isAllowAuto;
}
@property (nonatomic, readonly) UIView *bottomView;
@property (nonatomic, readonly) UIView *middleView;
@property (nonatomic, readonly) UIView *topView;

@property (nonatomic) NSInteger showIndex;

@end

@implementation DHScrollView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self functionInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self functionInit];
    }
    return self;
}

- (void)functionInit
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self addGestureRecognizer:pan];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self addGestureRecognizer:tap];
    
    for (int i = 0; i < 3; i++) {
        UIView *view = [[UIView alloc] init];

        [self addSubview:view];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subview]|" options:0 metrics:nil views:@{ @"subview" : view }]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subview]|" options:0 metrics:nil views:@{ @"subview" : view }]];
    }
}

- (void)setDataSource:(id<DHScrollViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self updateContainerViewsForIndex:0];
}

- (UIView *)dequeueReusableCellForIndexPath:(NSInteger)index
{
    return nil;
}

- (void)startAutoAnimation
{
    isAllowAuto = YES;
    [self autoChangeAnimation];
}

- (void)stopAutoAnimation
{
    isAllowAuto = NO;
    [self removeAnimation];
}

- (void)setShowIndex:(NSInteger)showIndex
{
    _showIndex = showIndex;
    
    [self updateContainerViewsForIndex:showIndex];

    if (self.delegate && [self.delegate respondsToSelector:@selector(didMoveToIndex:)]) {
        [self.delegate didMoveToIndex:showIndex];
    }
    
    if (isAllowAuto) {
        [self autoChangeAnimation];
    }
}

- (void)updateContainerViewsForIndex:(NSInteger)index
{
    UIView *nextCell = [self cellForRowAtIndex:[self nextIndexWithShowIndex:index]];
    [self.topView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.topView addSubview:nextCell];
    nextCell.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subview]|" options:0 metrics:nil views:@{ @"subview" : nextCell }]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subview]|" options:0 metrics:nil views:@{ @"subview" : nextCell }]];
    
    UIView *curCell = [self cellForRowAtIndex:index];
    [self.middleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.middleView addSubview:curCell];
    curCell.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subview]|" options:0 metrics:nil views:@{ @"subview" : curCell }]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subview]|" options:0 metrics:nil views:@{ @"subview" : curCell }]];
    
    UIView *preCell = [self cellForRowAtIndex:[self preIndexWithShowIndex:index]];
    [self.bottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.bottomView addSubview:preCell];
    preCell.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subview]|" options:0 metrics:nil views:@{ @"subview" : preCell }]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subview]|" options:0 metrics:nil views:@{ @"subview" : preCell }]];
    
    [self defaultState];
}

#pragma mark - Animation
- (void)autoChangeAnimation
{
    [self defaultState];
    [UIView animateKeyframesWithDuration:AutoAnimationDuration delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.8 animations:^{
            self.topView.transform = CGAffineTransformIdentity;
            self.topView.alpha = 0;
            self.middleView.transform = CGAffineTransformMakeScale(0.96, 0.96);
            self.middleView.alpha = 1;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
            self.topView.transform = CGAffineTransformIdentity;
            self.topView.alpha = 1;
            self.middleView.transform = CGAffineTransformMakeScale(0.95, 0.95);
            self.middleView.alpha = 0;
        }];
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self.bottomView bringSubviewToFront:self];
            self.showIndex = [self nextIndexWithShowIndex:self.showIndex];
        }else
        {
            [self defaultState];
        }
    }];
}

- (void)rightChangeAnimation
{
    self.topView.transform = CGAffineTransformMakeTranslation(60, 0);
    self.topView.alpha = 0;
    self.middleView.transform = CGAffineTransformIdentity;
    self.middleView.alpha = 1;
    self.bottomView.transform = CGAffineTransformIdentity;
    self.bottomView.alpha = 0;
    
    [UIView animateWithDuration:AutoAnimationDuration animations:^{
        self.topView.transform = CGAffineTransformIdentity;
        self.topView.alpha = 1;
        self.middleView.transform = CGAffineTransformIdentity;
        self.middleView.alpha = 0;
        self.bottomView.transform = CGAffineTransformIdentity;
        self.bottomView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)leftChangeAnimation
{
    self.topView.transform = CGAffineTransformIdentity;
    self.topView.alpha = 0;
    self.middleView.transform = CGAffineTransformIdentity;
    self.middleView.alpha = 1;
    self.bottomView.transform = CGAffineTransformMakeTranslation(-60, 0);
    self.bottomView.alpha = 0;
    
    [UIView animateWithDuration:AutoAnimationDuration animations:^{
        self.topView.transform = CGAffineTransformIdentity;
        self.topView.alpha = 0;
        self.middleView.transform = CGAffineTransformIdentity;
        self.middleView.alpha = 0;
        self.bottomView.transform = CGAffineTransformIdentity;
        self.bottomView.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)removeAnimation
{
    [self.middleView.layer removeAllAnimations];
    [self.topView.layer removeAllAnimations];
    [self.bottomView.layer removeAllAnimations];
    [self defaultState];
}

#pragma mark - GestureRecognizer
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtIndex:)])
        {
            [self.delegate didSelectRowAtIndex:self.showIndex];
        }
    }
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)sender
{
    CGFloat x = [sender translationInView:self].x;
    
    static UIInterfaceOrientation oldOri;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            [self removeAnimation];
            self.topView.layer.speed = 0;
            self.middleView.layer.speed = 0;
            self.bottomView.layer.speed = 0;
            oldOri = UIInterfaceOrientationUnknown;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            UIInterfaceOrientation newOri = UIInterfaceOrientationUnknown;
            if (x > 0) {
                newOri = UIInterfaceOrientationLandscapeLeft;
            }
            if (x < 0) {
                newOri = UIInterfaceOrientationLandscapeRight;
            }
            
            if (oldOri == newOri)
            {
                x/=200.0f;
                self.topView.layer.timeOffset = MIN(0.999, fabs(x))*AutoAnimationDuration;
                self.middleView.layer.timeOffset = MIN(0.999, fabs(x))*AutoAnimationDuration;
                self.bottomView.layer.timeOffset = MIN(0.999, fabs(x))*AutoAnimationDuration;
            }else
            {
                oldOri = newOri;
                [self removeAnimation];
                if (newOri == UIInterfaceOrientationLandscapeLeft) {
                    [self leftChangeAnimation];
                }
                if (newOri == UIInterfaceOrientationLandscapeRight) {
                    [self rightChangeAnimation];
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (fabs(x) > 100)
            {
                self.topView.layer.speed = 1;
                self.middleView.layer.speed = 1;
                self.bottomView.layer.speed = 1;
                if (oldOri == UIInterfaceOrientationLandscapeLeft) {
                    [self.topView sendSubviewToBack:self];
                    self.showIndex = [self preIndexWithShowIndex:self.showIndex];
                }
                if (oldOri == UIInterfaceOrientationLandscapeRight) {
                    [self.bottomView bringSubviewToFront:self];
                    self.showIndex = [self nextIndexWithShowIndex:self.showIndex];
                }
            }else
            {
                [self removeAnimation];
                self.topView.layer.speed = 1;
                self.middleView.layer.speed = 1;
                self.bottomView.layer.speed = 1;
                self.showIndex = self.showIndex;
            }

            break;
        }
        default:
            break;
    }
}

#pragma mark - Data Source
- (NSInteger)numberOfRows
{
    return [self.dataSource numberOfRowsInScrollView:self];
}

- (UIView *)cellForRowAtIndex:(NSInteger)index
{
    return [self.dataSource scrollView:self cellForRowAtIndex:index];
}

#pragma mark - Private

- (void)defaultState
{
    self.topView.transform = CGAffineTransformIdentity;
    self.topView.alpha = 0;
    self.middleView.transform = CGAffineTransformIdentity;
    self.middleView.alpha = 1;
    self.bottomView.transform = CGAffineTransformIdentity;
    self.bottomView.alpha = 0;
}

- (NSInteger)nextIndexWithShowIndex:(NSInteger)showIndex
{
    if (showIndex + 1 == self.numberOfRows)
    {
        return 0;
    }else
    {
        return showIndex + 1;
    }
}

- (NSInteger)preIndexWithShowIndex:(NSInteger)showIndex
{
    if (showIndex == 0)
    {
        return self.numberOfRows - 1;
    }else
    {
        return showIndex - 1;
    }
}

- (UIView *)topView
{
    return self.subviews[2];
}

- (UIView *)middleView
{
    return self.subviews[1];
}

- (UIView *)bottomView
{
    return self.subviews[0];
}

@end
