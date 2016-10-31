//
//  IntentViewController.m
//  CyanSiriExtensionUI
//
//  Created by cuiyan on 16/8/1.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "IntentViewController.h"
#import "CyanSiriViewController.h"
#import <Intents/Intents.h>

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

@interface IntentViewController ()

@end

@implementation IntentViewController


/**
 
 ** 1、可以定制siri 期待接受的消息吗？
    2、可以定制siri搜索后的展示界面吗？
 
    3、mainAPp如何监听extension action
        1、mianAPP响应，    how? 执行mainApp delegate的方法，
        2、跳转mainApp响应（通过schemeUrl、传值）,  how 检测到跳转行为（tap手势、send action）
        3、excute in extension directly

 
 
 note: 通过官方demo
 
    issue 1 放弃
    确认可以定制siri搜索后展示的页面（issue 2）
    issue 3,待研究

*/
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - INUIHostedViewControlling

// Prepare your view controller for the interaction to handle.
- (void)configureWithInteraction:(INInteraction *)interaction context:(INUIHostedViewContext)context completion:(void (^)(CGSize))completion {
    // Do configuration here, including preparing views and calculating a desired size for presentation.
    
    CGSize size = [self desiredSize];
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSLog(@"%f  %f",width,height);
    
    
    CyanSiriViewController *siriViewC = [[CyanSiriViewController alloc]init];
    siriViewC.view.frame = CGRectMake(0, 0, size.width,size.height);
    
    INSendMessageIntent *sendMessageIntet = (INSendMessageIntent *)interaction.intent;
    
    {
        NSArray *persions = sendMessageIntet.recipients;
        
        NSString *contacts = @"";
        for (INPerson *person in persions) {
            
            if (person.displayName) {
                contacts = [contacts stringByAppendingFormat:@"%@ ",person.displayName];
            }
        }
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, 25)];
        label.text = [NSString stringWithFormat:@"发送给：%@",contacts];
//        label.layer.borderColor = [UIColor greenColor].CGColor;
//        label.layer.borderWidth = 1.;
        [siriViewC.view addSubview:label];
    }
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, size.width-20-10*2, size.height-25)];
        label.text = [NSString stringWithFormat:@"%@",sendMessageIntet.content];
//        label.textAlignment = NSTextAlignmentRight;
//        label.layer.borderColor = [UIColor greenColor].CGColor;
//        label.layer.borderWidth = 1.;
        [siriViewC.view addSubview:label];
    }
    
    [self presentViewController:siriViewC animated:NO completion:nil];
    
    
    if (completion) {
        completion([self desiredSize]);
    }
}

- (CGSize)desiredSize {
    
    return [self extensionContext].hostedViewMaximumAllowedSize;
}


#pragma mark -- siriProviding
- (BOOL)displaysMessage{
    
    return YES;
}



@end
