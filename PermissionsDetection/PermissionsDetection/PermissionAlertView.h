//
//  PermissionAlertView.h
//  PermissionsDetection
//
//  Created by zack on 2018/5/22.
//  Copyright © 2018年 zack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PermissionAlertView : UIView

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                 currentVC:(UIViewController *)currentVC
               jumpSetting:(BOOL)bJumpSetting
          settingURLString:(NSString *)settingURLString
                    cancel:(void (^)(void))cancel
                   setting:(void (^)(void))setting;
@end
