//
//  LicenseTVC.m
//  EasyBills
//
//  Created by luojie on 5/10/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "LicenseTVC.h"
#import "UINavigationController+Style.h"

@interface LicenseTVC ()

@property (nonatomic, strong, readonly) NSArray *licenses;

@end

@implementation LicenseTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController applyDefualtStyle:NO];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
//    [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.licenses.count;
//    [super tableView:tableView numberOfRowsInSection:section];
}




NSString *const kLicenseProjectName = @"LicenseProjectName";
NSString *const kLicenseInfo = @"LicenseInfo";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *license = [self.licenses objectAtIndex:indexPath.row];
    
    //     Configure the cell...
    [self configureCell:cell useLicense:license];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell useLicense:(NSDictionary *)license {
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:2];
    
    label.text = [license objectForKey:kLicenseProjectName];
    detailLabel.text = [license objectForKey:kLicenseInfo];

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"License" : nil;
}

#pragma mark - Property Setter And Getter Method

- (NSArray *)licenses {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath   = [mainBundle pathForResource:@"Licenses" ofType:@"plist"];
    
    NSArray* _licenses = [[NSArray alloc] initWithContentsOfFile:filePath];
    if (_licenses == nil) {
        NSLog(@"Failed to load plist of Licenses.");
    }
    return _licenses;
}


@end
