//
//  UIAlertView+Extension.m
//  EasyBills
//
//  Created by luojie on 4/22/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "UIAlertView+Extension.h"

NSString *const kCLAuthorizationStatusDeniedTitle = @"您需要打开定位服务";
NSString *const kCLAuthorizationStatusDeniedMessage = @"您可以前往 《 设置 -> 隐私 -> 定位服务 》 打开它！";

NSString *const kCLAuthorizationStatusRestrictedTitle = @"您需要解除定位限制";
NSString *const kCLAuthorizationStatusRestrictedMessage = @"您可以前往 《 设置 -> 通用 -> 访问限制 -> 定位服务 》 解除限制！";

NSString *const kPromptTitle = @"提示";
NSString *const kMailNotConfiguredMessage = @"邮箱尚未配置。";



@implementation UIAlertView (Extension)

+ (void)displayAlertWithTitle:(NSString *)title
                      message:(NSString *)message{
    
    UIAlertView *alertView =
    [[UIAlertView alloc]
     initWithTitle:title
     message:message
     delegate:nil
     cancelButtonTitle:@"好"
     otherButtonTitles: nil];
    
    [alertView show];
    
}
@end
