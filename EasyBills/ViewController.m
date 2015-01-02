//
//  ViewController.m
//  EasyBills
//
//  Created by 罗 杰 on 10/1/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "ViewController.h"
#import "PNChart.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"
#import "NYSegmentedControl.h"
#import "ACPButton.h"
#import "GetMoneyTableViewController.h"
#import "BillCoreDataTableViewController.h"
#import "PubicVariable.h"
#import "Kind+Create.h"
#import "ChartDate.h"
#import "LTHPasscodeViewController.h"
#import "MyCollectionViewController.h"
#import "SWRevealViewController.h"
#import "DefaultStyleController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet ACPButton *addButton;
@property (weak, nonatomic) IBOutlet ACPButton *reduceButton;
@property (weak, nonatomic) IBOutlet ACPButton *equalButton;
@property (weak, nonatomic) IBOutlet ACPButton *sumAddedMoneyButton;
@property (weak, nonatomic) IBOutlet ACPButton *sumReduceMoneyButton;
@property (weak, nonatomic) IBOutlet ACPButton *sumMoneyButton;


@property (strong, nonatomic) UILabel *lineChartLabel;
@property (strong, nonatomic) PNLineChart *lineChart;
@property (strong, nonatomic) NYSegmentedControl *segmentedControl;
@property (strong, nonatomic) ChartDate *chartDate;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self setupSegmentedControl];
    //[self setupButtons];
    [self updateUI];
    UIImage *image = [UIImage imageNamed:@"Account details BG.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = image;
    [self.view insertSubview:imageView atIndex:0];
    
    [self customSetup];
    
    
    if ([LTHPasscodeViewController doesPasscodeExist] &&
        [LTHPasscodeViewController didPasscodeTimerEnd]) {
        [[LTHPasscodeViewController sharedUser] showLockScreenWithAnimation:NO
                                                                 withLogout:NO
                                                             andLogoutTitle:nil];
        
	}
}

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    if ([PubicVariable managedObjectContextHasChanges]) {
        [self updateUI];
        PubicVariable *pubicVariable = [PubicVariable pubicVariable];
        pubicVariable.managedObjectContextHasChanges = NO;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)setupSegmentedControl
{
    
    //"本周", "本月", "总体"
    self.segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"本周", @"本月", @"总体"]];
    
    // Add desired targets/actions
    [self.segmentedControl addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];
    
    // Customize and size the control
    self.segmentedControl.borderWidth = 1.0f;
    self.segmentedControl.borderColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    
    self.segmentedControl.segmentIndicatorBorderWidth = 1.0f;
    self.segmentedControl.segmentIndicatorBorderColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    
    self.segmentedControl.drawsGradientBackground = YES;
    self.segmentedControl.gradientTopColor = [UIColor colorWithWhite:0.9f alpha:1.0];
    self.segmentedControl.gradientBottomColor = [UIColor colorWithWhite:0.9f alpha:1.0];
    
    self.segmentedControl.drawsSegmentIndicatorGradientBackground = YES;
    self.segmentedControl.segmentIndicatorGradientTopColor = [UIColor colorWithWhite:1.0f alpha:1.0];
    self.segmentedControl.segmentIndicatorGradientBottomColor = [UIColor colorWithWhite:1.0f alpha:1.0];
    
    self.segmentedControl.segmentIndicatorInset = 0.0f;
    self.segmentedControl.segmentIndicatorAnimationDuration = 0.3f;
    [self.segmentedControl sizeToFit];
    self.segmentedControl.selectedSegmentIndex = [PubicVariable dateMode];
    
    // Add the control to your view
    self.navigationItem.titleView = self.segmentedControl;
}

-(void)setupButtons
{
    [self.addButton setStyle:[PNFreshGreen colorWithAlphaComponent:0.5f] andBottomColor:PNFreshGreen];
    [self.addButton setLabelFont:[UIFont fontWithName:@"Trebuchet MS" size:50]];
    [self.sumAddedMoneyButton setStyle:[PNFreshGreen colorWithAlphaComponent:0.5f] andBottomColor:PNFreshGreen];
    [self.sumAddedMoneyButton setLabelFont:[UIFont fontWithName:@"Trebuchet MS" size:20]];
    
    [self.reduceButton setStyle:[PNRed colorWithAlphaComponent:0.5f] andBottomColor:PNRed];
    [self.reduceButton setLabelFont:[UIFont fontWithName:@"Trebuchet MS" size:50]];
    [self.sumReduceMoneyButton setStyle:[PNRed colorWithAlphaComponent:0.5f] andBottomColor:PNRed];
    [self.sumReduceMoneyButton setLabelFont:[UIFont fontWithName:@"Trebuchet MS" size:20]];
    
    [self.equalButton setStyle:[PNTwitterColor colorWithAlphaComponent:0.5f] andBottomColor:PNTwitterColor];
    [self.equalButton setLabelFont:[UIFont fontWithName:@"Trebuchet MS" size:50]];
    [self.sumMoneyButton setStyle:[PNTwitterColor colorWithAlphaComponent:0.5f] andBottomColor:PNTwitterColor];
    [self.sumMoneyButton setLabelFont:[UIFont fontWithName:@"Trebuchet MS" size:20]];
    
}

-(NSArray *)functineButtons
{
    return @[self.addButton,self.reduceButton,self.equalButton,self.sumAddedMoneyButton,self.sumReduceMoneyButton,self.sumMoneyButton];
}

-(void)segmentSelected
{
    [PubicVariable setDateMode:self.segmentedControl.selectedSegmentIndex];
    [self updateUI];
}


-(void)updateUI
{
    //Add LineChart
    if (self.lineChart) {
        [self.lineChartLabel removeFromSuperview];
        [self.lineChart removeFromSuperview];
    }
    self.lineChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 30)];
    
    NSString *string = @"● 收入  ● 支出";
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: EBBlue}];
    NSMutableAttributedString *mat = [attributedString mutableCopy];
    NSString *searchString = @"● 支出";
    NSRange range =[string rangeOfString:searchString];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: PNRed};
    [mat addAttributes:attributes range:range];
    
    self.lineChartLabel .attributedText = mat;
    //lineChartLabel.textColor = PNFreshGreen;
    self.lineChartLabel .font = [UIFont fontWithName:@"Avenir-Medium" size:20.0];
    self.lineChartLabel .textAlignment = NSTextAlignmentCenter;
    
    //For LineChart
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 55.0, SCREEN_WIDTH, 200.0)];
    self.lineChart.backgroundColor = [UIColor clearColor];
    [self.lineChart setXLabels:self.chartDate.xLabels];
    
    // Line Chart No.1
    NSArray * data01Array = self.chartDate.incomeDataArray;
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = EBBlue;
    data01.itemCount = self.lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    // Line Chart No.2
    NSArray * data02Array = self.chartDate.expenseDataArray;
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = PNRed;
    data02.itemCount = self.lineChart.xLabels.count;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.lineChart.chartData = @[data02, data01];
    [self.lineChart strokeChart];
    
    
    [self.view addSubview:self.lineChartLabel];
    [self.view addSubview:self.lineChart];
    float sumAddedMoney = [PubicVariable sumMoneyWithIncomeMode:isIncomeYes withDateMode:[PubicVariable dateMode]];
    float sumReduceMoney = [PubicVariable sumMoneyWithIncomeMode:isIncomeNo withDateMode:[PubicVariable dateMode]];
    float sumMoney = [PubicVariable sumMoneyWithIncomeMode:isIncomeNil withDateMode:[PubicVariable dateMode]];
    
    [self.sumAddedMoneyButton setTitle:[NSString stringWithFormat:@"￥ %.2f",sumAddedMoney] forState:UIControlStateNormal];
    [self.sumReduceMoneyButton setTitle:[NSString stringWithFormat:@"￥ %.2f",fabs(sumReduceMoney)] forState:UIControlStateNormal];
    [self.sumMoneyButton setTitle:[NSString stringWithFormat:@"￥ %.2f",sumMoney] forState:UIControlStateNormal];
    
}

-(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex andPointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

-(void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}

- (void)userClickedOnBarCharIndex:(NSInteger)barIndex
{
    
    NSLog(@"Click on bar %@", @(barIndex));
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"incomeSegue"]) {
        
        [self prepareForSegue:segue isIncome:YES];
        
    }else if([segue.identifier isEqualToString:@"expenseSegue"]) {
        
        [self prepareForSegue:segue isIncome:NO];
        
    }else if([segue.identifier isEqualToString:@"sumIncomeSegue"]) {
        
        [self prepareForSegue:segue withIncomeMode:isIncomeYes];
        
    }else if([segue.identifier isEqualToString:@"sumExpenseSegue"]) {
        
        [self prepareForSegue:segue withIncomeMode:isIncomeNo];
        
    }else if([segue.identifier isEqualToString:@"sumSegue"]) {
        
        [self prepareForSegue:segue withIncomeMode:isIncomeNil];
        
    }
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue isIncome:(BOOL)isIncome
{
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = segue.destinationViewController;
        if ([navigationController.viewControllers.firstObject isKindOfClass:[MyCollectionViewController class]]) {
            MyCollectionViewController *myCollectionViewController = navigationController.viewControllers.firstObject;
            myCollectionViewController.isIncome = isIncome;
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue withIncomeMode:(NSInteger)incomeMode
{
    if ([segue.destinationViewController isKindOfClass:[BillCoreDataTableViewController class]]) {
        BillCoreDataTableViewController *billCoreDataTableViewController = segue.destinationViewController;
        [self setFetchedResultsControllerWithbillCoreDataTableViewController:billCoreDataTableViewController  withIncomeMode:incomeMode];
        billCoreDataTableViewController.title = [self.segmentedControl titleForSegmentAtIndex: self.segmentedControl.selectedSegmentIndex];
    }
}

-(void)setFetchedResultsControllerWithbillCoreDataTableViewController:(BillCoreDataTableViewController *)billCoreDataTableViewController
                                                       withIncomeMode:(NSInteger)incomeMode
{
    NSString *sectionNameKeyPath;
    switch ([PubicVariable dateMode]) {
        case week:
            sectionNameKeyPath = @"weekday";
            break;
        case month:
            sectionNameKeyPath = @"weekOfMonth";
            break;
        default:
            sectionNameKeyPath = @"monthID";
            break;
    }
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bill"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sectionNameKeyPath ascending:NO],[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    NSPredicate *incomePredicate = [PubicVariable predicateWithIncomeMode:incomeMode];
    NSPredicate *datePredicate = [PubicVariable predicateWithbDateMode:[PubicVariable dateMode]];
    request.predicate = [PubicVariable addPredicate:incomePredicate withPredicate:datePredicate];
    billCoreDataTableViewController.isIncomeMode = incomeMode;
    billCoreDataTableViewController.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                                   managedObjectContext:[PubicVariable managedObjectContext]
                                                                                                     sectionNameKeyPath:sectionNameKeyPath
                                                                                                              cacheName:nil];
}



-(ChartDate *)chartDate
{
    if (!_chartDate) {
        _chartDate = [[ChartDate alloc]init];
    }
    return _chartDate;
}



@end