//
//  TFQueue.h
//  tifen-ios-lib
//
//  Created by 7heaven on 11/27/15.
//  Copyright © 2015 tifen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFQueue : NSObject{
    NSMutableArray *_queue;
}

@property (readonly, nonatomic) int count;

- (void) enqueue:(id) object;
- (id) dequeue;
- (void) clear;

@end
