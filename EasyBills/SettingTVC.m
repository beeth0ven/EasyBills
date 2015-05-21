//
//  SettingTableViewController.m
//  EasyBills
//
//  Created by 罗 杰 on 10/7/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "SettingTVC.h"
#import "LTHPasscodeViewController.h"
#import "PubicVariable.h"
#import "PNChart.h"
#import "Bill+Create.h"
#import "Kind+Create.h"
#import "SWRevealViewController.h"
#import "DefaultStyleController.h"
#import "UIButton+Extension.h"
#import "UIViewController+Extension.h"
#import "UINavigationController+Style.h"
#import "UIAlertView+Extension.h"

@interface SettingTVC ()

@property (weak, nonatomic) IBOutlet UISwitch *passcodeSwitch;

@end

@implementation SettingTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMenuButton];
}


-(void)viewWillAppear:(BOOL)animated
{
    //self.navigationController.navigationBar.barTintColor = PNTwitterColor;
    [self.navigationController applyDefualtStyle:YES];
    self.passcodeSwitch.on = [LTHPasscodeViewController doesPasscodeExist];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enableRevealPanGesture];
}

- (IBAction)changePasscodeState:(UISwitch *)sender {
    if (sender.isOn) {
        [self showLockViewForEnablingPasscode];
    }else{
        [self showLockViewForTurningPasscodeOff];
    }
}

- (void)showLockViewForEnablingPasscode {
	[[LTHPasscodeViewController sharedUser] showForEnablingPasscodeInViewController:self
                                                                            asModal:NO];
}


- (void)showLockViewForTestingPasscode {
	[[LTHPasscodeViewController sharedUser] showLockScreenWithAnimation:YES
                                                             withLogout:NO
                                                         andLogoutTitle:nil];
}


- (void)showLockViewForChangingPasscode {
	[[LTHPasscodeViewController sharedUser] showForChangingPasscodeInViewController:self asModal:YES];
}


- (void)showLockViewForTurningPasscodeOff {
	[[LTHPasscodeViewController sharedUser] showForDisablingPasscodeInViewController:self
                                                                             asModal:NO];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [super tableView:tableView numberOfRowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    // Configure the cell...

    return cell;
}

- (void)tableView:tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"exportData"]) {
        if ([MFMailComposeViewController canSendMail]) {
            
            UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:NSLocalizedString( @"Export Data:", "")
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString( @"Cancel", "")
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:
                                         NSLocalizedString( @"This week", ""),
                                         NSLocalizedString( @"This month", ""),
                                         NSLocalizedString( @"All", ""),nil];
            [actionSheet showInView:self.view];
            
        } else {
            [UIAlertView displayAlertWithTitle:[PubicVariable kPromptTitle]
                                       message:[PubicVariable kMailNotConfiguredMessage]];
        }
       
    }
    cell.selected = NO;
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:NSLocalizedString( @"This week", "")]) {
        [self exportCSVWithDateMode:week];
    }else if ([buttonTitle isEqualToString:NSLocalizedString( @"This month", "")]) {
        [self exportCSVWithDateMode:month];
    }else if ([buttonTitle isEqualToString:NSLocalizedString( @"All", "")]) {
        [self exportCSVWithDateMode:all];
    }
}



- (void)exportCSVWithDateMode:(NSInteger) dateMode
{
    NSString *filePath = [self filePathWithCSVWithDateMode:dateMode];
    [self displayComposerSheetWithFilePath:filePath withDateMode:(NSInteger) dateMode];
}


- (NSString *)filePathWithCSVWithDateMode:(NSInteger) dateMode
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Bills.csv"];
    
    NSArray *bills = [Bill billsWithDateMode:dateMode inManagedObjectContext:self.managedObjectContext];
    NSString *CSV = NSLocalizedString( @"Category,Money,Date,Descreption\n", "");
    for (Bill *bill in bills) {
        CSV = [CSV stringByAppendingFormat:@"%@,%@,%@,%@\n",bill.kind.name,bill.money,[PubicVariable stringFromDate:bill.date],bill.note];
    }
    NSError *error = nil;
    BOOL succeeded = [CSV writeToFile:filePath
                                  atomically:YES
                                    encoding:NSUTF8StringEncoding
                                       error:&error];
    if (succeeded) {
        NSLog(@"Successfully stored the file at: %@", filePath);
    } else {
        NSLog(@"Failed to store the file. Error = %@", error);
    }
    return filePath;

}
/*
*/
-(void)displayComposerSheetWithFilePath:(NSString *)filePath withDateMode:(NSInteger) dateMode
{
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        NSString *subject;
        switch (dateMode) {
            case week:
                subject = NSLocalizedString( @"Simple Billing This Week Data", "");
                break;
            case month:
                subject = NSLocalizedString( @"Simple Billing This Month Data", "");
                break;
            default:
                subject = NSLocalizedString( @"Simple Billing All Data", "");
                break;
        }
        
        [picker setSubject:subject];
        //
        NSData *myData = [NSData dataWithContentsOfFile:filePath];
        [picker addAttachmentData:myData mimeType:@"text/csv" fileName:@"Bills.csv"];
        
        NSString *emailBody = NSLocalizedString( @"It is Simple Billing Data!", "");
        [picker setMessageBody:emailBody isHTML:NO];
        
        picker.navigationController.navigationBar.barTintColor = PNRed;
        [self presentViewController:picker animated:YES completion:^(){}];
    } else {
        [UIAlertView displayAlertWithTitle:[PubicVariable kPromptTitle]
                                   message:[PubicVariable kMailNotConfiguredMessage]];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"Mail susess!");
    }
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subView in actionSheet.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            
            UIColor *normalTitleColor =             EBBlue;
            //UIColor *hightlightedTitleColor =       [UIColor whiteColor];
            
            
            [button setTitleColor:normalTitleColor forState:UIControlStateNormal];
            [button setTitleColor:normalTitleColor forState:UIControlStateHighlighted];
            [button setTitleColor:normalTitleColor forState:UIControlStateSelected];
            
            /*
            UIColor *normalBackgroudColor =         [UIColor whiteColor];
            UIColor *hightlightedBackgroudColor =   EBBlue;

            [button setBackgroundColor:normalBackgroudColor forState:UIControlStateNormal];
            [button setBackgroundColor:hightlightedBackgroudColor forState:UIControlStateHighlighted];
            [button setBackgroundColor:hightlightedBackgroudColor forState:UIControlStateSelected];
             */
            
        }
    }
    
}

- (UIView *)viewForHoldingRevealPanGesture {
    return self.view;
}

@end
