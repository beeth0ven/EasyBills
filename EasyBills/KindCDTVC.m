//
//  KindCoreDataTableViewController.m
//  EasyBills
//
//  Created by 罗 杰 on 10/10/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "KindCDTVC.h"
#import "Bill+Create.h"
#import "PubicVariable.h"
#import "HomeViewController.h"
#import "Kind+Create.h"
#import "SWRevealViewController.h"
#import "PubicVariable+FetchRequest.h"
#import "DefaultStyleController.h"
#import "BillCDTVC.h"
#import "UIViewController+Extension.h"
#import "UINavigationController+Style.h"
#import "KindDetailCVC.h"
#import "ColorCenter.h"
#import "FilterTableViewController.h"
#import "Filter.h"
#import "PNColor.h"
#import "UICountingLabel.h"
#import "UIStoryboardSegue+Extension.h"
#import "NSPredicate+PrivateExtension.h"
#import "UIView+Extension.h"
#import "NSString+Extension.h"

@interface KindCDTVC ()



//@property (nonatomic) BOOL isIncome;



@end

@implementation KindCDTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    [self setupBackgroundImage];
    
}





//- (NSPredicate *)predicateWithFilters {
//    
//    NSPredicate *result = nil;
//    
//    NSPredicate *incomePredicate = [PubicVariable predicateWithIncomeMode:[self isIncomeMode]];
//    NSPredicate *datePredicate = [PubicVariable predicateWithbDateMode:[self dateMode]];
//    result = [PubicVariable addPredicate:incomePredicate withPredicate:datePredicate];
//
//    
//    return result;
//}




#pragma mark - Table view data source

-(UITableViewCell *)        tableView:(UITableView *)tableView
                cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kind"];
    Kind *kind = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configCell:cell WithKind:kind];
    return cell;
}

-(void)configCell:(UITableViewCell *)cell WithKind:(Kind *)kind
{
    UILabel *indexLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:3];
    UIView *circleView = (UIView *)[cell viewWithTag:4];
    
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:kind];
    NSNumber *current =[NSNumber numberWithFloat:
                        fabs([PubicVariable sumMoneyWithKind:kind
                                                    dateMode:self.kindViewController.dateMode
                                      inManagedObjectContext:self.kindViewController.managedObjectContext])];
    indexLabel.text = [NSString stringWithFormat:@"%@.",@(indexPath.row + 1)];
    label.text = [NSString stringWithFormat:@"  %@  ",[kind.name description]];
    circleView.backgroundColor = kind.color;
    
    detailLabel.text = [NSString stringWithCurrencyStyleForFloat:current.floatValue];

}







- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}





#pragma mark - Table view delegate

- (void)            tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [self.tableView
//     reloadRowsAtIndexPaths:@[indexPath]
//     withRowAnimation:UITableViewRowAnimationAutomatic];
    Kind *kind = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *segueIdentifier = @"showBillByKind";
    [self.kindViewController performSegueWithIdentifier:segueIdentifier sender:kind];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - NSFetched Results Controller Delegate
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    [super controller:controller
      didChangeObject:anObject
          atIndexPath:indexPath
        forChangeType:type
         newIndexPath:newIndexPath];
    
    self.kindViewController.shouldRelaodData = YES;
    
    
}



/*
*/

@end
