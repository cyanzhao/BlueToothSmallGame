//
//  TodayViewController.h
//  CyanTodayExtension2
//
//  Created by cuiyan on 16/7/29.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *invokeButton;
- (IBAction)btnClicked:(id)sender;

@end
