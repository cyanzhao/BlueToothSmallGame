//
//  ColorTool.m
//  gezilicai
//
//  Created by 7heaven on 1/29/16.
//  Copyright © 2016 yuexue. All rights reserved.
//

#import "ColorTool.h"

@implementation ColorTool

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
    BOOL alphaInvoked = NO;
    
    if ([hexString hasPrefix:@"#"]) {
        [scanner setScanLocation:1];
        if ([hexString length] >= 9) {
            alphaInvoked = YES;
        }
    }
    if ([hexString hasPrefix:@"0x"]) {
        [scanner setScanLocation:2];
        if ([hexString length] >= 10) {
            alphaInvoked = YES;
        }
    }
    
    [scanner scanHexInt:&rgbValue];
    
    CGFloat alphaValue = ((rgbValue & 0xFF000000) >> 24) / 255.0F;
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0F
                           green:((rgbValue & 0x00FF00) >> 8) / 255.0F
                            blue:(rgbValue & 0x0000FF) / 255.0F
                           alpha:alphaInvoked ? alphaValue : 1.0F];
}

+ (NSString *) colorToHexString:(UIColor *) color{
    size_t cpntNum = CGColorGetNumberOfComponents(color.CGColor);
    const CGFloat *cpnt = CGColorGetComponents(color.CGColor);
    
    NSString *hexString = [NSString stringWithFormat:@"%02X%02X%02X", (int) (cpnt[0] * 255), (int) (cpnt[1] * 255), (int) (cpnt[2] * 255)];
    
    if(cpntNum == 4){
        hexString = [[NSString stringWithFormat:@"%02X", (int) (cpnt[3] * 255)] stringByAppendingString:hexString];
    }
    
    return [@"0x" stringByAppendingString:hexString];
}

+ (UIColor *) colorFromHex:(int32_t) hex{
    int a = hex >> 24 & 0xFF;
    int r = hex >> 16 & 0xFF;
    int g = hex >> 8 & 0xFF;
    int b = hex & 0xFF;
    
    if(a == 0 && (r != 0 || g != 0 || b != 0)) a = 0xFF;
    
    return [UIColor colorWithRed:r / 255.F green:g / 255.F blue:b / 255.F alpha:a / 255.F];
}

+ (int32_t) colorToInt:(UIColor *) color{
    size_t cpntNum = CGColorGetNumberOfComponents(color.CGColor);
    const CGFloat *cpnt = CGColorGetComponents(color.CGColor);
    
    unsigned char r = (unsigned char) (cpnt[0] * 255);
    unsigned char g = (unsigned char) (cpnt[1] * 255);
    unsigned char b = (unsigned char) (cpnt[2] * 255);
    
    unsigned char a = cpntNum == 4 ? (unsigned char) (cpnt[3] * 255) : 0;
    
    return (a & 0xFF) << 24 | (r & 0xFF) << 16 | (g & 0xFF) << 8 | (b & 0xFF);
}

+ (UIColor *) mixColorFrom:(UIColor *) fromColor to:(UIColor *) toColor alpha:(float) alpha{
    
    if(alpha >= 1 || alpha <= 0) alpha = 1;
    
    size_t fromNum = CGColorGetNumberOfComponents(fromColor.CGColor);
    const CGFloat *fromCpnt = CGColorGetComponents(fromColor.CGColor);
    
    size_t toNum = CGColorGetNumberOfComponents(toColor.CGColor);
    const CGFloat *toCpnt = CGColorGetComponents(toColor.CGColor);
    
    CGFloat dr = (toCpnt[0] - fromCpnt[0]) * (1.0F - alpha);
    CGFloat dg = (toCpnt[1] - fromCpnt[1]) * (1.0F - alpha);
    CGFloat db = (toCpnt[2] - fromCpnt[2]) * (1.0F - alpha);
    CGFloat da = (fromNum == toNum && toNum == 4) ? fromCpnt[3] + ((toCpnt[3] - fromCpnt[3]) * (1.0F - alpha)) : 1;
    
    return [UIColor colorWithRed:fromCpnt[0] + dr
                           green:fromCpnt[1] + dg
                            blue:fromCpnt[2] + db
                           alpha:da];
}

+ (BOOL) color:(UIColor *) color0 compareWithColor:(UIColor *) color1{
    size_t fromNum = CGColorGetNumberOfComponents(color0.CGColor);
    const CGFloat *fromCpnt = CGColorGetComponents(color0.CGColor);
    
    size_t toNum = CGColorGetNumberOfComponents(color1.CGColor);
    const CGFloat *toCpnt = CGColorGetComponents(color1.CGColor);
    
    if(fromNum != toNum) return NO;
    
    if(fromNum == 4){
        return fromCpnt[0] == toCpnt[0] &&
        fromCpnt[1] == toCpnt[1] &&
        fromCpnt[2] == toCpnt[2] &&
        fromCpnt[3] == toCpnt[3];
    }else{
        return fromCpnt[0] == toCpnt[0] &&
        fromCpnt[1] == toCpnt[1] &&
        fromCpnt[2] == toCpnt[2];
    }
}

@end
