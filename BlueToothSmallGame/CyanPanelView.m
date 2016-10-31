
//
//  CyanPanelView.m
//  BlueToothSmallGame
//
//  Created by cuiyan on 16/7/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "CyanPanelView.h"


typedef enum{
    
    DiretionTypeHor,
    DiretionTypeVor,
    DiretionTypeLeftUp,
    DiretionTypeRightDown
    
}DiretionType;

#define lineWidth 2
#define panelLenth 3

@implementation CyanPanelView


- (instancetype)initWithFrame:(CGRect)frame{
    
    self= [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.borderColor = [UIColor greenColor].CGColor;
        self.layer.borderWidth = 1.;
        self.backgroundColor = [UIColor colorWithRed:160/2255. green:160/2255. blue:160/2255. alpha:1.];
                
        //base self.frame refresh or init subUI
        [self reCreatUI];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame{
    
    [self reCreatUI];
}

- (void)reCreatUI{
    
    //remove subView
    
    for (UIView *subView in self.subviews) {
        
        [subView performSelector:@selector(removeFromSuperview)];
    }
    
    //add  3*3's button
    
    CGRect rect = self.frame;
    
    CGFloat gap_width = (CGRectGetWidth(rect)-lineWidth*4)/3.;
    CGFloat gap_height = (CGRectGetHeight(rect)-lineWidth*4)/3.;
    
    if (gap_width <0. || gap_height <0.) {
        return;
    }

    
    for (NSInteger i = 0 ; i<9; i++) {
        
        CyanButton *btn = [CyanButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(lineWidth+(lineWidth+gap_width)*(i%3), lineWidth+(lineWidth+gap_height)*(i/3), gap_width, gap_height);
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.layer.cornerRadius = gap_width/2.;
//        [btn setBackgroundImage:nil forState:(UIControlStateNormal)];
//        [btn setBackgroundImage:_selectImage forState:(UIControlStateSelected)];
        btn.flag = ButtonFlagNone;
        btn.tag = i+panelLenth;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
    }
}

- (void)setFlag:(ButtonFlag)flag{
    
    _flag = flag;
    _oppentFlag = (flag==1?2:1);
}

- (void)btnClicked:(CyanButton *)b{
    
    if (b.flag == ButtonFlagNone) {
      
        b.flag = self.flag;
        
        //判断胜利条件
        BOOL gameOver  = [self judgeResultIndex:b.tag state:b.flag];
        
        if (gameOver) {
            [_delegate gamePaneView:self selectIndex:b.tag gameStatus:(GameStateYouwin)];
        }else{
             [_delegate gamePaneView:self selectIndex:b.tag gameStatus:(GameStateGoing)];
        }
        
    }
}

- (BOOL)judgeResultIndex:(NSInteger)index state:(ButtonFlag)flag{
    
    //2+2个方向
    
    //    i-1  i-2    ..... i+1  i+2
    //    i-1*n i-2*n .... i+1*n i+2*n
    //
    //    i-1*n-1 ..... i+1*n+1
    //    i-1*n+1 ..... i+1*n-1
    //     x(+1、-1)   y(1、n)     a(+1、0、-1)   b（+1、0、-1）  //3个变量 期望 有direction数组直接控制，不手动更改
    
    
    NSInteger sum = 1;
    NSInteger directionSum = 4;
    NSInteger winPathNum = 3;
    
    NSArray *multiplys = @[@1,[NSNumber numberWithInteger:panelLenth],[NSNumber numberWithInteger:panelLenth],[NSNumber numberWithInteger:panelLenth]];
    NSArray *pluss = @[@0,@0,@-1,@1];
    NSArray *hor_vors = @[@0,@0,@1,@1];
    
    
    for (NSInteger dircetion = 0; dircetion < directionSum ; dircetion++) {
        
        NSInteger currentIndex = index;
        NSInteger shakeFlag = -1;       //震荡表示  ，比如-1 像左、上侧移动， 1 向右下方移动
        NSInteger shakeCircle = 2;      //允许的震荡周期数量
        NSInteger currentShakeCircle = 0;   //当前震荡的周期
        
        NSInteger pathNum = 1;  //表针走过的数量
        
        sum = 1;    //方向更改时，重置sum
        
        while (currentShakeCircle < shakeCircle) {
            
            NSInteger multiply = ((NSNumber *)multiplys[dircetion]).intValue;
            NSInteger hor_vor = ((NSNumber *)hor_vors[dircetion]).intValue;
            NSInteger plus = ((NSNumber *)pluss[dircetion]).intValue;
            
            currentIndex = currentIndex+(shakeFlag)*multiply+ 1 * shakeFlag * hor_vor * plus;
            
            NSLog(@"-currentIndex-->%ld",currentIndex);
            
            //走2个值 震荡值翻转
            NSInteger lastShakeFlag = shakeFlag;
            
            //超过边界 翻转
            
            if (currentIndex < panelLenth || currentIndex >=panelLenth*panelLenth+panelLenth) {
                
                shakeFlag *= -1;
                
            }else if (dircetion == DiretionTypeHor){
                
                
                shakeFlag *= ((currentIndex/panelLenth == index/panelLenth)?1:-1);
                
                
            }else if (dircetion== DiretionTypeLeftUp || dircetion == DiretionTypeRightDown){
                
                if (currentIndex/panelLenth != (index/panelLenth + pathNum*shakeFlag)) {
                    shakeFlag *= -1;
                }
            }
            
            // 状态不一致 翻转
            
            if (shakeFlag == lastShakeFlag) {
                
                //判断btn.tag == currentIndex .selectState
                CyanButton *btn = [self viewWithTag:currentIndex];
                
                if (btn.flag == flag) {
                    
                    sum ++;
                    
                    if (sum >= winPathNum) {
                        
                        NSLog(@"win");
                        
                        dircetion = 999;    //结束外层循环
                        
                        return YES;
                    }
                    
                    
                }else{
                    shakeFlag *= -1;
                    
//                    NSLog(@"----%ld--------  翻转 --------------",(long)dircetion);
                    
                }
            }else{
                
//                NSLog(@"----%ld--------  翻转 --------------",(long)dircetion);
            }
            

            //翻转后做的初始化操作

            pathNum = (lastShakeFlag == shakeFlag)?pathNum+1:1;
            
            currentShakeCircle += ((shakeFlag == lastShakeFlag) ?0:1);
            currentIndex = (shakeFlag == lastShakeFlag)?currentIndex:index;
        }
        
        NSLog(@" ----------------------------------------------------------------- ");
    }
    
    return NO;
}


- (void)setOppenentIndex:(NSInteger)idnex{
    
    CyanButton *b = (CyanButton *)[self viewWithTag:idnex];
    
    if (b && b.flag == ButtonFlagNone) {
        
        b.flag = self.oppentFlag;
    }
}

- (void)setGameState:(GameState)gameState{
    
    switch (gameState) {
        case GameStatePrepare:{
            
            self.userInteractionEnabled = NO;
        }
            
            break;
        case GameStateGoing:{
            
            self.userInteractionEnabled = YES;

        }
            break;
        case GameStateOpponentGoing:{
            
            self.userInteractionEnabled = NO;
            
            
        }
            break;
        case GameStatePause:{
            self.userInteractionEnabled = NO;
            
        }
            break;

        case GameStateYouwin:{
            self.userInteractionEnabled = NO;

        }
            break;
        case GameStateOpponentWin:{
            self.userInteractionEnabled = NO;

        }
            break;
           
        default:
            break;
    }
}

//重置界面
- (void)resumeView{

    for (NSInteger i = 0+panelLenth; i<9+panelLenth; i++) {
        
        CyanButton *btn = (CyanButton *)[self viewWithTag:i];
        btn.flag = ButtonFlagNone;
    }
}

- (void)drawRect:(CGRect)rect{
    
    //绘制 “井”

    CGFloat gap_width = (CGRectGetWidth(rect)-lineWidth*4)/3.;
    CGFloat gap_height = (CGRectGetHeight(rect)-lineWidth*4)/3.;
    
    if (gap_width <0. || gap_height <0.) {
        return;
    }
    
    NSInteger horTag = 0;
    NSInteger vorTag = 0;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    
    for (NSInteger i =0; i< 4; i++) {
        
        if (i/2==0) {
            vorTag = 0;
            horTag ++;
        }else{
            horTag = 0;
            vorTag ++;
        }
        
        CGContextSaveGState(ctx);
        
        CGContextMoveToPoint(ctx, (gap_width+lineWidth)*(vorTag?vorTag:0), (gap_height+lineWidth)*(horTag?horTag:0));
        CGContextAddLineToPoint(ctx,CGRectGetWidth(rect)*(horTag?1:0)+(gap_width+lineWidth)*(vorTag?vorTag:0), CGRectGetHeight(rect)*(vorTag?1:0)+(gap_height+lineWidth)*(horTag?horTag:0));
        
        CGContextRestoreGState(ctx);
    }
    CGContextStrokePath(ctx);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
