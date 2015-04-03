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
#import "BillTVCell.h"
#import "MapCDTVC.h"
#import "BillDetailCVC.h"
#import "DefaultStyleController.h"
#import "UINavigationController+Style.h"

@interface BillCDTVC ()

@end

@implementation BillCDTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.fetchedResultsController) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bill"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        request.predicate = nil;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[PubicVariable managedObjectContext]
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    }
    
//    UIBarButtonItem *backBarButton =
//    [[UIBarButtonItem alloc] initWithTitle:@" "
//                                     style:UIBarButtonItemStylePlain
//                                    target:nil
//                                    action:nil];
//    
//    self.navigationItem.backBarButtonItem = backBarButton;
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController applyDefualtStyle:NO];
}




- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bill"];
    Bill *bill = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configCell:cell WithBill:bill];
    return cell;
}

-(void)configCell:(BillTVCell *)cell WithBill:(Bill *)bill
{
    //cell.textLabel.text = [NSString stringWithFormat:@"￥  %.2f",fabs(bill.money.floatValue)];

    /**/
    cell.textLabel.text = [NSString stringWithFormat:@"  %@  ",[bill.kind.name description]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"  %.0f  ",fabs(bill.money.floatValue)];
    cell.textLabel.backgroundColor = bill.kind.color;
    cell.barColor = bill.kind.color;
//    bill.isIncome.boolValue ? EBBlue : PNRed;
    float maxBillMoney = [self maxBillMoney];
    float money = fabs(bill.money.floatValue);
    cell.grade = money/maxBillMoney;
    
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

#pragma mark - UITableViewDataSource
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
