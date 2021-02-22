//
//  ViewController.m
//  LHQTodayWidgetDemo
//
//  Created by Xhorse_iOS3 on 2021/2/20.
//

#import "ViewController.h"
#import "LHQTestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"LHQTodayWidget";
    
    
}


- (void)todayAction:(NSNotification *)notify {
    LHQTestViewController *vc = [LHQTestViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
