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
#import "LJChartView.h"
#import "NSNumber+PrivateExtension.h"
#import "TextProgressMRPOV.h"
#import "UIView+Extension.h"
#import "NSDate+Extension.h"
#import "UIColor+Extension.h"
#import "RoundedButton.h"
#import "HighlightImageButton.h"


@interface HomeViewController () <DZNSegmentedControlDelegate,LJChartViewDataSource>

@property (weak, nonatomic) IBOutlet HighlightImageButton *addButton;
@property (weak, nonatomic) IBOutlet HighlightImageButton *reduceButton;
@property (weak, nonatomic) IBOutlet RoundedButton *sumAddedMoneyButton;
@property (weak, nonatomic) IBOutlet RoundedButton *sumReduceMoneyButton;
@property (weak, nonatomic) IBOutlet RoundedButton *sumMoneyButton;


@property (strong, nonatomic) UILabel *lineChartLabel;
@property (strong, nonatomic) PNLineChart *lineChart;
@property (strong, nonatomic) DZNSegmentedControl *segmentedControl;
@property (strong, nonatomic) ChartDate *chartDate;


@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) CustomPresentAnimationController *customPresentAnimationController;
@property (nonatomic, strong) CustomDismissAnimationController *customDismissAnimationController;

@property (nonatomic) BOOL shouldUpdateUI;


//@property (nonatomic, strong) NSArray *data; // Test

@property (weak, nonatomic) IBOutlet LJChartView *chartView;

//@property (strong, nonatomic) UISwipeGestureRecognizer *nextPageSwipeGestureRecognizer;
//@property (strong, nonatomic) NSFetchedResultsController *chartFRC;
//@property (nonatomic, strong) TextProgressMRPOV *progressView;


@end

@implementation HomeViewController

#pragma mark - View Controller Life Cycle Method

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showPasscodeIfNeeded];

	// Do any additional setup after loading the view, typically from a nib.
    [self setupSegmentedControl];
    [self updateUI];
    [self setupMenuButton];
//    [self configureButton];
//    [self setupBackgroundImage];
    [self registerNotifications];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self refreshChartView];
    [self.navigationController applyDefualtStyle:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.shouldUpdateUI){
        [self updateUI];
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




#pragma mark - Navigation Method

- (void)registerNotifications {
    //    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleManagedObjectContextObjectsDidChangeNotification)
                                                 name:NSManagedObjectContextObjectsDidChangeNotification
                                               object:self.managedObjectContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePersistentStoreCoordinatorStoresDidChangeNotification)
                                                 name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                                               object:self.managedObjectContext.persistentStoreCoordinator];
}


- (void)handleManagedObjectContextObjectsDidChangeNotification {
    [self.managedObjectContext performBlock:^{
        if (self.view.window) {
            [self updateUI];
        } else {
            self.shouldUpdateUI = YES;
        }
    }];

}

- (void)handlePersistentStoreCoordinatorStoresDidChangeNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.view.window) {
            [self updateUI];
        } else {
            self.shouldUpdateUI = YES;
        }
    });
    
}





#pragma mark - SetUp Method


-(void)setupSegmentedControl
{
    
    //"本周", "本月", "总体"
    self.segmentedControl = [[DZNSegmentedControl alloc]
                             initWithItems:@[@"周", @"月", @"年"]];
    
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
    [self.segmentedControl addTarget:self
                              action:@selector(segmentSelected)
                    forControlEvents:UIControlEventValueChanged];
    
    [self.bottomView addSubview:self.segmentedControl];

}

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
    self.chartDate.pageIndex = 0;
    [PubicVariable setDateMode:self.segmentedControl.selectedSegmentIndex];
    [self updateUI];
}


-(void)updateUI
{
    [self refreshChartView];
    [self updateButtom];
    self.shouldUpdateUI = NO;

}

- (void)updateButtom {
    float sumAddedMoney = [PubicVariable sumMoneyWithIncomeMode:isIncomeYes
                                                   withDateMode:[PubicVariable dateMode]
                                                       withDate:self.chartDate.referenceDate
                                         inManagedObjectContext:self.managedObjectContext];
    
    float sumReduceMoney = [PubicVariable sumMoneyWithIncomeMode:isIncomeNo
                                                    withDateMode:[PubicVariable dateMode]
                                                        withDate:self.chartDate.referenceDate
                                          inManagedObjectContext:self.managedObjectContext];
    
    float sumMoney = [PubicVariable sumMoneyWithIncomeMode:isIncomeNil
                                              withDateMode:[PubicVariable dateMode]
                                                  withDate:self.chartDate.referenceDate
                                    inManagedObjectContext:self.managedObjectContext];
    
    //    [self.chartDate.referenceDate showDetail];
    [self.sumAddedMoneyButton setTitle:[NSString stringWithFormat:@"%.0f ",sumAddedMoney] forState:UIControlStateNormal];
    [self.sumReduceMoneyButton setTitle:[NSString stringWithFormat:@"%.0f ",fabs(sumReduceMoney)] forState:UIControlStateNormal];
    [self.sumMoneyButton setTitle:[NSString stringWithFormat:@"%.0f ",sumMoney] forState:UIControlStateNormal];
    
}

//
//- (void)configureButton {
//    NSArray *buttons = @[self.sumAddedMoneyButton,
//                         self.sumReduceMoneyButton,
//                         self.sumMoneyButton];
//    [buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
//        button.layer.cornerRadius = button.bounds.size.height * 0.5 - 2;
//        button.layer.borderWidth = button.bounds.size.height * 3.5/64.0;
//        button.layer.borderColor = [UIColor globalTintColor].CGColor;
//    }];
//    
//}

- (void)refreshChartView {
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionCrossDissolve;
    [self refreshChartViewUseAnimationOptions:options];
}
- (IBAction)previousPage:(UISwipeGestureRecognizer *)sender {
    self.chartDate.pageIndex++;
    [self updateButtom];
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionCurlUp;
    [self refreshChartViewUseAnimationOptions:options];
}

- (IBAction)nextPage:(UISwipeGestureRecognizer *)sender {
    self.chartDate.pageIndex--;
    [self updateButtom];
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionCurlDown;
    [self refreshChartViewUseAnimationOptions:options];
}

- (IBAction)changePage:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        // handling code
        UIView *view = sender.view;
        CGPoint touchPoint =
        [sender locationOfTouch:0
                         inView:view];
        CGFloat persentWidthForTouch = 0.2;
        if (touchPoint.x < view.bounds.size.width * persentWidthForTouch ) {
            [self previousPage:nil];
        } else if (touchPoint.x > view.bounds.size.width * (1 - persentWidthForTouch) ) {
            [self nextPage:nil];
        }
        NSLog(@"Touch : %@",
              NSStringFromCGPoint(touchPoint));
        
    }
}


- (void)refreshChartViewUseAnimationOptions:(UIViewAnimationOptions)options {
    __weak HomeViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf.chartDate refreshData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView transitionWithView:self.chartView
                              duration:0.5
                               options:options
                            animations:^{
                                self.chartView.attributedTitle = self.chartDate.attributedTitle;
                                self.chartView.attributedSubTitle = self.chartDate.attributedSubTitle;
                                [self.chartView setNeedsDisplay];
                            } completion:nil];
        });
    });
}


- (void)showPasscodeIfNeeded {
    LTHPasscodeViewController *sharedLTHPasscodeViewController = [LTHPasscodeViewController sharedUser];
    sharedLTHPasscodeViewController.navigationBarTintColor = EBBlue;
    sharedLTHPasscodeViewController.navigationTintColor = [UIColor whiteColor];
    sharedLTHPasscodeViewController.labelFont = [UIFont wawaFontForLabel];
    sharedLTHPasscodeViewController.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                                             NSFontAttributeName : [UIFont wawaFontForNavigationTitle]};
    sharedLTHPasscodeViewController.title = @"简单记账";
    sharedLTHPasscodeViewController.enterPasscodeString = @"请输入密码";
    sharedLTHPasscodeViewController.enterNewPasscodeString = @"请输入新密码";
    sharedLTHPasscodeViewController.enablePasscodeString = @"设置密码";
    sharedLTHPasscodeViewController.changePasscodeString = @"修改密码";
    sharedLTHPasscodeViewController.turnOffPasscodeString = @"关闭密码";
    sharedLTHPasscodeViewController.reenterPasscodeString = @"请再次输入密码";
    sharedLTHPasscodeViewController.reenterNewPasscodeString = @"请再次输入新密码";
    
    if ([LTHPasscodeViewController doesPasscodeExist] &&
        [LTHPasscodeViewController didPasscodeTimerEnd]) {
        [sharedLTHPasscodeViewController showLockScreenWithAnimation:NO
                                                          withLogout:YES
                                                      andLogoutTitle:nil];
    }
}
//-(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex andPointIndex:(NSInteger)pointIndex{
//    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
//}
//
//-(void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
//    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
//}
//
//- (void)userClickedOnBarCharIndex:(NSInteger)barIndex
//{
//    
//    NSLog(@"Click on bar %@", @(barIndex));
//    
//}

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
        NSString *incomeString;
        switch (incomeMode) {
            case isIncomeYes:{
                incomeString = @"-收入";
                break;
            }
            case isIncomeNo:{
                incomeString = @"-支出";
                break;
            }
            default:{
                incomeString = @"";
                break;
            }
        }
        billCoreDataTableViewController.title = [NSString
                                                 stringWithFormat:@"%@%@",
                                                 self.chartDate.attributedTitle.string,
                                                 incomeString];
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

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bill"];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    NSPredicate *incomePredicate = [NSPredicate predicateWithIncomeMode:incomeMode];
    NSPredicate *datePredicate = [NSPredicate predicateWithbDateMode:[PubicVariable dateMode] withDate:self.chartDate.referenceDate];
    request.predicate = [NSPredicate predicateByCombinePredicate:incomePredicate withPredicate:datePredicate];
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
//
//- (UISwipeGestureRecognizer *)nextPageSwipeGestureRecognizer {
//    if (!_nextPageSwipeGestureRecognizer) {
//        _nextPageSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]
//                                           initWithTarget:self
//                                           action:@selector(nextPage)];
//        _nextPageSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    }
//    return _nextPageSwipeGestureRecognizer;
//}

//- (TextProgressMRPOV *)progressView {
//    if (!_progressView) {
//        _progressView = [TextProgressMRPOV defaultTextProgressMRPOV];
//        [self.chartView addSubview:_progressView];
//    }
//    return _progressView;
//}


#pragma mark - LJChart View Data Source



- (void)setChartView:(LJChartView *)chartView
{
    _chartView = chartView;
    _chartView.backgroundImage = [UIImage imageNamed:@"BackGround"];
    _chartView.dataSource = self;
}

- (NSInteger)numberOfLinesInChartView:(LJChartView *)chartView{
    
    return 2;
}

- (NSInteger)numberOfPointsOnLineInChartView:(LJChartView *)chartView{
    
    return self.chartDate.expenseDataArray.count;
}

- (float)chartView:(LJChartView *)chartView valueForPointAtIndexPath:(NSIndexPath *)indexPath{
    
    float reslut = 0;
    NSArray *lineValues = (indexPath.section == 0) ? self.chartDate.incomeDataArray : self.chartDate.expenseDataArray;
    NSNumber *number = (NSNumber *)[lineValues objectAtIndex:indexPath.item];
    reslut = number.floatValue;
    
    return reslut;
}

- (UIColor *)chartView:(LJChartView *)chartView colorOfLine:(NSInteger)line{
    if (line == 0) {
        return EBBlue;
    }else{
        return [UIColor redColor];
    }
}



//- (NSArray *)data{
//    return @[
//             @[@300.6,@1000,@760,@500,@1300,@200],
//             @[@200,@1300,@500,@550.33,@800,@300]
//             ];
//}

@end