//
//  LocationPermissionDetection.m
//  BluePay Plus
//
//  Created by zack on 2018/5/22.
//  Copyright © 2018年 Blue Mobile. All rights reserved.
//

#import "LocationPermissionDetection.h"
#import <CoreLocation/CoreLocation.h>

@implementation LocationPermissionDetection

/**
 地理位置权限检测
 */
- (void)checkPermissionsWithMessageDic:(NSDictionary *)messageDic
              showAlertWhenUnAvailable:(BOOL)bShow
                               through:(void(^)(AuthorizationStatus))through
                                cancel:(void(^)(AuthorizationStatus))cancel
                               setting:(void(^)(AuthorizationStatus))setting {
    NSString *title;
    NSString *message;
    NSString *settingUrl;
    AuthorizationStatus status = [self permissionStatus];
    
    if (status == AuthorizationStatus_UnSupport) {
        title = @"打开定位开关";
        message = [NSString stringWithFormat:@"定位服务未开启，请进入系统【设置】>【隐私】>【定位服务】中打开开关，并允许%@使用定位服务", [self appName]];
        settingUrl = @"root=LOCATION_SERVICES";
    } else if (status == AuthorizationStatus_Denied || status == AuthorizationStatus_Restricted) {
        title = @"开启定位服务";
        message = [NSString stringWithFormat:@"定位服务受限，请进入系统【设置】>【隐私】>【定位服务】中允许%@使用定位服务", [self appName]];
        settingUrl = @"root=LOCATION_SERVICES";
    } else if (status == AuthorizationStatus_NotInfoDesc) {
        title = @"访问受限";
        message = @"请在配置文件中设置描述";
        settingUrl = nil;
    } else {
        if (through) {
            through(status); //通过权限检测
        }
        return;
    }
    
    if (bShow) {
        [PermissionAlertView showAlertWithTitle:title message:message currentVC:nil jumpSetting:YES settingURLString:settingUrl cancel:^{
            if (cancel) {
                cancel(status);
            }
        } setting:^{
            if (setting) {
                setting(status);
            }
        }];
    }
}

- (AuthorizationStatus)permissionStatus {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *alwaysUsage = [info objectForKey:@"NSLocationAlwaysUsageDescription"];
    NSString *whenInUseUsage = [info objectForKey:@"NSLocationWhenInUseUsageDescription"];
    if (!alwaysUsage && !whenInUseUsage) {
        return AuthorizationStatus_NotInfoDesc;
    }
    
    if (![CLLocationManager locationServicesEnabled]) {
        return AuthorizationStatus_UnSupport;
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
            case kCLAuthorizationStatusNotDetermined:
            return AuthorizationStatus_NotDetermined;
            case kCLAuthorizationStatusRestricted:
            return AuthorizationStatus_Restricted;
            case kCLAuthorizationStatusDenied:
            return AuthorizationStatus_Denied;
            case kCLAuthorizationStatusAuthorizedAlways:
            return AuthorizationLocaStatus_AlwaysUsage;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            return AuthorizationLocaStatus_WhenInUseUsage;
    }
}

@end
