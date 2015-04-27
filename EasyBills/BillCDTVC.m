//
//  BillCoreDataTableViewController.m
//  我的账本
//
//  Created by 罗 杰 on 9/14/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "BillCDTVC.h"
#import "Bill+Create.h"
#import "PubicVariable.h"
#import "HomeViewController.h"
#import "MapCDTVC.h"
#import "BillDetailCVC.h"
#import "DefaultStyleController.h"
#import "UINavigationController+Style.h"

@interface BillCDTVC ()

@property (weak, nonatomic) IBOutlet UILabel *equalLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation BillCDTVC

#pragma mark - UIView Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFetchedResultsController];
    [self upadateFootView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController applyDefualtStyle:NO];
    if (self.shouldRelaodData){
        [self.tableView reloadData];
        self.shouldRelaodData = NO;
    }
}

#pragma mark - NSFetchedResultsControllerDelegate



- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    [super controller:controller
      didChangeObject:anObject
          atIndexPath:indexPath
        forChangeType:type
         newIndexPath:newIndexPath];
    
    self.shouldRelaodData = YES;
    [self upadateFootView];
}


#pragma mark - Some Method


- (void)upadateFootView {
    NSNumber *sum = [self.fetchedResultsController.fetchedObjects
                     valueForKeyPath:@"@sum.money"];
    
    self.sumLabel.text = [NSString stringWithFormat:@" ¥ %.0f  ",
                          fabs(sum.floatValue)];
    
    self.countLabel.text = [NSString stringWithFormat:@" 共%lu笔   ",
                            (unsigned long)self.fetchedResultsController.fetchedObjects.count];
    
    self.equalLabel.font = [self.equalLabel.font fontWithSize:25];
    self.sumLabel.textColor = sum.floatValue >= 0 ? EBBlue : PNRed;
    
    [self showEmptyBackgroundIfNeeded];
}

- (void)showEmptyBackgroundIfNeeded {
    //If there is no data, Display a label instead.
    if (self.fetchedResultsController.fetchedObjects.count == 0){
        self.tableView.backgroundView = [self emptyBackgroundView];
        self.tableView.tableFooterView = nil;
    }
}

- (UIView *)emptyBackgroundView {
    UIView *result = [[UIView alloc] initWithFrame:self.tableView.bounds];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"没有账单";
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textColor = EBBackGround;
    [label sizeToFit];
    label.center = CGPointMake(self.tableView.bounds.size.width  / 2,
                               self.tableView.bounds.size.height / 2 );
    [result addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = [UIImage imageNamed:@"DrawerIcon"];
    [imageView sizeToFit];
    imageView.tintColor = EBBackGround;
    imageView.center = CGPointMake(self.tableView.bounds.size.width  / 2,
                                   self.tableView.bounds.size.height / 2 - 50);
    [result addSubview:imageView];
    return result;
}




-(float)maxBillMoney
{
    float result = 0;
    NSPredicate *predicate = self.fetchedResultsController.fetchRequest.predicate;
    float maxFloat = [PubicVariable performeFetchForFunction:@"max:" WithPredicate:predicate];
    float minFloat = [PubicVariable performeFetchForFunction:@"min:" WithPredicate:predicate];
    result = MAX(fabs(maxFloat), fabs(minFloat));
    return result;
}




- (void)setupFetchedResultsController {
    if (!self.fetchedResultsController) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bill"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        request.predicate = nil;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                         initWithFetchRequest:request
                                         managedObjectContext:[PubicVariable managedObjectContext]
                                         sectionNameKeyPath:nil
                                         cacheName:nil];
    }
}

#pragma mark - UITable View Data Source
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bill"];
    Bill *bill = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configCell:cell WithBill:bill];
    return cell;
}

-(void)configCell:(UITableViewCell *)cell WithBill:(Bill *)bill
{
    //cell.textLabel.text = [NSString stringWithFormat:@"￥  %.2f",fabs(bill.money.floatValue)];
    UILabel *kindLabel =  (UILabel *)[cell viewWithTag:1];
    UILabel *moneyLabel =  (UILabel *)[cell viewWithTag:2];
    UILabel *dateLabel =  (UILabel *)[cell viewWithTag:3];
    
    kindLabel.text = [NSString stringWithFormat:@"%@  ",[bill.kind.name description]];
    moneyLabel.text = [NSString stringWithFormat:@" ¥ %.0f  ",fabs(bill.money.floatValue)];
    dateLabel.text = [NSString stringWithFormat:@"%@  ", [PubicVariable stringFromDate:bill.date]];
    
    kindLabel.backgroundColor = bill.kind.color;
    moneyLabel.backgroundColor = bill.isIncome.boolValue ? EBBlue : PNRed;
    
//    [kindLabel setHighlightedTextColor:[UIColor whiteColor]];
//    //     kindLabel.backgroundColor];
//    [moneyLabel setHighlightedTextColor:[UIColor whiteColor]];
////     moneyLabel.backgroundColor];
//    [dateLabel setHighlightedTextColor:[UIColor whiteColor]];
////     dateLabel.backgroundColor];
//    
}

- (CGFloat)     tableView:(UITableView *)tableView
  heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 60.0f;
}

#pragma mark - UITable View Data Delegate 
- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.shouldRelaodData = YES;

//    [self.tableView
//     reloadRowsAtIndexPaths:@[indexPath]
//     withRowAnimation:UITableViewRowAnimationAutomatic];
}



#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class] ]) {
        if ([segue.identifier isEqualToString:@"showBill"]) {
            if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navigationController = segue.destinationViewController;
                if ([navigationController.topViewController isKindOfClass:[BillDetailCVC class]]) {
                    BillDetailCVC *myCollectionViewController = (BillDetailCVC *)navigationController.topViewController;
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
                    Bill *bill = [self.fetchedResultsController objectAtIndexPath:indexPath];
                    myCollectionViewController.bill = bill;
                    
                    NSLog(@"showBill");
                }
            }
        }
    }else if ([sender isKindOfClass:[UIBarButtonItem class]])
    {
        if ([segue.identifier isEqualToString:@"showMap"]) {
            if ([segue.destinationViewController isKindOfClass:[MapCDTVC class]]) {
                MapCDTVC *mapCDTVC = segue.destinationViewController;
                mapCDTVC.fetchedResultsController = self.fetchedResultsController;
            }
        }
    }
    
}



/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    NSInteger sectionHeaderInt = [[[self.fetchedResultsController sections] objectAtIndex:section] name].intValue;
    NSString *sectionNameKeyPath = self.fetchedResultsController.sectionNameKeyPath;
    if ([sectionNameKeyPath isEqualToString:@"weekday"]) {
        title = @[@"??",@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"][sectionHeaderInt];
    }else if([sectionNameKeyPath isEqualToString:@"weekOfMonth"]) {
        title = @[@"??",@"第一周",@"第二周",@"第三周",@"第四周",@"第五周",@"第六周"][sectionHeaderInt];
    }else if([sectionNameKeyPath isEqualToString:@"monthID"]){
        NSInteger year = sectionHeaderInt / 1000;
        NSInteger month = sectionHeaderInt % 100;
        title = [NSString stringWithFormat:@"%i年 %i月",year,month];
    }
	//return title;
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bill"];
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    cell.textLabel.text = title;
    return cell;
}

-(float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    BillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bill"];
    return cell.frame.size.height;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSArray *sections = [self.fetchedResultsController sections];
    for (NSInteger sectionIndex = 0; sectionIndex < sections.count ; sectionIndex++ ) {
        NSString *title;
        NSInteger sectionHeaderInt = [[[self.fetchedResultsController sections] objectAtIndex:sectionIndex] name].intValue;
        NSString *sectionNameKeyPath = self.fetchedResultsController.sectionNameKeyPath;
        if ([sectionNameKeyPath isEqualToString:@"weekday"]) {
            title = @[@"??",@"日",@"一",@"二",@"三",@"四",@"五",@"六"][sectionHeaderInt];
        }else if([sectionNameKeyPath isEqualToString:@"weekOfMonth"]) {
            title = @[@"??",@"一",@"二",@"三",@"四",@"五",@"六"][sectionHeaderInt];
        }else if([sectionNameKeyPath isEqualToString:@"monthID"]){
            title = [NSString stringWithFormat:@"%i",(sectionHeaderInt % 100)];
        }
        [mutableArray addObject:title];
    }
    return nil;//[mutableArray copy];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return index;
}
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
