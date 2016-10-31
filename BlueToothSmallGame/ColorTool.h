//
//  ColorTool.m
//  gezilicai
//
//  Created by 7heaven on 1/29/16.
//  Copyright © 2016 yuexue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//方便通过十六进制颜色值取得UIColor

@interface ColorTool : NSObject

+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (NSString *) colorToHexString:(UIColor *) color;
+ (UIColor *) colorFromHex:(int32_t) hex;
+ (int32_t) colorToInt:(UIColor *) color;

+ (UIColor *) mixColorFrom:(UIColor *) fromColor to:(UIColor *) toColor alpha:(float) alpha;

+ (BOOL) color:(UIColor *) color0 compareWithColor:(UIColor *) color1;

@end
