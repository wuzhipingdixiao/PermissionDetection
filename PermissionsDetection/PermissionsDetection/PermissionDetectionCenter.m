//
//  PermissionDetectionCenter.m
//  PermissionsDetection
//
//  Created by zack on 2018/5/22.
//  Copyright © 2018年 zack. All rights reserved.
//

#import "PermissionDetectionCenter.h"
#import "LocationPermissionDetection.h"
#import "AddressBookPermissionDetection.h"
#import "PhotosPermissionDetection.h"
#import "CameraPermissionDetection.h"

@implementation PermissionDetectionCenter

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
                            setting:(void(^)(AuthorizationStatus))setting {
    PermissionsDetection *pdObj = nil;
    switch (type) {
            case PermissionNotification:
            break;
            case PermissionLocation:
            pdObj = [[LocationPermissionDetection alloc] init];
            break;
            case PermissionAddressBook:
            pdObj = [[AddressBookPermissionDetection alloc] init];
            break;
            case PermissionPhotos:
            pdObj = [[PhotosPermissionDetection alloc] init];
            break;
            case PermissionCamera:
            pdObj = [[CameraPermissionDetection alloc] init];
            break;
        default:
            break;
    }
    
    [pdObj checkPermissionsWithMessageDic:nil showAlertWhenUnAvailable:YES through:^(AuthorizationStatus status) {
        if (through) { through(status); }
    } cancel:^(AuthorizationStatus status) {
        if (cancel) { cancel(status); }
    } setting:^(AuthorizationStatus status) {
        if (setting) { setting(status); }
    }];
}

@end
