//
//  PermissionAlertView.m
//  PermissionsDetection
//
//  Created by zack on 2018/5/22.
//  Copyright © 2018年 zack. All rights reserved.
//

#import "PermissionAlertView.h"

@implementation PermissionAlertView

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                 currentVC:(UIViewController *)currentVC
               jumpSetting:(BOOL)bJumpSetting
          settingURLString:(NSString *)settingURLString
                    cancel:(void (^)(void))cancel
                   setting:(void (^)(void))setting {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
    if (!currentVC) {
        currentVC = [[[UIApplication sharedApplication].delegate window] rootViewController];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             if (cancel) {
                                                                 cancel();
                                                             }
    }];
    [alertVC addAction:cancelAction];
    
    if (bJumpSetting && settingURLString && [self whetherCanJumpToSetting]) {
        UIAlertAction *jump = [UIAlertAction actionWithTitle:@"去开启"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self openURLString:settingURLString];
                                                         if (setting) {
                                                             setting();
                                                         }
                                                     }];
        [alertVC addAction:jump];
    }
    [currentVC presentViewController:alertVC animated:YES completion:nil];
}

+ (void)openURLString:(NSString *)string {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"App-Prefs:" stringByAppendingString:string]] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"prefs:" stringByAppendingString:string]]];
    }
}

+ (BOOL)whetherCanJumpToSetting {
    static BOOL canJump = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        NSArray *URLTypes = [info objectForKey:@"CFBundleURLTypes"];
        for (NSDictionary *childURLs in URLTypes) {
            NSArray *URLScheme = [childURLs objectForKey:@"CFBundleURLSchemes"];
            if ([URLScheme isKindOfClass:[NSArray class]]  && URLScheme.count) {
                for (NSString *string in URLScheme) {
                    if ([string isKindOfClass:[NSString class]] && [string isEqualToString:@"prefs"]) {
                        canJump = YES;
                        break;
                    }
                }
            }
        }
    });
    
    return canJump;
}

@end
