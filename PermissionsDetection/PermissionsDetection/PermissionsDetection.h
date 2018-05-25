//
//  PermissionsDetection.h
//  BluePay Plus
//
//  Created by zack on 2018/5/22.
//  Copyright © 2018年 Blue Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PermissionAlertView.h"

typedef NS_ENUM(NSUInteger, AuthorizationStatus) {
    
    AuthorizationStatus_NotDetermined   = 0,    // 用户从未进行过授权等处理，首次访问相应内容会提示用户进行授权
    AuthorizationStatus_Restricted      = 1,    // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
    
    AuthorizationStatus_Denied          = 2,    // 拒绝
    AuthorizationStatus_Authorized      = 3,    // 已授权
    AuthorizationStatus_UnSupport      = 4,    // 硬件等不支持或服务未开启
    AuthorizationStatus_NotInfoDesc     = 5,    // 文件描述
    AuthorizationLocaStatus_AlwaysUsage = 11,   // 一直允许获取定位
    AuthorizationLocaStatus_WhenInUseUsage = 12,// 一直允许获取定位
};

/**
 权限检测
 */
@interface PermissionsDetection : NSObject

- (NSString *)appName;

- (void)checkPermissionsWithMessageDic:(NSDictionary *)messageDic
              showAlertWhenUnAvailable:(BOOL)bShow
                               through:(void(^)(AuthorizationStatus))through
                                cancel:(void(^)(AuthorizationStatus))cancel
                               setting:(void(^)(AuthorizationStatus))setting;

@end
