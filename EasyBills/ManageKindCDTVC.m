//
//  ManageKindCDTVC.m
//  EasyBills
//
//  Created by luojie on 4/19/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "ManageKindCDTVC.h"
#import "PubicVariable+FetchRequest.h"
#import "Kind+Create.h"
#import "UINavigationController+Style.h"
#import "HomeViewController.h"

@interface ManageKindCDTVC ()

@end

@implementation ManageKindCDTVC

#pragma mark - UIView Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupFetchedResultsController];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController applyDefualtStyle:NO];

}


#pragma mark - UITable View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kind"];
    Kind *kind = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configCell:cell WithKind:kind];
    return cell;
}

-(void)configCell:(UITableViewCell *)cell WithKind:(Kind *)kind {
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@  ",[kind.name description]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@" %@ ",kind.isIncomeDescription];

    cell.textLabel.backgroundColor = kind.color;
    cell.detailTextLabel.backgroundColor = kind.isIncome.boolValue ? EBBlue : PNRed;

    [cell.textLabel setHighlightedTextColor: cell.textLabel.backgroundColor];
    [cell.detailTextLabel setHighlightedTextColor: cell.detailTextLabel.backgroundColor];

}

- (CGFloat)     tableView:(UITableView *)tableView
  heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 50.0f;
}

#pragma mark - UITable View Data Delegate
- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView
     reloadRowsAtIndexPaths:@[indexPath]
     withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Some Method

- (void)setupFetchedResultsController {
    if (!self.fetchedResultsController) {
        NSFetchRequest *request = [[NSFetchRequest alloc]
                                   initWithEntityName:@"Kind"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"isIncome" ascending:YES],
                                    [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES]];
        request.predicate = nil;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                         initWithFetchRequest:request
                                         managedObjectContext:[PubicVariable managedObjectContext]
                                         sectionNameKeyPath:nil
                                         cacheName:nil];

    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
