//
//  KindViewController.m
//  EasyBills
//
//  Created by luojie on 5/15/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "KindViewController.h"
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

@interface KindViewController ()

@property (strong, nonatomic) KindCDTVC *kindCDTVC;


@property (strong ,nonatomic) NSNumber *total;
@property (strong, nonatomic) NSArray *filters;

@property (weak, nonatomic) IBOutlet UIView *pieChartContainerView;
@property (weak, nonatomic) IBOutlet UILabel *chartTitleLabel;

@property (strong, nonatomic) NSMutableArray *pieChartKinds;

@end

@implementation KindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupMenuButton];
    [self resetFetchedResultsController];
    [self refreshPieChartContainerView];
    [self registerNotifications];

}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController applyDefualtStyle:YES];
    if (self.shouldRelaodData) {
        [self resetFetchedResultsController];
    }
    
}
- (void)dealloc {
    [self.filters enumerateObjectsUsingBlock:^(Filter *obj, NSUInteger idx, BOOL *stop) {
        [obj removeObserver:self forKeyPath:@"selectIndex"];
    }];
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
        [self resetFetchedResultsController];
        
    }
    
}



- (void)refreshPieChartContainerView {
  
    [self.pieChartContainerView setupBackgroundImage];
    
    for (NSNumber *tagNumber in @[@11,@12]) {
        UIView *view = [self.pieChartContainerView viewWithTag:tagNumber.integerValue];
        if (view.superview) {
            [view removeFromSuperview];
            view = nil;
        }
    }
    
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
        pieChart.center = CGPointMake(self.view.bounds.size.width/2,
                                      self.pieChartContainerView.bounds.size.height/2 - 25.0f);
        
        
        pieChart.descriptionTextColor = [UIColor whiteColor];
        pieChart.descriptionTextShadowColor = [UIColor clearColor];
        pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:12];
        pieChart.tag = 11;
        
        [self.pieChartContainerView addSubview:pieChart];

        [pieChart strokeChart];
        self.chartTitleLabel.text = [self chartTitle];
        
    } else {
        UIView *emptyView = [self emptyBackgroundViewWithSize:CGSizeMake(self.view.bounds.size.width,
                                                                         self.pieChartContainerView.frame.size.height)];
        emptyView.tag = 12;
        [self.pieChartContainerView addSubview:emptyView];
        self.chartTitleLabel.text = @"没有数据";
        
    }
    
 }

- (void)enumerateSumMoney {
    [self.fetchedResultsController.fetchedObjects
     enumerateObjectsUsingBlock:^(Kind *kind, NSUInteger idx, BOOL *stop) {
         NSLog(@"%@ : %.0f" ,kind.name ,kind.sumMoney.floatValue);
     }];
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




- (void)userClickedOnPieIndexItem:(NSInteger)pieIndex {
    Kind *kind = [self.pieChartKinds objectAtIndex:pieIndex];
    NSString *segueIdentifier = @"showBillByKind";
    [self performSegueWithIdentifier:segueIdentifier sender:kind];
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
//            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//            kind = [self.fetchedResultsController objectAtIndexPath:indexPath];
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
    } else if ([segue.identifier isEqualToString:@"embeddedTableView"]) {
        if ([segue.destinationViewController isKindOfClass:[KindCDTVC class]]) {
            KindCDTVC *kcdtvc = (KindCDTVC *)segue.destinationViewController;
            self.kindCDTVC = kcdtvc;
            kcdtvc.kindViewController = self;
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
    NSPredicate *datePredicate = [NSPredicate predicateWithbDateMode:[self dateMode] withDate:[NSDate date]];
    
    request.predicate = [NSPredicate predicateByCombinePredicate:kindPredicate withPredicate:datePredicate];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]
                                                            initWithFetchRequest:request
                                                            managedObjectContext:self.managedObjectContext
                                                            sectionNameKeyPath:nil
                                                            cacheName:nil];
    
    return fetchedResultsController;
}

- (void)resetFetchedResultsController
{
    
    
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
    self.kindCDTVC.fetchedResultsController = self.fetchedResultsController;
    
    [self refreshPieChartContainerView];
    self.shouldRelaodData = NO;
    //    [self enumerateSumMoney];
    
    //    [self updataHeaderView];
    
    
    
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

- (NSNumber *)total {
    float total =[PubicVariable sumMoneyWithIncomeMode:[self isIncomeMode]
                                          withDateMode:[self dateMode]
                                              withDate:[NSDate date]
                                inManagedObjectContext:self.managedObjectContext];
    
    return [NSNumber numberWithFloat:total];
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


- (NSArray *)filters {
    if (!_filters) {
        Filter *timeFilter = [Filter filterWithType: LJFilterTime];
        Filter *kindFilter = [Filter filterWithType: LJFilterKind];
        _filters = @[kindFilter, timeFilter,];
    }
    return _filters;
}


@end
