//
//  Toaster.h
//  tifen-ios-lib
//
//  Created by 7heaven on 15/11/17.
//  Copyright © 2015年 tifen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(int, ToastStyle){
    ToastStyleMiddleDark,
    ToastStyleUnderNavigationBar
};

//Toast的情境
typedef NS_ENUM(int, ToastContext){
    //正面消息展示情境
    ToastContextPositive,
    //负面消息展示情境
    ToastContextNegative,
    //中立
    ToastContextNeutral
};

typedef NS_ENUM(int, ToastOptionNames){
    ToastOptionNamesTextSize,
    ToastOptionNamesBgColorInt,
    ToastOptionNamesPadding
};

typedef struct ToasterOptions{
    CGFloat textSize;
    int textColorInt;
    int bgColorInt;
    UIEdgeInsets padding;
    int minHeight;
}ToasterOptions;

typedef NS_OPTIONS(int, ToastShowAlignment){
    ToastShowAlignmentCenter = 0x100,
      ToastShowAlignmentLeft = 0x001,
     ToastShowAlignmentRight = 0x002,
       ToastShowAlignmentTop = 0x010,
    ToastShowAlignmentBottom = 0x020
};

typedef NS_OPTIONS(int, ToastShowAlignmentMask){
     ToastShowAlignmentHorizonMask = 0x00F,
    ToastShowAlignmentVerticalMask = 0x0F0,
      ToastShowAlignmentCenterMask = 0xF00
};

@interface Toaster : NSObject

@property (nonatomic) ToastStyle style;
@property (nonatomic) ToastContext context;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *contentCover;
@property (nonatomic) NSTimeInterval duration;

@property (readonly, strong, nonatomic) CAAnimation *toastStartAnimation;
@property (readonly, strong, nonatomic) CAAnimation *toastEndAnimation;

- (instancetype) initWithStyle:(ToastStyle) style
                       context:(ToastContext) context
                       content:(NSString *) content
                       options:(NSDictionary *) options;

+ (instancetype) makeToastWithStyle:(ToastStyle) style
                            context:(ToastContext) context
                            content:(NSString *) content;
+ (instancetype) makeToastWithStyle:(ToastStyle) style
                            context:(ToastContext) context
                            content:(NSString *) content
                            options:(NSDictionary *) options;

- (void) show;
- (void) showShoudEnqueue:(BOOL)shoudEnqueue;
- (void) showAtY:(CGFloat) y;
- (void) showFor:(UIView *) view withAlignment:(int) alignment;

@end
