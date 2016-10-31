//
//  CyanButton.h
//  BlueToothSmallGame
//
//  Created by cuiyan on 16/7/25.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    ButtonFlagNone,
    ButtonFlagWhite,
    ButtonFlagBlack
    
}ButtonFlag;

@interface CyanButton : UIButton

@property (nonatomic,assign) ButtonFlag flag;

@end
