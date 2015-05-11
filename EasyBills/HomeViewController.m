//
//  ViewController.m
//  EasyBills
//
//  Created by 罗 杰 on 10/1/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "HomeViewController.h"
#import "PNChart.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"
#import "BillCDTVC.h"
#import "PubicVariable.h"
#import "Kind+Create.h"
#import "ChartDate.h"
#import "LTHPasscodeViewController.h"
#import "BillDetailCVC.h"
#import "SWRevealViewController.h"
#import "DefaultStyleController.h"
#import "DZNSegmentedControl.h"
#import "UINavigationController+Style.h"
#import "UIViewController+Extension.h"
#import "CustomPresentAnimationController.h"
#import "CustomDismissAnimationController.h"
#import "UIFont+Extension.h"
#import "UIStoryboardSegue+Extension.h"
#import "NSPredicate+PrivateExtension.h"
#import "UIViewController+Extension.h"

@interface HomeViewController () <DZNSegmentedControlDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIButton *sumAddedMoneyButton;
@property (weak, nonatomic) IBOutlet UIButton *sumReduceMoneyButton;
@property (weak, nonatomic) IBOutlet UIButton *sumMoneyButton;


@property (strong, nonatomic) UILabel *lineChartLabel;
@property (strong, nonatomic) PNLineChart *lineChart;
@property (strong, nonatomic) DZNSegmentedControl *segmentedControl;
@property (strong, nonatomic) ChartDate *chartDate;


@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) CustomPresentAnimationController *customPresentAnimationController;
@property (nonatomic, strong) CustomDismissAnimationController *customDismissAnimationController;

@property (nonatomic) BOOL shouldUpdateUI;

@end

@implementation HomeViewController

#pragma mark - View Controller Life Cycle Method

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupSegmentedControl];
    [self updateUI];
    [self setupMenuButton];
    [self setupBackgroundImage];
    [self registerNotifications];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController applyDefualtStyle:YES];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.shouldUpdateUI) {
        [self updateUI];
        self.shouldUpdateUI = NO;
    }
}

- (void)dealloc {
    [self removeObserver:self.managedObjectContext forKeyPath:@"hasChanges"];
}

#pragma mark - Navigation Method

- (void)registerNotifications {
    //    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [self.managedObjectContext addObserver:self
                                forKeyPath:@"hasChanges"
                                   options:NSKeyValueObservingOptionNew
                                   context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"hasChanges"]) {
        if (self.view.window) {
            [self updateUI];
        } else {
            self.shouldUpdateUI = YES; 
        }
    }
    
}


#pragma mark - SetUp Method


-(void)setupSegmentedControl
{
    
    //"本周", "本月", "总体"
    self.segmentedControl = [[DZNSegmentedControl alloc]
                             initWithItems:@[@"本周", @"本月", @"总体"]];
    
    self.segmentedControl.frame = CGRectMake(0,
                                             0,
                                             self.bottomView.frame.size.width,
                                             100);
    
    self.segmentedControl.selectedSegmentIndex = [PubicVariable dateMode];
    self.segmentedControl.height = 50;
    //self.segmentedControl.delegate = self;
    //self.segmentedControl.selectedSegmentIndex = 1;
    self.segmentedControl.showsCount = NO;
    self.segmentedControl.font = [UIFont wawaFontForLabel];
    self.segmentedControl.bouncySelectionIndicator = YES;
    self.segmentedControl.tintColor = EBBlue;
    self.segmentedControl.hairlineColor = EBBlue;
    self.segmentedControl.autoAdjustSelectionIndicatorWidth = NO;
    self.segmentedControl.adjustsFontSizeToFitWidth = YES;
            //        _control.height = 120.0f;
            //        _control.width = 300.0f;
            //        _control.showsGroupingSeparators = YES;
            //        _control.inverseTitles = YES;
            //        _control.backgroundColor = [UIColor lightGrayColor];
            //        _control.tintColor = [UIColor purpleColor];
            //        _control.hairlineColor = [UIColor purpleColor];
            //        _control.showsCount = NO;
            //        _control.autoAdjustSelectionIndicatorWidth = NO;
            //        _control.selectionIndicatorHeight = _control.intrinsicContentSize.height;
            //        _control.adjustsFontSizeToFitWidth = YES;

    [self.segmentedControl addTarget:self
                              action:@selector(segmentSelected)
                    forControlEvents:UIControlEventValueChanged];
    
    [self.bottomView addSubview:self.segmentedControl];

    /*
    // Add desired targets/actions
    [self.segmentedControl
     addTarget:self
     action:@selector(segmentSelected)
     forControlEvents:UIControlEventValueChanged];
    
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
     */
    //self.navigationItem.titleView = self.segmentedControl;
}

//-(void)setupButtons
//{
//    [self.addButton setStyle:[PNFreshGreen colorWithAlphaComponent:0.5f] andBottomColor:PNFreshGreen];
//    [self.addButton setLabelFont:[UIFont fontWithName:@"Trebuchet MS" size:50]];
//    [self.sumAddedMoneyButton setStyle:[PNFreshGreen colorWithAlphaComponent:0.5f] andBottomColor:PNFreshGreen];
//    [self.sumAddedMoneyButton setLabelFont:[UIFont fontWithName:@"Trebuchet MS" size:20]];
//    
//    [self.reduceButton setStyle:[PNRed colorWithAlphaComponent:0.5f] andBottomColor:PNRed];
//    [self.reduceButton setLabelFont:[UIFont fontWithName:@"Trebuchet MS" size:50]];
//    [self.sumReduceMoneyButton setStyle:[PNRed colorWithAlphaComponent:0.5f] andBottomColor:PNRed];
//    [self.sumReduceMoneyButton setLabelFont:[UIFont fontWithName:@"Trebuchet MS" size:20]];
//    
//    [self.sumMoneyButton setStyle:[PNTwitterColor colorWithAlphaComponent:0.5f] andBottomColor:PNTwitterColor];
//    [self.sumMoneyButton setLabelFont:[UIFont fontWithName:@"Trebuchet MS" size:20]];
//    
//}

-(NSArray *)functineButtons
{
    return @[self.addButton,
             self.reduceButton,
             self.sumAddedMoneyButton,
             self.sumReduceMoneyButton,
             self.sumMoneyButton];
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
        //[self.lineChartLabel removeFromSuperview];
        [self.lineChart removeFromSuperview];
    }
    //self.lineChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 30)];
    
    NSString *string = @"● 收入  ● 支出";
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithString:string
                                            attributes:@{NSForegroundColorAttributeName: EBBlue}];
    
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
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 20.0, SCREEN_WIDTH, 155.0)];
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
    
    
    //[self.view addSubview:self.lineChartLabel];
    [self.view addSubview:self.lineChart];
    float sumAddedMoney = [PubicVariable sumMoneyWithIncomeMode:isIncomeYes withDateMode:[PubicVariable dateMode] inManagedObjectContext:self.managedObjectContext];
    float sumReduceMoney = [PubicVariable sumMoneyWithIncomeMode:isIncomeNo withDateMode:[PubicVariable dateMode] inManagedObjectContext:self.managedObjectContext];
    float sumMoney = [PubicVariable sumMoneyWithIncomeMode:isIncomeNil withDateMode:[PubicVariable dateMode] inManagedObjectContext:self.managedObjectContext];
    
    [self.sumAddedMoneyButton setTitle:[NSString stringWithFormat:@" ￥ %.0f ",sumAddedMoney] forState:UIControlStateNormal];
    [self.sumReduceMoneyButton setTitle:[NSString stringWithFormat:@" ￥ %.0f ",fabs(sumReduceMoney)] forState:UIControlStateNormal];
    [self.sumMoneyButton setTitle:[NSString stringWithFormat:@" ￥ %.0f ",sumMoney] forState:UIControlStateNormal];
    

    
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

#pragma mark - Navigation Method


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    [segue passManagedObjectContextIfNeeded];
    
    if ([segue.identifier isEqualToString:@"incomeSegue"]) {
        
        [self prepareForSegue:segue isIncome:YES sender:sender];
        
    }else if([segue.identifier isEqualToString:@"expenseSegue"]) {
        
        [self prepareForSegue:segue isIncome:NO sender:sender];

    }else if([segue.identifier isEqualToString:@"sumIncomeSegue"]) {
        
        [self prepareForSegue:segue withIncomeMode:isIncomeYes];
        
    }else if([segue.identifier isEqualToString:@"sumExpenseSegue"]) {
        
        [self prepareForSegue:segue withIncomeMode:isIncomeNo];
        
    }else if([segue.identifier isEqualToString:@"sumSegue"]) {
        
        [self prepareForSegue:segue withIncomeMode:isIncomeNil];
        
    }
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue isIncome:(BOOL)isIncome sender:(id)sender
{
    
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = segue.destinationViewController;
        if ([navigationController.viewControllers.firstObject isKindOfClass:[BillDetailCVC class]]) {
            BillDetailCVC *myCollectionViewController = navigationController.viewControllers.firstObject;
            myCollectionViewController.isIncome = isIncome;
            // Show Bill Detail. Configure transition.
            if ([sender isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)sender;
                CGPoint point = [button.superview
                                      convertPoint:button.center
                                      toView:nil];
                self.customPresentAnimationController.startPoint = point;

                UIButton *sumButton = [sender isEqual:self.addButton] ? self.sumAddedMoneyButton : self.sumReduceMoneyButton;
                CGPoint sumButtonCenter = [sumButton.superview convertPoint:sumButton.center toView:nil];
                self.customDismissAnimationController.operatorPoint = point;
                self.customDismissAnimationController.sumPoint = sumButtonCenter;
                self.customDismissAnimationController.customDismissAnimationControllerEndPointType = CustomDismissAnimationControllerEndPointTypeOperator;
                navigationController.transitioningDelegate = self;

            }
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue withIncomeMode:(NSInteger)incomeMode
{
    if ([segue.destinationViewController isKindOfClass:[BillCDTVC class]]) {
        BillCDTVC *billCoreDataTableViewController = segue.destinationViewController;
        [self setFetchedResultsControllerWithbillCoreDataTableViewController:billCoreDataTableViewController  withIncomeMode:incomeMode];
        billCoreDataTableViewController.title = [self.segmentedControl titleForSegmentAtIndex: self.segmentedControl.selectedSegmentIndex];
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return self.customPresentAnimationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.customDismissAnimationController;
}

#pragma mark - NSFetched Results Controller Delegate Method

-(void)setFetchedResultsControllerWithbillCoreDataTableViewController:(BillCDTVC *)billCoreDataTableViewController
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
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sectionNameKeyPath ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    NSPredicate *incomePredicate = [NSPredicate predicateWithIncomeMode:incomeMode];
    NSPredicate *datePredicate = [NSPredicate predicateWithbDateMode:[PubicVariable dateMode]];
    request.predicate = [incomePredicate predicateCombineWithPredicate:datePredicate];
    billCoreDataTableViewController.isIncomeMode = incomeMode;
    billCoreDataTableViewController.fetchedResultsController = [[NSFetchedResultsController alloc]
                                                                initWithFetchRequest:request
                                                                managedObjectContext:self.managedObjectContext
                                                                sectionNameKeyPath:nil
                                                                cacheName:nil];
}


#pragma mark - Property Setter And Getter Method


-(ChartDate *)chartDate
{
    if (!_chartDate) {
        _chartDate = [[ChartDate alloc] initWithManagedObjectContext:self.managedObjectContext];
    }
    return _chartDate;
}

- (CustomPresentAnimationController *)customPresentAnimationController {
    if (!_customPresentAnimationController) {
        _customPresentAnimationController = [[CustomPresentAnimationController alloc]init];
    }
    return _customPresentAnimationController;
}

- (CustomDismissAnimationController *)customDismissAnimationController {
    if (!_customDismissAnimationController) {
        _customDismissAnimationController = [[CustomDismissAnimationController alloc]init];
    }
    return _customDismissAnimationController;
}



@end