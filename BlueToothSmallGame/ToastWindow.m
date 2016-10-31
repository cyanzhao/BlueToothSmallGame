//
//  ToastWindow.m
//  tifen-ios-lib
//
//  Created by 7heaven on 15/11/17.
//  Copyright © 2015年 tifen. All rights reserved.
//

#import "ToastWindow.h"

@implementation ToastWindow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event{
    return [UIApplication sharedApplication].keyWindow;
}

@end
