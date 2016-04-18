//
//  ViewController.m
//  AlertView
//
//  Created by Rookie on 16/4/18.
//  Copyright © 2016年 Rookie. All rights reserved.
//

#import "ViewController.h"
#import "RKAlertView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
}
- (IBAction)button:(id)sender {
    
    RKAlertView *va = [RKAlertView alertViewWithTitle:@"提示信息" message:@"我是一个AlertView" CanclebuttonTitle:@"取消" OKbuttonTitle:@"确定" buttonTouchedAction:^{
        NSLog(@"取消");
    } buttonCheckTouchedAction:^{
        NSLog(@"确定");
    } dismissAction:^{
        NSLog(@"消失");
    }];
    [va show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
