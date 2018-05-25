//
//  AddressBookPermissionDetection.m
//  PermissionsDetection
//
//  Created by zack on 2018/5/22.
//  Copyright © 2018年 zack. All rights reserved.
//

#import "AddressBookPermissionDetection.h"
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>

@implementation AddressBookPermissionDetection

/**
 通讯录权限检测
 */
- (void)checkPermissionsWithMessageDic:(NSDictionary *)messageDic
              showAlertWhenUnAvailable:(BOOL)bShow
                               through:(void (^)(AuthorizationStatus))through
                                cancel:(void (^)(AuthorizationStatus))cancel
                               setting:(void (^)(AuthorizationStatus))setting {
    NSString *title = @"";
    NSString *message = @"";
    NSString *settingUrl = nil;
    AuthorizationStatus status = [self permissionStatus];
    
    if (status == AuthorizationStatus_Denied || status == AuthorizationStatus_Restricted) {
        if (bShow) {
            title = @"访问通讯录受限";
            message = [NSString stringWithFormat:@"通讯录访问受限，请进入系统【设置】>【隐私】>【通讯录】中允许%@访问你的通讯录", [self appName]];
            settingUrl = @"root=Contacts";
        }
    }else if (status == AuthorizationStatus_NotInfoDesc){
        title = @"访问受限";
        message = @"请在配置文件中设置描述";
        settingUrl = nil;
    } else if (status == AuthorizationStatus_Authorized){
        if (through) {
            through(status);
        }
        return;
    } else {
        //内容待定
        ABAddressBookRef bookRef = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(bookRef, ^(bool granted, CFErrorRef error) {
//            if (granted) {
//                if (resultBlock) {
//                    resultBlock(YES, (AuthorizationStatus)status);
//                }
//            }else{
//                if (resultBlock) {
//                    resultBlock(NO, (AuthorizationStatus)status);
//                }
//            }
        });
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
    NSString *desc = [info objectForKey:@"NSContactsUsageDescription"];
    if (!desc) {
        return AuthorizationStatus_NotInfoDesc;
    }
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        return (AuthorizationStatus)status;
    } else {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        return (AuthorizationStatus)status;
    }
}

@end
