//
//  UIView+Loading.m
//  ALPHA
//
//  Created by mac on 16/5/3.
//  Copyright © 2016年 汤威. All rights reserved.
//

#import "UIView+Loading.h"
#import <objc/runtime.h>

@interface ALLoadingView : UIView
@property (nonatomic,strong) UIActivityIndicatorView *activity;
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,copy) NSString *message;
@end

@implementation ALLoadingView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activity.hidesWhenStopped = YES;
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.font = [UIFont systemFontOfSize:16];
    self.messageLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.activity];
    [self addSubview:self.messageLabel];
}

@end

NSString * const ALLoadingViewMessageLoading = @"正在加载...";
NSString * const ALLoadingViewMessageNoNetwork = @"暂无网络...";

static char *loadingKey = "loadingKey";
@implementation UIView (Loading)

// 由于公司提示语有限，不超过一行，所以作者只设计了一行的情况，多行的需要各位朋友重新算frame。修改下就可。
- (void)showLoadingView:(ALLoadingViewStateType)stateType withMessage:(NSString *)message
{
    CGSize size = [message sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName ,nil]];
    ALLoadingView *loadView = objc_getAssociatedObject(self, &loadingKey);
    if (!loadView) {
        loadView = [[ALLoadingView alloc] init];
        loadView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        loadView.layer.cornerRadius = 4;
        [loadView clipsToBounds];
        [self addSubview:loadView];
        objc_setAssociatedObject(self, &loadingKey, loadView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (stateType == ALLoadingViewStateTypeLoading) {
        loadView.frame = CGRectMake(0, 0, size.width + 20, size.height + 40);
        loadView.activity.frame = CGRectMake(loadView.center.x - 10, loadView.center.y - 22, 20,20);
        loadView.messageLabel.frame = CGRectMake(10, 32, size.width, size.height);
        [loadView.activity startAnimating];
    }else {
        loadView.frame = CGRectMake(0, 0, size.width + 20, size.height + 20);
        loadView.messageLabel.frame = CGRectMake(10, 10, size.width, size.height);
        [loadView.activity stopAnimating];
    }
    
    loadView.center = self.center;
    loadView.messageLabel.text = message;
    [loadView bringSubviewToFront:self];
    loadView.hidden = NO;
}

- (void)showLoading
{
    [self showLoadingView:ALLoadingViewStateTypeLoading withMessage:ALLoadingViewMessageLoading];
}

- (void)showMessage:(NSString *)message
{
    if ([self isMessage:message]) {
        [self showLoadingView:ALLoadingViewStateTypeOther withMessage:message];
    }else {
        // 待补充其他情况处理
    }
}

- (void)showMessage:(NSString *)message withHiddenTime:(CGFloat)time
{
    if ([self isMessage:message]) {
        [self showLoadingView:ALLoadingViewStateTypeOther withMessage:message];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHUD];
    });
}

- (void)showNoNetWork:(NSString *)message withTimeHidden:(CGFloat)time
{
    if ([self isMessage:message]) {
        [self showLoadingView:ALLoadingViewStateTypeNoNetwork withMessage:message];
    }else {
        [self showLoadingView:ALLoadingViewStateTypeNoNetwork withMessage:ALLoadingViewMessageNoNetwork];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHUD];
    });
}

- (BOOL)isMessage:(NSString *)message
{
    if (message && ![message isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

- (void)hideHUD
{
    ALLoadingView *loadView = objc_getAssociatedObject(self, &loadingKey);
    [loadView.activity stopAnimating];
    loadView.hidden = YES;
}

@end
