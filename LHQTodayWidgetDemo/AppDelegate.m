//
//  AppDelegate.m
//  LHQTodayWidgetDemo
//
//  Created by Xhorse_iOS3 on 2021/2/20.
//

#import "AppDelegate.h"
#import "LHQTestViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ([url.scheme isEqualToString:@"LHQWidget"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"LHQTodayWidgetNotify" object:nil];
        [self gotoTestVc];
    }
    return NO;
}

//- (void)showAlert {
//    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"AppDelegate" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *sureAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [vc addAction:sureAc];
//    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
//}

- (void)gotoTestVc {
    [(UINavigationController *)self.window.rootViewController pushViewController:[LHQTestViewController new] animated:YES];
}



@end
