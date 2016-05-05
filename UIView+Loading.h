//
//  UIView+Loading.h
//  ALPHA
//
//  Created by mac on 16/5/3.
//  Copyright © 2016年 汤威. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, ALLoadingViewStateType) {
    ALLoadingViewStateTypeNoNetwork,
    ALLoadingViewStateTypeOther,
    ALLoadingViewStateTypeLoading
};

UIKIT_EXTERN NSString * const ALLoadingViewMessageLoading;
UIKIT_EXTERN NSString * const ALLoadingViewMessageNoNetwork;

@interface UIView (LoadingView)

- (void)showLoadingView:(ALLoadingViewStateType)stateType withMessage:(NSString *)message;
- (void)showLoading;

// message请不要为空或者空格
- (void)showMessage:(NSString *)message;
- (void)showMessage:(NSString *)message withHiddenTime:(CGFloat)time;

//message如果不传将默认成暂无网络
- (void)showNoNetWork:(NSString *)message withTimeHidden:(CGFloat)time;
- (void)hideHUD;
@end