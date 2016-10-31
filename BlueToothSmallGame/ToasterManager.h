//
//  ToasterManager.h
//  tifen-ios-lib
//
//  Created by 7heaven on 15/11/17.
//  Copyright © 2015年 tifen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFQueue.h"

@class Toaster;

@interface ToasterManager : NSObject{
    TFQueue *_toastQueue;
}

@property (nonatomic,assign) BOOL shouldEnqueue;

+ (instancetype) sharedManager;

- (void) addToQueue:(Toaster *) toaster;

@end
