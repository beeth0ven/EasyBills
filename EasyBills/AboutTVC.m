//
//  AboutTableViewController.m
//  EasyBills
//
//  Created by luojie on 5/10/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "AboutTVC.h"
#import "UIViewController+Extension.h"
#import "UINavigationController+Style.h"
#import "AppDelegate.h"
#import "UIAlertView+Extension.h"


@interface AboutTVC ()

@property (nonatomic, strong, readonly) NSString *appVersion;

@end

@implementation AboutTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    /*
     UIImage *image = [UIImage imageNamed:@"Account details BG.png"];
     UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
     self.tableView.backgroundView = imageView;
     */
    [self setupMenuButton];
    [self setupBackgroundImage];
    [self resizeTableFooterViewHeightToFitTableview];
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewWillAppear:(BOOL)animated
{
    //self.navigationController.navigationBar.barTintColor = PNTwitterColor;
    [self.navigationController applyDefualtStyle:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enableRevealPanGesture];
}

- (void)resizeTableFooterViewHeightToFitTableview {
    UIView *tableHeaderView = self.tableView.tableHeaderView;
    UIView *tableFooterView = self.tableView.tableFooterView;
    
    NSIndexPath *indexPathh = [NSIndexPath indexPathForRow:0 inSection:0];
    CGFloat rowHeight = [self tableView:self.tableView heightForRowAtIndexPath:indexPathh];
//    self.tableView.rowHeight;
    NSUInteger rowCount = [self tableView:self.tableView numberOfRowsInSection:0];
    
    
    CGFloat tableFooterViewHeight = self.tableView.bounds.size.height-tableHeaderView.bounds.size.height-rowHeight*rowCount-self.navigationController.navigationBar.bounds.size.height-30;
    
//    NSLog(@"tableHeaderView.bounds.size.height: %.1f,",tableHeaderView.bounds.size.height);
//    NSLog(@"rowHeight: %.1f,",rowHeight);
//    NSLog(@"rowCount: %lu,",(unsigned long)rowCount);
//    NSLog(@"tableFooterViewHeight: %.1f,",tableFooterViewHeight);

    tableFooterView.frame = CGRectMake(tableFooterView.frame.origin.x,
                                       tableFooterView.frame.origin.y,
                                       tableFooterView.frame.size.width,
                                       tableFooterViewHeight);
    
//    NSLog(@"height: %.1f,",self.tableView.contentSize.height - self.tableView.bounds.size.height);

}

- (IBAction)followMeOnTwitter:(UIButton *)sender {
    NSLog(@"followMeOnTwitter");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/LuoJie6"]];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [super tableView:tableView numberOfRowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
//     Configure the cell...
    if ([cell.reuseIdentifier isEqualToString:@"VersionCell"]) {
        cell.detailTextLabel.text = self.appVersion;
    }
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 1.0f;
//}

#pragma mark - Table view data delegate

NSInteger const kGetRateCellTag = 2;
NSInteger const kFeedbackCellTag = 4;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if (cell.tag == kGetRateCellTag) {
        NSString *appStoreLink = @"https://itunes.apple.com/us/app/simple-billing-easiest/id996352544?ls=1&mt=8";
        NSURL *url = [NSURL URLWithString:appStoreLink];
        [[UIApplication sharedApplication] openURL:url];
        NSLog(@"去 App Store 打分");
    } else if (cell.tag == kFeedbackCellTag) {
        [self showFeedback];
    }
}

- (void)showFeedback {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        NSString *subject = [NSString stringWithFormat:NSLocalizedString( @"Feedback - Simple Billing - %@", ""),self.appVersion];
        NSArray *toRecipients = @[@"beeth0vendev@163.com"];
        
        [picker setSubject:subject];
        [picker setToRecipients:toRecipients];
        
        [self presentViewController:picker animated:YES completion:^(){}];
    } else {
        [UIAlertView displayAlertWithTitle:[PubicVariable kPromptTitle]
                                   message:[PubicVariable kMailNotConfiguredMessage]];
    }
    
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"Mail success!");
    }
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

- (NSString *)appVersion {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.appVersion;
}

- (UIView *)viewForHoldingRevealPanGesture {
    return self.view;
}

@end
