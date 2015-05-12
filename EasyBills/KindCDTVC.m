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

@interface KindCDTVC ()



//@property (nonatomic) BOOL isIncome;
@property (strong ,nonatomic) NSNumber *total;
@property (strong, nonatomic) NSArray *filters;

@property (strong, nonatomic) NSMutableArray *pieChartKinds;


@end

@implementation KindCDTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupMenuButton]; 
    [self registerNotifications];
    [self resetFetchedResultsController];
//    [self setupBackgroundImage];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController applyDefualtStyle:YES];
    if (self.shouldRelaodData) {
        if (self.refreshControl) {
            [self.refreshControl beginRefreshing];
        }
        [self refresh:self.refreshControl];
    }

}

- (void)dealloc {
    [self.filters enumerateObjectsUsingBlock:^(Filter *obj, NSUInteger idx, BOOL *stop) {
        [obj removeObserver:self forKeyPath:@"selectIndex"];
    }];
}




- (IBAction)refresh:(UIRefreshControl *)sender {
    [self resetFetchedResultsController];
    [sender endRefreshing];
    self.shouldRelaodData = NO;
}


-(void)registerNotifications {
    [self.filters enumerateObjectsUsingBlock:^(Filter *obj, NSUInteger idx, BOOL *stop) {
        [obj addObserver:self
                 forKeyPath:@"selectIndex"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    }];
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    
    if ([keyPath isEqualToString:@"selectIndex"]) {
//        NSNumber *newValue = [change objectForKey:NSKeyValueChangeNewKey];
//        if ([newValue respondsToSelector:@selector(integerValue)]) {
//            NSInteger selectIndex = newValue.integerValue;
//            if ([object isKindOfClass:[Filter class]]) {
//                Filter *filter = (Filter *)object;
//                if ([filter.name isEqualToString:@"分类"]) {
//                    
//                }else if ([filter.name isEqualToString:@"时间"]){
//                    
//                }
//            }
//        
//            
//        }
        [self resetFetchedResultsController];
        
    }
    
}

- (void)resetFetchedResultsController
{
    
    float total =[PubicVariable sumMoneyWithIncomeMode:[self isIncomeMode]
                                          withDateMode:[self dateMode]
                                inManagedObjectContext:self.managedObjectContext];
    
    self.total = [NSNumber numberWithFloat:total];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kind"];
    request.sortDescriptors = @[[NSSortDescriptor
                                 sortDescriptorWithKey:@"sumMoney"
                                 ascending:[self isIncomeMode] == isIncomeYes ? NO : YES]
//                                [NSSortDescriptor sortDescriptorWithKey:@"isIncome" ascending:NO],
//                                [NSSortDescriptor sortDescriptorWithKey:@"visiteTime" ascending:NO]
                                ];
    
    request.predicate = [NSPredicate predicateWithIncomeMode:[self isIncomeMode]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:self.managedObjectContext
                                     sectionNameKeyPath:nil
                                     cacheName:nil];

//    [self enumerateSumMoney];
    
//    [self updataHeaderView];
    

    
}


- (void)enumerateSumMoney {
    [self.fetchedResultsController.fetchedObjects
     enumerateObjectsUsingBlock:^(Kind *kind, NSUInteger idx, BOOL *stop) {
        NSLog(@"%@ : %.0f" ,kind.name ,kind.sumMoney.floatValue);
    }];
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

- (NSInteger)isIncomeMode {
    Filter *kindFilter = self.filters[0];
    NSInteger isIncomeMode;
    switch (kindFilter.selectIndex) {
            
        case LJKindFilterTypeExpenses:
            isIncomeMode = isIncomeNo;
            break;
            
        default:
            isIncomeMode = isIncomeYes;
            break;

    }
    
    return isIncomeMode;
}

- (NSInteger)dateMode {
    
    Filter *timeFilter = self.filters[1];
    
    NSInteger dateMode;
    switch (timeFilter.selectIndex) {
        case LJTimeFilterTypeAll:
            dateMode = all;
            break;
        case LJTimeFilterTypeMonth:
            dateMode = month;
            break;
            
        default:
            dateMode = week;
            break;
    }
    
    return dateMode;
}



- (NSArray *)filters {
    if (!_filters) {
        Filter *timeFilter = [Filter filterWithType: LJFilterTime];
        Filter *kindFilter = [Filter filterWithType: LJFilterKind];
        _filters = @[kindFilter, timeFilter,];
    }
    return _filters;
}



//-(void)updataHeaderView
//{
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"header"];
//    [self configHeaderCell:cell];
//    //reuse cell refer to http://stackoverflow.com/questions/12772197/what-is-the-meaning-of-the-no-index-path-for-table-cell-being-reused-message-i
//    
//    UIView *tableHeaderView = [[UIView alloc] initWithFrame:cell.frame];
//    [tableHeaderView addSubview:cell];
//    self.tableView.tableHeaderView = tableHeaderView;
//}
//
//
//-(void) configHeaderCell:(UITableViewCell *)cell
//{
//    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNRed],
//                       [PNPieChartDataItem dataItemWithValue:20 color:PNBlue description:@"WWDC"],
//                       [PNPieChartDataItem dataItemWithValue:40 color:PNGreen description:@"GOOL I/O"],
//                       ];
//    
//    
//    
//    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(80, 20.0, 160, 160) items:items];
//    pieChart.descriptionTextColor = [UIColor whiteColor];
//    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:9];
//    
//    [cell addSubview:pieChart];
//    [pieChart strokeChart];
//
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
                                                    dateMode:[self dateMode]
                                      inManagedObjectContext:self.managedObjectContext])];
    indexLabel.text = [NSString stringWithFormat:@"%li.",indexPath.row + 1];
    label.text = [NSString stringWithFormat:@"  %@  ",[kind.name description]];
    circleView.backgroundColor = kind.color;
    detailLabel.text = [NSString stringWithFormat:@"¥  %.0f",current.floatValue];

}


-(UIView *)     tableView:(UITableView *)tableView
   viewForHeaderInSection:(NSInteger)section
{
    CGFloat width = self.tableView.frame.size.width;
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"section"];
    cell.frame = CGRectMake(0, 0, width, height);
    [cell setupBackgroundImage];
    UILabel *chartTitleLabel = (UILabel *)[cell viewWithTag:2];

    NSMutableArray *items = [[NSMutableArray alloc] init];
    self.pieChartKinds = [[NSMutableArray alloc] init];

    [self.fetchedResultsController.fetchedObjects enumerateObjectsUsingBlock:^(Kind *kind, NSUInteger idx, BOOL *stop) {
        float sum = fabs([PubicVariable
                          sumMoneyWithKind:kind
                          dateMode:[self dateMode]
                          inManagedObjectContext:self.managedObjectContext]);
        if (sum > 0) {
            PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:sum color:kind.color];
            [items addObject:item];
            [self.pieChartKinds addObject:kind];
        }
    }];
    
    if (items.count) {
        PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 0, 160, 160) items:items];
        pieChart.delegate = self;
        pieChart.center = CGPointMake(cell.bounds.size.width/2, cell.bounds.size.height/2 - 25.0f);
        pieChart.descriptionTextColor = [UIColor whiteColor];
        pieChart.descriptionTextShadowColor = [UIColor clearColor];
        pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:12];
        
        [cell addSubview:pieChart];
        [pieChart strokeChart];
        chartTitleLabel.text = [self chartTitle];

    } else {
        UIView *emptyView = [self emptyBackgroundViewWithSize:cell.frame.size];
        [cell addSubview:emptyView];
        chartTitleLabel.text = @"没有数据";

    }
    
    
    
    
    
        //fix bug when update section , section has no indexpath and will not be updated;
    cell.frame = CGRectMake(0, 0, cell.frame.size.width, height);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            width,
                                                            height)];
//    view.backgroundColor = [UIColor grayColor];
    [view addSubview:cell];
    
    return view;
}


- (void)userClickedOnPieIndexItem:(NSInteger)pieIndex {
    Kind *kind = [self.pieChartKinds objectAtIndex:pieIndex];
    NSString *segueIdentifier = @"showBillByKind";
    [self performSegueWithIdentifier:segueIdentifier sender:kind];
}


- (UIView *)emptyBackgroundViewWithSize:(CGSize)size {
    UIView *result = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              size.width,
                                                              size.height)];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = [UIImage imageNamed:@"DrawerIcon"];
    [imageView sizeToFit];
    imageView.tintColor = EBBackGround;
    imageView.center = CGPointMake(size.width  / 2,
                                   size.height / 2 );
    [result addSubview:imageView];
    return result;
}


- (NSString *)chartTitle {
    NSMutableString *mutableString = [@"" mutableCopy];
    switch ([self dateMode]) {
        case all:
            [mutableString appendString:@"总体"];
            break;
        case week:
            [mutableString appendString:@"本周"];
            break;
        default:
            [mutableString appendString:@"本月"];
            break;
    }
    switch ([self isIncomeMode]) {
        case isIncomeNo:
            [mutableString appendString:@"支出"];
            break;
        default:
            [mutableString appendString:@"收入"];
            break;
    }
    [mutableString appendString:@"饼图"];
    return mutableString;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(CGFloat)        tableView:(UITableView *)tableView
 heightForHeaderInSection:(NSInteger)section
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"section"];
    return 244;
}




#pragma mark - Table view delegate

- (void)            tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView
     reloadRowsAtIndexPaths:@[indexPath]
     withRowAnimation:UITableViewRowAnimationAutomatic];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *segueIdentifier = @"showBillByKind";
    [self performSegueWithIdentifier:segueIdentifier sender:cell];
    
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
  
        self.shouldRelaodData = YES;
    

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [segue passManagedObjectContextIfNeeded];
    

    
    if ([segue.identifier isEqualToString:@"showBillByKind"]) {
        Kind *kind;
        if ([sender isKindOfClass:[Kind class]]){
            //Pie chart segue
            kind = sender;
        } else if ([sender isKindOfClass:[UITableViewCell class]]) {
            //Cell Segue
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            kind = [self.fetchedResultsController objectAtIndexPath:indexPath];
        }
        if (kind && [segue.destinationViewController isKindOfClass:[BillCDTVC class]]) {
            BillCDTVC *billCoreDataTableViewController = segue.destinationViewController;
            billCoreDataTableViewController.fetchedResultsController = [self fetchedResultsControlleWithKind:kind];
            billCoreDataTableViewController.title = kind.name;
        }
    } else if ([segue.identifier isEqualToString:@"filter"]) {
        if ([segue.destinationViewController isKindOfClass:[FilterTableViewController class]]) {
            FilterTableViewController *ftvc = (FilterTableViewController *)segue.destinationViewController;
            ftvc.filters = self.filters;
            UIPopoverPresentationController *ppc = ftvc.popoverPresentationController;
            ppc.backgroundColor = ftvc.tableView.backgroundColor;
            ppc.delegate = self;
        }
    }
    
    
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}



- (NSFetchedResultsController *)fetchedResultsControlleWithKind:(Kind *)kind
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Bill"];
    
    NSPredicate *kindPredicate = [NSPredicate predicateWithFormat:@"kind = %@" , kind];
    NSPredicate *datePredicate = [NSPredicate predicateWithbDateMode:[self dateMode]];

    request.predicate = [kindPredicate predicateCombineWithPredicate:datePredicate];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]
                                                            initWithFetchRequest:request
                                                            managedObjectContext:self.managedObjectContext
                                                            sectionNameKeyPath:nil
                                                            cacheName:nil];

    return fetchedResultsController;
}


/*
*/

@end
