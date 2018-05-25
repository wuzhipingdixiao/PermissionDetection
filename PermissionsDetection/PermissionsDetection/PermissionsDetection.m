//
//  PermissionsDetection.m
//  BluePay Plus
//
//  Created by zack on 2018/5/22.
//  Copyright © 2018年 Blue Mobile. All rights reserved.
//

#import "PermissionsDetection.h"

@implementation PermissionsDetection

- (NSString *)appName {
    NSString *dispalyName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    if (!dispalyName) {
        dispalyName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    }
    
    return dispalyName;
}

- (void)checkPermissionsWithMessageDic:(NSDictionary *)messageDic showAlertWhenUnAvailable:(BOOL)bShow through:(void (^)(AuthorizationStatus))through cancel:(void (^)(AuthorizationStatus))cancel setting:(void (^)(AuthorizationStatus))setting {
}

@end
