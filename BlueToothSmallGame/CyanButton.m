
//
//  CyanButton.m
//  BlueToothSmallGame
//
//  Created by cuiyan on 16/7/25.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "CyanButton.h"

@implementation CyanButton


- (void)setFlag:(ButtonFlag)flag{
    
    if (flag == ButtonFlagNone) {
        
        [self setBackgroundImage:nil forState:(UIControlStateNormal)];
        
    }else if (flag == ButtonFlagWhite){
        
        [self setBackgroundImage:[UIImage imageNamed:@"white.jpg"] forState:(UIControlStateNormal)];
        
    }else if (flag == ButtonFlagBlack){
        
        [self setBackgroundImage:[UIImage imageNamed:@"black.jpg"] forState:(UIControlStateNormal)];
    }
    _flag = flag;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
