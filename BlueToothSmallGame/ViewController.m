//
//  ViewController.m
//  BlueToothSmallGame
//
//  Created by cuiyan on 16/7/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "ViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <GameKit/GameKit.h>
#import "CyanPanelView.h"
#import "CyanPacket.h"
#import "Toaster.h"


#define kServiceType "cyan-game"
#define kPacket "packet"

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height

#define kPanelViewWidth kMainScreenWidth
#define kPanelViewHeight kPanelViewWidth



@interface ViewController ()<MCBrowserViewControllerDelegate,MCNearbyServiceBrowserDelegate,MCNearbyServiceAdvertiserDelegate,MCAdvertiserAssistantDelegate,MCSessionDelegate,CyanPanelViewDelegate>{
    
    NSInteger sendDieRollNumber;    //我发送的抽签数字
    NSInteger receiveDieRollNumber; //对手的
    BOOL didReceiveDieRollNumber;   //我收到了对方发送的抽签数字
    BOOL didRollNumberAcknewledged; //对方确认收到 我发送的抽签数字
}


@property (nonatomic,strong) UIView *coverView,*gameView;
@property (nonatomic,strong) CyanPanelView *panelView;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UILabel *pressDesLabel;

@property (nonatomic,strong) MCSession *mySession;
@property (nonatomic,strong) MCPeerID *myPeerID;
@property (nonatomic,strong) MCBrowserViewController *browserVC;
@property (nonatomic,strong) MCAdvertiserAssistant *advertiserAssistant;
@property (nonatomic,strong) MCNearbyServiceAdvertiser *advertiser;


@end

@implementation ViewController


- (void)testSiriExtension{
    
    NSLog(@"test siri");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *view1 = [[UIView alloc]initWithFrame:self.view.bounds];
    view1.backgroundColor = [UIColor whiteColor];
    view1.alpha = 1.;
    [self.view addSubview:view1];
    
    self.coverView = view1;
    
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake((kMainScreenWidth-128)/2, (kMainScreenHeight-128)/2, 128, 128);
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 1.;
    [btn addTarget:self action:@selector(linkgame:) forControlEvents:(UIControlEventTouchUpInside)];
    [btn setTitle:@"start" forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@"start.gif"] forState:(UIControlStateNormal)];

    [_coverView addSubview:btn];

    
    //press panel
    
    UIView *view2 = [[UIView alloc]initWithFrame:self.view.bounds];
    view2.backgroundColor = [UIColor whiteColor];
    view2.alpha = 1.;
    view2.hidden = YES;
    [self.view addSubview:view2];
    
    self.gameView  = view2;

    UILabel *label = [[UILabel alloc]initWithFrame:(CGRectMake(15, 40, kMainScreenWidth-15*2, 30))];
    label.backgroundColor =[UIColor whiteColor];
    [_gameView addSubview:label];
    
    self.statusLabel = label;   //当前游戏状态描述
    
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:(CGRectMake(15, 80, kMainScreenWidth-15*2, 30))];
    label1.backgroundColor =[UIColor whiteColor];
    [_gameView addSubview:label1];
    
    self.pressDesLabel = label1;   //当前用户描述
    
    CyanPanelView *thePanelView = [[CyanPanelView alloc]initWithFrame:(CGRectMake(0, (kMainScreenHeight-kPanelViewHeight)/2, kPanelViewWidth, kPanelViewHeight))];
    thePanelView.gameState = GameStatePrepare;
    thePanelView.center = self.view.center;
    thePanelView.delegate = self;
    thePanelView.backgroundColor = [UIColor whiteColor];
    [view2 addSubview:thePanelView];
    
    self.panelView = thePanelView;
}


- (void)setMyPeerID:(MCPeerID *)myPeerID{
    
    if (!_myPeerID) {
        
        _myPeerID = myPeerID;
    }
}

- (void)setMySession:(MCSession *)mySession{
    
    if (!_mySession) {
        
        _mySession = mySession;
    }
}

- (void)setBrowserVC:(MCBrowserViewController *)browserVC{
    
    if (!_browserVC) {
        
        _browserVC = browserVC;
    }
}

- (void)setAdvertiser:(MCNearbyServiceAdvertiser *)advertiser{
    
    if (!_advertiser) {
        
        _advertiser = advertiser;
    }
}

- (void)linkgame:(UIButton *)b{

    if (_mySession) {
        [_mySession disconnect];
    }
    
    
    NSString *deviceName = [UIDevice currentDevice].name;
    self.myPeerID = [[MCPeerID alloc]initWithDisplayName:deviceName];    //端
    
    self.mySession = [[MCSession alloc]initWithPeer:_myPeerID];            //socket
    _mySession.delegate = self;

    
//    MCNearbyServiceBrowser *nearbyBrowse = [[MCNearbyServiceBrowser alloc]initWithPeer:peerID serviceType:@kServiceType];
//    nearbyBrowse.delegate = self;
//    [nearbyBrowse startBrowsingForPeers];

    
    self.browserVC  = [[MCBrowserViewController alloc]initWithServiceType:@kServiceType session:_mySession];
    _browserVC.delegate = self;
    
    
    //发广播
//    self.advertiser = [[MCNearbyServiceAdvertiser alloc]initWithPeer:_myPeerID discoveryInfo:nil serviceType:@kServiceType];
//    _advertiser.delegate = self;
//    [_advertiser startAdvertisingPeer];
    
    //相对于MCNearbyServiceAdvertiser，是一个方便的类 处理邀请行为
    self.advertiserAssistant = [[MCAdvertiserAssistant alloc]initWithServiceType:@kServiceType discoveryInfo:nil session:_mySession];
    _advertiserAssistant.delegate =self;
    
 
    [self presentViewController:_browserVC animated:YES completion:^{

        [_advertiserAssistant start];
    }];
}

#pragma maek -- panel delegate
- (void)gamePaneView:(CyanPanelView *)view selectIndex:(NSInteger)index gameStatus:(GameState)state{
    
    CyanPacket *packet =[[CyanPacket alloc]init];
    packet.passIndex = index ;

    if (state == GameStateGoing) {
        
        packet.packetType = PacketTypeGoing;
        
        self.statusLabel.text = @"对方操作";
        _panelView.gameState = GameStateOpponentGoing;

    }else if (state == GameStateYouwin ){
        
        packet.packetType = PacketTypeOver;
        packet.winFlag = 1;
        
        self.statusLabel.text = @"你赢了";
        _panelView.gameState = GameStateYouwin;
        
    }else if (state == GameStateOpponentWin){
        packet.packetType = PacketTypeOver;
        packet.winFlag = -1;
        
        self.statusLabel.text = @"你输了";
        _panelView.gameState = GameStateOpponentWin;
    }
    
    [self sendPacket:packet];
    
    
    //用户手动操作-》结束游戏、重新开始游戏 do next
}



#pragma mark -- 以下关于游戏进程的操作，游戏信息配置、页面操作、连接情况

- (void)passDiaRollNumber:(NSInteger)rollNumber{
    
    CyanPacket *packet = [[CyanPacket alloc]init];
    packet.packetType = PacketTypeDieRoll;
    packet.dieRollNumber = rollNumber;
    
    [self sendPacket:packet];
    
    return;
}

- (void)sendPacket:(CyanPacket *)ack{
    
    NSMutableData *data = [[NSMutableData alloc]init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:ack forKey:@kPacket];
    [archiver finishEncoding];
    
    NSError *error = nil;
    [_mySession sendData:data toPeers:_mySession.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    
    if (error) {
        
        NSLog(@"%@",error.domain);
    }

}

- (void)prepareToNewGame{
    
    //allow user's handle
    _coverView.hidden = YES;
    _gameView.hidden = NO;
    
    [_panelView resumeView];
}

- (void)prepareGame{
    
    NSLog(@"prepareGame");
    
     void(^competion)(void) = ^{

         //开始游戏前 数据的初始化操作 /重置棋盘
         [self prepareToNewGame];
         
         //showHud，决定先后手
         //传值，数据包
         self.statusLabel.text = @"正在抽签，请勿操作";
         [self passDiaRollNumber:(sendDieRollNumber = arc4random() % 100+1)];
     };
    
    if (self.presentedViewController) {
        
        [self dismissViewControllerAnimated:YES completion:competion];
    }else{
        
        competion();
    }    
}

- (void)startGame{

    InfoLog(@"startGame ->%ld  %ld",(long)sendDieRollNumber,(long)receiveDieRollNumber);
    
    BOOL blackPress = sendDieRollNumber>receiveDieRollNumber;
    
    NSString *press =  blackPress?@"黑旗":@"白旗";
    self.pressDesLabel.text = [NSString stringWithFormat:@"%@ %@",[UIDevice currentDevice].name,press];
    
    self.statusLabel.text = blackPress?@"本方操作":@"对方操作";
    _panelView.gameState = blackPress?GameStateGoing:GameStateOpponentGoing;
    _panelView.flag = blackPress?ButtonFlagBlack:ButtonFlagWhite;
}

//- (void)pauseGame{
//    
//    NSLog(@"pause Game");
//    
//    //decline user's handle
//    _coverView.hidden = NO;
//    _gameView.hidden = YES;
//    
//    [_advertiserAssistant stop];
//}
//
//重新开始游戏
- (void)resumeGame{
    
    // do next
}

- (void)endGame{
    
    NSLog(@"endGame");
    
    self.statusLabel.text = nil;
    self.pressDesLabel.text = nil;
    
    _coverView.hidden = NO;
    _gameView.hidden = YES;
    [_panelView resumeView];
    
    [_advertiserAssistant stop];
    [_mySession disconnect];
}

#pragma mark -- session delegate

// Remote peer changed state.
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    
    NSLog(@"---> session delegate change state");
    
    switch (state) {
            
        case MCSessionStateNotConnected:{
            
            //分两种情况：后台和presentBrowseCtrl, 只考虑后台的case
            //如果正在presentCtrl,dismiss之
            if (!self.presentedViewController) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //alert to reconnect
                    //      or ok to donothing
                    
                    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"失去连接"] message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                    
                    UIAlertAction *action_reconnect = [UIAlertAction actionWithTitle:@"重新连接" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self presentViewController:_browserVC animated:YES completion:^{
                            //开启查询peer
                            [_advertiserAssistant start];
                        }];
                    }];
                    
                    UIAlertAction *action_ok = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        
                        
                    }];
                    
                    [alertCtrl addAction:action_reconnect];
                    [alertCtrl addAction:action_ok];
                    
                    [self presentViewController:alertCtrl animated:YES completion:nil];
                    
                    //断开连接后，暂停游戏
//                    [self pauseGame];
                    [self endGame];
                });
            }
        }
            
            break;
            
        case MCSessionStateConnecting:{
            
        }
            break;
        case MCSessionStateConnected:{
            
            //stop seek peer
            [_advertiserAssistant stop];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self prepareGame];
            });
        }
        default:
            break;
    }
}

// Received data from remote peer.
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    CyanPacket *packet = (CyanPacket *)[unarchiver decodeObjectForKey:@kPacket];
    
    switch (packet.packetType) {
        case PacketTypeDieRoll:{
            
            CyanPacket *confirmPacket = [[CyanPacket alloc]init];
            confirmPacket.packetType = PacketTypeConfirmDieRoll;
            confirmPacket.dieRollNumber = packet.dieRollNumber;
            [self sendPacket:confirmPacket];
            
            receiveDieRollNumber = packet.dieRollNumber;
            didReceiveDieRollNumber = YES;
            
        }
            break;
        case PacketTypeConfirmDieRoll:{
            
            if (packet.dieRollNumber != sendDieRollNumber) {
                
                //wrong data  cyan donext
                return;
            }
            
            didRollNumberAcknewledged = YES;
        }
            break;
            
        case PacketTypeGoing:{
         
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.statusLabel.text = @"本方操作";
                
                InfoLog(@"%ld",(long)packet.passIndex);
                
                [_panelView setOppenentIndex:packet.passIndex];
                _panelView.gameState = GameStateGoing;

            });
        }
            break;
            
        case PacketTypeOver:{

            dispatch_async(dispatch_get_main_queue(), ^{
                
                BOOL win = packet.winFlag;
                self.statusLabel.text = win?@"你赢了":@"你输了";
                
                [_panelView setOppenentIndex:packet.passIndex];
                _panelView.gameState = win?GameStateYouwin: GameStateOpponentWin;
                
                //结束游戏、重新开始游戏
                [[Toaster makeToastWithStyle:ToastStyleMiddleDark context:ToastContextNegative content:@"游戏结束"] show];
                [self performSelector:@selector(endGame) withObject:self afterDelay:1.];
            });
        }
            break;
        default:
            break;
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (didRollNumberAcknewledged && didReceiveDieRollNumber) {
            
            if (receiveDieRollNumber != sendDieRollNumber) {
                
                didReceiveDieRollNumber = didRollNumberAcknewledged = NO;
                
                self.statusLabel.text = @"开始游戏";
                [self startGame];
                
            }else{
                
                //抽签结果不一致,请重新开始连接 并开始游戏，
                //tip:这里若重新发送抽签，对方可能received confirmDieRollnumber。 处理方案待续
                [[Toaster makeToastWithStyle:ToastStyleMiddleDark context:ToastContextNegative content:@"抽签结果不一致,请重新开始连接"] show];
                
                [self performSelector:@selector(endGame) withObject:self afterDelay:1.];
            }
        }
    });
}

// Received a byte stream from remote peer.
- (void)    session:(MCSession *)session
   didReceiveStream:(NSInputStream *)stream
           withName:(NSString *)streamName
           fromPeer:(MCPeerID *)peerID{
    
}

// Start receiving a resource from remote peer.
- (void)                    session:(MCSession *)session
  didStartReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                       withProgress:(NSProgress *)progress{
    
}

// Finished receiving a resource from remote peer and saved the content
// in a temporary location - the app is responsible for moving the file
// to a permanent location within its sandbox.
- (void)                    session:(MCSession *)session
 didFinishReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                              atURL:(NSURL *)localURL
                          withError:(nullable NSError *)error{
    
}

#pragma mark -- assitant delegate
- (void)advertiserAssistantDidDismissInvitation:(MCAdvertiserAssistant *)advertiserAssistant{
    
    
}

- (void)advertiserAssistantWillPresentInvitation:(MCAdvertiserAssistant *)advertiserAssistant{
    
    
}


#pragma mark -- browse delegate

//点击了 cancle/done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [_advertiserAssistant stop];
    }];
}


- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [_advertiserAssistant stop];
    }];
}

- (BOOL)browserViewController:(MCBrowserViewController *)browserViewController shouldPresentNearbyPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info{
    
    return YES;
}



//////////////////////////


#pragma mark -- advertiser delegate
// Incoming invitation request.  Call the invitationHandler block with YES
// and a valid session to connect the inviting peer to the session.
- (void)            advertiser:(MCNearbyServiceAdvertiser *)advertiser
  didReceiveInvitationFromPeer:(MCPeerID *)peerID
                   withContext:(nullable NSData *)context
             invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler{
    
    
}


// Advertising did not start due to an error.
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error{
    
    
}

#pragma mark -- nearBy browse delegate
// Found a nearby advertising peer.
- (void)        browser:(MCNearbyServiceBrowser *)browser
              foundPeer:(MCPeerID *)peerID
      withDiscoveryInfo:(nullable NSDictionary<NSString *, NSString *> *)info{
    
    NSLog(@" %@  %@",peerID,info);
    
    //add to listData
}

// A nearby peer has stopped advertising.
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID{
    
    //remove to listData
    
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
