//
//  CameraPermissionDetection.m
//  PermissionsDetection
//
//  Created by zack on 2018/5/22.
//  Copyright © 2018年 zack. All rights reserved.
//

#import "CameraPermissionDetection.h"
#import <AVFoundation/AVFoundation.h>

@implementation CameraPermissionDetection

/**
 相机权限检测
 */
- (void)checkPermissionsWithMessageDic:(NSDictionary *)messageDic showAlertWhenUnAvailable:(BOOL)bShow through:(void (^)(AuthorizationStatus))through cancel:(void (^)(AuthorizationStatus))cancel setting:(void (^)(AuthorizationStatus))setting {
    
    NSString *title;
    NSString *message;
    NSString *settingUrl;
    AuthorizationStatus status = [self permissionStatus];

    if (status == AuthorizationStatus_UnSupport) {
//        NSString *deviceName = isRear ? @"后置摄像头" : @"前置摄像头";
        NSString *deviceName = @"后置摄像头";
        title = [deviceName stringByAppendingString:@"不可用"];
        message = [deviceName stringByAppendingString:@"不支持，请更换设备后再试"];
        settingUrl = nil;
    } else if (status == AuthorizationStatus_Denied || status == AuthorizationStatus_Restricted) {
        title = @"访问相机受限";
        message = [NSString stringWithFormat:@"相机访问受限，请进入系统【设置】>【隐私】>【相机】中允许%@访问相机", [self appName]];
        settingUrl = @"root=Camera";
    } else if (status == AuthorizationStatus_NotInfoDesc) {
        title = @"访问受限";
        message = @"请在配置文件中设置描述";
        settingUrl = nil;
    } else if (status == AuthorizationStatus_Authorized) {
        if (through) {
            through(status);
        }
        return;
    } else {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//            if (granted) {
//                if (resultBlock) {
//                    resultBlock(YES, (ZLLAuthorizationStatus)status);
//                }
//            }else{
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
    BOOL isRear = YES; //默认后置摄像头
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *desc = [info objectForKey:@"NSCameraUsageDescription"];
    if (desc == nil) {
        return AuthorizationStatus_NotInfoDesc;
    }
    
    if (![UIImagePickerController isCameraDeviceAvailable:isRear ? UIImagePickerControllerCameraDeviceRear : UIImagePickerControllerCameraDeviceFront]) {
        return AuthorizationStatus_UnSupport;
    }
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return (AuthorizationStatus)status;
}

@end
