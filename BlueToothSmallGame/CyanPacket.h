//
//  CyanPacket.h
//  BlueToothSmallGame
//
//  Created by cuiyan on 16/7/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    
    PacketTypeConfirmDieRoll,     //确认抽签结果
    PacketTypeDieRoll,      //抽签结果
    PacketTypeGoing,        //游戏进行中的数据
    PacketTypeOver          //游戏结束
    
}PacketType;

@interface CyanPacket : NSObject<NSCoding>

@property (nonatomic,assign) PacketType packetType;


@property (nonatomic,strong) NSArray *datas;
@property (nonatomic,assign) NSInteger dieRollNumber,passIndex,winFlag; //winFlag 输赢的标记 -1 输 0  无结果 1 赢


@end
