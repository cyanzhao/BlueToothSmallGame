//
//  ToasterManager.m
//  tifen-ios-lib
//
//  Created by 7heaven on 15/11/17.
//  Copyright © 2015年 tifen. All rights reserved.
//

#import "ToasterManager.h"
#import "Toaster.h"

@interface ToasterManager(){
    BOOL _inToastAction;
}

@end

@implementation ToasterManager

+ (instancetype) sharedManager{
    static ToasterManager *sharedToasterManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedToasterManager = [[ToasterManager alloc] init];
    });
    
    return sharedToasterManager;
}

- (instancetype) init{
    if(self = [super init]){
        _toastQueue = [[TFQueue alloc] init];
        _shouldEnqueue = YES;
    }
    
    return self;
}

- (void) addToQueue:(Toaster *)toaster{
    if(_toastQueue.count || _inToastAction){
        [_toastQueue enqueue:toaster];
    }else{
        [self toast:toaster shouldEnqueue:_shouldEnqueue];
    }
}

- (void) toast:(Toaster *) toaster shouldEnqueue:(BOOL)shouldEnqueue{
    if(toaster.contentView){
        _inToastAction = YES && shouldEnqueue;
        UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
        
        [currentWindow addSubview:toaster.contentCover];
        
        if(toaster.toastStartAnimation){
            [toaster.contentView.layer addAnimation:toaster.toastStartAnimation forKey:@"toastStarted"];
        }
        
        __weak typeof(self) _weakSelf = self;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(toaster.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(toaster.toastEndAnimation){
                NSTimeInterval duration = toaster.toastEndAnimation.duration - 0.05F;
                
                [toaster.contentView.layer removeAllAnimations];
                [toaster.contentView.layer addAnimation:toaster.toastEndAnimation forKey:@"toastEnded"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [toaster.contentView.layer removeAllAnimations];
                    [toaster.contentCover removeFromSuperview];
                    _inToastAction = NO;
                    
                    [_weakSelf scheduleNext];
                });
            }else{
                [toaster.contentCover removeFromSuperview];
                _inToastAction = NO;
                [_weakSelf scheduleNext];
            }
        });
    }
}

- (void) scheduleNext{
    if(_toastQueue.count && !_inToastAction){
        Toaster *toaster = [_toastQueue dequeue];
        [self toast:toaster shouldEnqueue:_shouldEnqueue];
    }
}

@end
