//
//  CyanPanelView.h
//  BlueToothSmallGame
//
//  Created by cuiyan on 16/7/22.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CyanButton.h"

@class CyanPanelView;

typedef  enum{
    
    GameStatePrepare,//游戏准备开始
    GameStateGoing, //正在进行游戏，本方操作
    GameStateOpponentGoing, //正在进行游戏，对手操作
    
    GameStatePause,  //游戏终止
    GameStateYouwin, //游戏结束，先手赢 与flag 强烈相关
    GameStateOpponentWin,  //游戏结束 后手赢 ，
    
}GameState;



@protocol CyanPanelViewDelegate <NSObject>

- (void)gamePaneView:(CyanPanelView *)view selectIndex:(NSInteger)index gameStatus:(GameState)state; //代理处理当前的游戏process
//- (void)gameOverPaneView:(CyanPanelView *)view;

@end

@interface CyanPanelView : UIView

@property (nonatomic,weak) id<CyanPanelViewDelegate> delegate;
@property (nonatomic,assign) GameState gameState;
@property (nonatomic,assign) ButtonFlag flag,oppentFlag;

- (void)setOppenentIndex:(NSInteger)idnex;

- (void)resumeView;

@end
