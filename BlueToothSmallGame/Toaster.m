//
//  Toaster.m
//  tifen-ios-lib
//
//  Created by 7heaven on 15/11/17.
//  Copyright © 2015年 tifen. All rights reserved.
//

#import "Toaster.h"
#import "ToasterManager.h"

#define DEFAULT_TEXT_SIZE 16
#define DEFAULT_PADDING 12
#define DEFAULT_ANIMATION_DURATION 0.3F
#define DEFAULT_DURATION 2.5F

@interface Toaster(){
    UILabel *_contentLabel;
    UIImageView *_contentImageView;
    
    NSString *_contentText;
    
    UIView *_contentCover;
    
    CAAnimation *_toastStartAnimation;
    CAAnimation *_toastEndAnimation;
}
@end

@implementation Toaster

- (instancetype) initWithStyle:(ToastStyle)style context:(ToastContext)context content:(NSString *) content options:(NSDictionary *)options{
    if(self = [super init]){
        self.duration = DEFAULT_DURATION;
        _contentText = content == nil || content.length == 0 ? @"" : content;
        
        _contentView = [[UIView alloc] init];
        _contentCover = [[UIView alloc] init];
        
        _contentLabel = [[UILabel alloc] init];
        
        ToasterOptions defaultOptions = {
            DEFAULT_TEXT_SIZE,
            0xFFFFFFFF,
            0xCCFFFFFF,
            UIEdgeInsetsMake(DEFAULT_PADDING, DEFAULT_PADDING, DEFAULT_PADDING, DEFAULT_PADDING),
            0
        };
        
        switch(style){
            case ToastStyleMiddleDark:
                defaultOptions.bgColorInt = 0xCC000000;
                defaultOptions.minHeight = 44;
                break;
            case ToastStyleUnderNavigationBar:
                defaultOptions.minHeight = 32;
                defaultOptions.padding = UIEdgeInsetsMake(DEFAULT_PADDING, 0, DEFAULT_PADDING, 0);
                switch(context){
                    case ToastContextNegative:
                        defaultOptions.bgColorInt = 0xCCFF7373;
                        break;
                    case ToastContextPositive:
                    case ToastContextNeutral:
                        defaultOptions.bgColorInt = 0xCC00CC9C;
                        break;
                }
                break;
        }
        
        if(options && options.allKeys.count > 0){
            for(NSNumber *key in options.allKeys){
                ToastOptionNames keyInt = [key intValue];
                id value = options[key];
                switch(keyInt){
                    case ToastOptionNamesBgColorInt:
                        defaultOptions.bgColorInt = [value intValue];
                        break;
                    case ToastOptionNamesPadding:
                        defaultOptions.padding = [value UIEdgeInsetsValue];
                        break;
                    case ToastOptionNamesTextSize:
                        defaultOptions.textSize = [value floatValue];
                        break;
                }
            }
        }
        
        CGFloat maxWidth = [UIApplication sharedApplication].keyWindow.bounds.size.width;
        
        _contentView.layer.backgroundColor = color(defaultOptions.bgColorInt).CGColor;
        [_contentLabel setFont:[UIFont systemFontOfSize:defaultOptions.textSize]];
        [_contentLabel setTextColor:color(defaultOptions.textColorInt)];
        [_contentLabel setText:_contentText];
        [_contentLabel setTextAlignment:NSTextAlignmentCenter];
        _contentLabel.numberOfLines = 0;
        
        switch(style){
            case ToastStyleMiddleDark:{
                _contentView.layer.masksToBounds = YES;
                _contentView.layer.cornerRadius = 12;
                
                maxWidth = maxWidth - DEFAULT_PADDING - DEFAULT_PADDING;
                CGSize contentSize = [_contentLabel sizeThatFits:CGSizeMake(maxWidth - defaultOptions.padding.left - defaultOptions.padding.right, 99999)];
                
                _contentLabel.frame = (CGRect){(contentSize.width + defaultOptions.padding.left + defaultOptions.padding.right - contentSize.width) / 2, contentSize.height > defaultOptions.minHeight ? defaultOptions.padding.top : (defaultOptions.minHeight - contentSize.height) / 2, contentSize.width, contentSize.height};
                _contentLabel.frame = CGRectIntegral(_contentLabel.frame);
                
                _contentView.frame = (CGRect){CGPointZero, contentSize.width + defaultOptions.padding.left + defaultOptions.padding.right, contentSize.height > defaultOptions.minHeight ? contentSize.height + defaultOptions.padding.top + defaultOptions.padding.bottom : defaultOptions.minHeight};
                _contentView.frame = CGRectIntegral(_contentView.frame);
                
                [_contentView addSubview:_contentLabel];
                
                CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                startAnimation.fromValue = @0.0F;
                startAnimation.toValue = @1.0F;
                startAnimation.duration = DEFAULT_ANIMATION_DURATION;
                startAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                
                _toastStartAnimation = startAnimation;
                
                CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                endAnimation.fromValue = @1.0F;
                endAnimation.toValue = @0.0F;
                endAnimation.duration = DEFAULT_ANIMATION_DURATION;
                endAnimation.fillMode = kCAFillModeForwards;
                endAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                
                _toastEndAnimation = endAnimation;
            }
                break;
            case ToastStyleUnderNavigationBar:{
                CGSize contentSize = [_contentLabel sizeThatFits:CGSizeMake(maxWidth - defaultOptions.padding.left - defaultOptions.padding.right - (context == ToastContextNeutral ? 0 : 16 + 12), 99999)];
                
                CGFloat realContentWidth = contentSize.width;
                
                if(context != ToastContextNeutral){
                    
                    realContentWidth += 16 + 8;
                    
                    _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake((maxWidth - realContentWidth) / 2, contentSize.height > defaultOptions.minHeight ? (contentSize.height + defaultOptions.padding.top + defaultOptions.padding.bottom - 16) / 2 : (defaultOptions.minHeight - 16) / 2, 16, 16)];
                    
                    switch(context){
                        case ToastContextNegative:
                            _contentImageView.image = [UIImage imageNamed:@"icon_toast_negative"];
                            break;
                        case ToastContextNeutral:
                        case ToastContextPositive:
                            _contentImageView.image = [UIImage imageNamed:@"icon_toast_positive"];
                            break;
                    }
                    
                    [_contentView addSubview:_contentImageView];
                }
                
                _contentLabel.frame = (CGRect){(maxWidth - realContentWidth) / 2 + 16 + 8, contentSize.height > defaultOptions.minHeight ? defaultOptions.padding.top : (defaultOptions.minHeight - contentSize.height) / 2, contentSize.width, contentSize.height};
                _contentLabel.frame = CGRectIntegral(_contentLabel.frame);
                
                _contentView.frame = (CGRect){CGPointZero, maxWidth, contentSize.height > defaultOptions.minHeight ? contentSize.height + defaultOptions.padding.top + defaultOptions.padding.bottom : defaultOptions.minHeight};
                _contentView.frame = CGRectIntegral(_contentView.frame);
                [_contentView addSubview:_contentLabel];
                
                CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
                startAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -_contentView.frame.size.height, 0)];
                startAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
                startAnimation.duration = DEFAULT_ANIMATION_DURATION;
                startAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                
                _toastStartAnimation = startAnimation;
                
                CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
                endAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
                endAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -_contentView.frame.size.height, 0)];
                endAnimation.duration = DEFAULT_ANIMATION_DURATION;
                endAnimation.fillMode = kCAFillModeForwards;
                endAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                
                _toastEndAnimation = endAnimation;
            }
                break;
        }
        
        _contentCover.frame = _contentView.frame;
        _contentCover.layer.masksToBounds = YES;
        [_contentCover addSubview:_contentView];
    }
    
    return self;
}

+ (instancetype) makeToastWithStyle:(ToastStyle)style context:(ToastContext)context content:(NSString *)content{
    return [Toaster makeToastWithStyle:style context:context content:content options:nil];
}

+ (instancetype) makeToastWithStyle:(ToastStyle)style context:(ToastContext)context content:(NSString *) content options:(NSDictionary *)options{
    Toaster *toaster = [[Toaster alloc] initWithStyle:style context:context content:content options:options];
    
    
    return toaster;
}

- (void) show{

    return [self showShoudEnqueue:NO];
}

- (void) showShoudEnqueue:(BOOL)shoudEnqueue{
    
    if(_contentCover && _contentView){
        UIWindow *currentWindow = [[UIApplication sharedApplication].windows lastObject];
        _contentCover.frame = (CGRect) {CGPointMake((currentWindow.bounds.size.width - _contentView.frame.size.width) / 2, (currentWindow.bounds.size.height - _contentView.frame.size.height) / 2), _contentView.frame.size};
        _contentCover.frame = CGRectIntegral(_contentCover.frame);
        
        [ToasterManager sharedManager].shouldEnqueue = shoudEnqueue;
        [[ToasterManager sharedManager] addToQueue:self];
    }
}



- (void) showAtY:(CGFloat) y{
    if(_contentCover && _contentView){
        UIWindow *currentWindow = [[UIApplication sharedApplication].windows lastObject];
        
        _contentCover.frame = (CGRect) {CGPointMake((currentWindow.bounds.size.width - _contentView.frame.size.width) / 2, y), _contentView.frame.size};
        _contentCover.frame = CGRectIntegral(_contentCover.frame);
        
        [[ToasterManager sharedManager] addToQueue:self];
    }
}

- (void) showFor:(UIView *) view withAlignment:(int) alignment{
    
    if(!view.superview || !_contentCover || !_contentView) return;
    
    CGPoint locationInWindow = [view.superview convertPoint:view.frame.origin toView:[UIApplication sharedApplication].keyWindow];
    
    int horizonAlignment = alignment & ToastShowAlignmentHorizonMask;
    int verticalAlignment = alignment & ToastShowAlignmentVerticalMask;
    int centerAlignment = alignment & ToastShowAlignmentCenterMask;
    
    if(centerAlignment == ToastShowAlignmentCenter){
        _contentCover.frame = (CGRect) {CGPointMake(locationInWindow.x + (view.frame.size.width - _contentCover.frame.size.width) / 2, locationInWindow.y + (view.frame.size.height - _contentCover.frame.size.height) / 2), _contentCover.frame.size};
        _contentCover.frame = CGRectIntegral(_contentCover.frame);
    }else{
        
        CGPoint newPoint;
        
        switch(horizonAlignment){
            case ToastShowAlignmentLeft:
                newPoint.x = locationInWindow.x;
                break;
            case ToastShowAlignmentRight:
                newPoint.x = locationInWindow.x + view.frame.size.width - _contentCover.frame.size.width;
                break;
            default:
                newPoint.x = locationInWindow.x + (view.frame.size.width - _contentCover.frame.size.width) / 2;
                break;
        }
        
        switch(verticalAlignment){
            case ToastShowAlignmentTop:
                newPoint.y = locationInWindow.y;
                break;
            case ToastShowAlignmentBottom:
                newPoint.y = locationInWindow.y + view.frame.size.height - _contentCover.frame.size.height;
                break;
            default:
                newPoint.y = locationInWindow.y + (view.frame.size.height - _contentCover.frame.size.height) / 2;
                break;
        }
        
        
        _contentCover.frame = (CGRect) {newPoint, _contentCover.frame.size};
        _contentCover.frame = CGRectIntegral(_contentCover.frame);
    }
    
    [[ToasterManager sharedManager] addToQueue:self];
}

- (void) dismiss{
    
}

- (CAAnimation *) toastStartAnimation{
    return _toastStartAnimation;
}

- (CAAnimation *) toastEndAnimation{
    return _toastEndAnimation;
}

- (UIView *) contentView{
    return _contentView;
}

- (UIView *) contentCover{
    return _contentCover;
}

@end
