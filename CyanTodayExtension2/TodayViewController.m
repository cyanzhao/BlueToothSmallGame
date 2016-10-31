//
//  TodayViewController.m
//  CyanTodayExtension2
//
//  Created by cuiyan on 16/7/29.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>


@interface TodayViewController () <NCWidgetProviding,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *datas;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.preferredContentSize = CGSizeMake(0, 1000);
//    self.extensionContext

    //更改为从主程序获取值
    //_datas = [NSMutableArray arrayWithObjects:@"今日",@"前日",nil];
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.nearConnectExtension"];
    _datas = (NSMutableArray *)[defaults objectForKey:@"datas"];
    
    [defaults setObject:@"test string" forKey:@"str"];
    [defaults synchronize];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.hidden = YES;
    
    [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

#pragma mark -- action

- (void)skipBetweenApp{
    
    [self.extensionContext openURL:[NSURL URLWithString:@"BlueToothSmallGameBaseInfo://host?uuid=1541354436"] completionHandler:^(BOOL success) {
        
    }];
}

- (void)invokeProgram{
    
    NSLog(@"invokeProgram");
    
    [self skipBetweenApp];
}

- (IBAction)btnClicked:(id)sender{
    
    NSLog(@"btnclicked");
    
    [self skipBetweenApp];
}

#pragma mark -- app delegate datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == _datas.count) {
        return 40;
    }
    
    return 30.;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
//        return _datas.count+1;
        return _datas.count;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self skipBetweenApp];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cyan"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cyan"];
    }
    
    if (indexPath.row == _datas.count) {
        
        //add invoke program button
        
//        [cell.subviews performSelector:@selector(removeFromSuperview) withObject:self];
        
        CGFloat cellHeight = CGRectGetHeight(cell.contentView.bounds);
        CGFloat cellWidth = CGRectGetWidth(cell.contentView.bounds);
        
        UIButton *invokeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        invokeBtn.frame = CGRectMake((cellWidth-100)/2, (cellHeight-40)/2 , 100, 40);
        [invokeBtn addTarget:self action:@selector(invokeProgram) forControlEvents:(UIControlEventTouchUpInside)];
        [invokeBtn setTitle:@"invoke" forState:(UIControlStateNormal)];
        invokeBtn.layer.borderColor = [UIColor greenColor].CGColor;
        invokeBtn.layer.borderWidth = 1.;
        [cell.contentView addSubview:invokeBtn];
        
        cell.userInteractionEnabled = YES;
        cell.contentView.userInteractionEnabled = YES;
        
        
    }else{
        cell.textLabel.text = _datas[indexPath.row];
    }
    
    
    return cell;
    
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    //    [_tableView reloadData];
    
    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
