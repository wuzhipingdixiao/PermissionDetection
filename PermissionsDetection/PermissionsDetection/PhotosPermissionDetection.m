//
//  PhotosPermissionDetection.m
//  PermissionsDetection
//
//  Created by zack on 2018/5/22.
//  Copyright © 2018年 zack. All rights reserved.
//

#import "PhotosPermissionDetection.h"
#import <Photos/Photos.h>

@implementation PhotosPermissionDetection

/**
 相册权限权限检测
 */
- (void)checkPermissionsWithMessageDic:(NSDictionary *)messageDic showAlertWhenUnAvailable:(BOOL)bShow through:(void (^)(AuthorizationStatus))through cancel:(void (^)(AuthorizationStatus))cancel setting:(void (^)(AuthorizationStatus))setting {
    
    NSString *title;
    NSString *message;
    NSString *settingUrl;
    AuthorizationStatus status = [self permissionStatus];
    
    if (status == AuthorizationStatus_UnSupport) {
        title = @"照片不可用";
        message = @"设备不支持照片，请更换设备后再试";
        settingUrl = nil;
    } else if (status == AuthorizationStatus_Denied || status == AuthorizationStatus_Restricted) {
        title = @"访问照片受限";
        message = [NSString stringWithFormat:@"照片访问受限，请进入系统【设置】>【隐私】>【照片】中允许%@访问照片", [self appName]];
        settingUrl = @"root=Photos";
    } else if (status == AuthorizationStatus_NotInfoDesc){
        title = @"访问受限";
        message = @"请在配置文件中设置描述";
        settingUrl = nil;
    } else if (status == AuthorizationStatus_Authorized){
        if (through) {
            through(status);
        }
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//            if (status == PHAuthorizationStatusAuthorized) {
//                if (resultBlock) {
//                    resultBlock(YES, (ZLLAuthorizationStatus)status);
//                }
//            } else {
//                if (resultBlock) {
//                    resultBlock(NO, (ZLLAuthorizationStatus)status);
//                }
//            }
        }];
        
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
    NSString *desc = [info objectForKey:@"NSPhotoLibraryUsageDescription"];
    if (!desc) {
        return AuthorizationStatus_NotInfoDesc;
    }
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return AuthorizationStatus_UnSupport;
    }
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    return (AuthorizationStatus)status;
}

@end
