//
//  PermissionDetectionCenter.h
//  PermissionsDetection
//
//  Created by zack on 2018/5/22.
//  Copyright © 2018年 zack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PermissionsDetection.h"

typedef NS_ENUM(NSInteger, PermissionsType) {
    PermissionNotification = 0, // 通知
    PermissionLocation,         // 地理位置
    PermissionAddressBook,      // 通讯录
    PermissionPhotos,           // 相册
    PermissionCamera,           // 照相机
};

@interface PermissionDetectionCenter : NSObject

/**
 权限检测

 @param type 权限类型
 @param through 具备对应类型的权限
 @param cancel 不具备对应的权限并取消设置
 @param setting 不具备对应的权限并前往设置去设置相关权限
 */
+ (void)permissionDetectionWithType:(PermissionsType)type
                            through:(void(^)(AuthorizationStatus))through
                             cancel:(void(^)(AuthorizationStatus))cancel
                            setting:(void(^)(AuthorizationStatus))setting;

@end
