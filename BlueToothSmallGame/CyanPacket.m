

//
//  CyanPacket.m
//  BlueToothSmallGame
//
//  Created by cuiyan on 16/7/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "CyanPacket.h"

@implementation CyanPacket

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeInteger:_dieRollNumber forKey:@"dieRollNumber"];
    
    [aCoder encodeInteger:_packetType forKey:@"packetType"];
    
    [aCoder encodeObject:_datas forKey:@"datas"];
    
    
    [aCoder encodeInteger:_passIndex forKey:@"passIndex"];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        self.dieRollNumber= (NSInteger)[aDecoder decodeIntegerForKey:@"dieRollNumber"];
        
        self.packetType = (PacketType)[aDecoder decodeIntegerForKey:@"packetType"];
        
        self.datas = (NSArray *)[aDecoder decodeObjectForKey:@"datas"];
        
        
        self.passIndex = (NSInteger )[aDecoder decodeIntegerForKey:@"passIndex"];

    }
    
    return self;
    
    return nil;
}

@end
