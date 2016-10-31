//
//  TFQueue.m
//  tifen-ios-lib
//
//  Created by 7heaven on 11/27/15.
//  Copyright © 2015 tifen. All rights reserved.
//

#import "TFQueue.h"

@implementation TFQueue

- (instancetype) init{
    if(self = [super init]){
        _queue = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) enqueue:(id) object{
    [_queue addObject:object];
}
- (id) dequeue{
    id object = nil;
    
    if(_queue.count > 0){
        object = [[[_queue lastObject] retain] autorelease];
        
        [_queue removeLastObject];
    }
    
    return object;
}
- (void) clear{
    [_queue removeAllObjects];
}

- (int) count{
    return (int)_queue.count;
}

- (void) dealloc{
    [_queue release];
    [self dealloc];
    [super dealloc];
}

@end
