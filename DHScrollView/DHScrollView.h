//
//  DHScrollView.h
//  DHScrollView
//
//  Created by xuchuanqi on 2016/10/10.
//  Copyright © 2016年 xuchuanqi. All rights reserved.
//

#import <UIKit/UIKit.h>

static float AutoAnimationDuration = 5;

@class DHScrollView;

@protocol DHScrollViewDataSource <NSObject>

- (NSInteger)numberOfRowsInScrollView:(DHScrollView *)scrollView;
- (UIView *)scrollView:(DHScrollView *)scrollView cellForRowAtIndex:(NSInteger)index;

@end

@protocol DHScrollViewDelegate <NSObject>

- (void)didSelectRowAtIndex:(NSInteger)index;
- (void)didMoveToIndex:(NSInteger)index;
- (void)willStartAutoAnimation;

@end

@interface DHScrollView : UIView

@property (nonatomic, weak)id<DHScrollViewDataSource> dataSource;
@property (nonatomic, weak)id<DHScrollViewDelegate> delegate;

- (UIView *)dequeueReusableCellForIndexPath:(NSInteger)index;

- (void)startAutoAnimation;
- (void)stopAutoAnimation;

@end


