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
#import "BillTVCell.h"
#import "Kind+Create.h"
#import "SWRevealViewController.h"
#import "PubicVariable+FetchRequest.h"
#import "PNChart.h"
#import "PNCircleChart.h"
#import "DefaultStyleController.h"
#import "BillCDTVC.h"
#import "UIViewController+Extension.h"
#import "UINavigationController+Style.h"
#import "KindDetailCVC.h"

@interface KindCDTVC ()



@property (nonatomic) BOOL isIncome;
@property (strong ,nonatomic) NSNumber *total;

@end

@implementation KindCDTVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isIncome = [PubicVariable kindIsIncome];
    UIImage *image = [UIImage imageNamed:@"Account details BG"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.tableView.backgroundView = imageView;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupMenuButton];
    

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController applyDefualtStyle:YES];

}

-(void) updateUI
{
    self.total = [NSNumber numberWithFloat: [PubicVariable sumMoneyWithIncomeMode:self.isIncome withDateMode:all]];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kind"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"isIncome" ascending:NO],[NSSortDescriptor sortDescriptorWithKey:@"visiteTime" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"isIncome = %@",[NSNumber numberWithBool:self.isIncome]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[PubicVariable managedObjectContext]
                                                                          sectionNameKeyPath:@"isIncome"
                                                                                   cacheName:nil];
    
    
    [self updataHeaderView];
    

    
}


/*

- (void)setEditing:(BOOL)editing
          animated:(BOOL)animated{
    
    [super setEditing:editing
             animated:animated];
    
    UIBarButtonItem *rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    rightBarButtonItem = [[UIBarButtonItem alloc]
                          initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                          target:self
                          action:@selector(switchEditingMode:)];
    
}
*/


-(void)updataHeaderView
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"header"];
    [self configHeaderCell:cell];
    //reuse cell refer to http://stackoverflow.com/questions/12772197/what-is-the-meaning-of-the-no-index-path-for-table-cell-being-reused-message-i
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:cell.frame];
    [tableHeaderView addSubview:cell];
    self.tableView.tableHeaderView = tableHeaderView;
}


-(void) configHeaderCell:(UITableViewCell *)cell
{
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNRed],
                       [PNPieChartDataItem dataItemWithValue:20 color:PNBlue description:@"WWDC"],
                       [PNPieChartDataItem dataItemWithValue:40 color:PNGreen description:@"GOOL I/O"],
                       ];
    
    
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(80, 20.0, 160, 160) items:items];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:9];
    
    [cell addSubview:pieChart];
    [pieChart strokeChart];

}

- (IBAction)changeIncomeMode:(UISegmentedControl *)sender {
    self.isIncome = !sender.selectedSegmentIndex;
}

- (void)setIsIncome:(BOOL)isIncome
{
    _isIncome = isIncome;
    [PubicVariable setKindIsIncome:isIncome];
    [self updateUI];
    
}

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
    
    NSNumber *current =[NSNumber numberWithFloat: [PubicVariable sumMoneyWithKind:kind]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"  %@  ",[kind.name description]];

    PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 0, 30, 30) andTotal:self.total andCurrent:current andClockwise:(BOOL)YES andShadow:YES];
    circleChart.backgroundColor = [UIColor clearColor];
    circleChart.lineWidth = [NSNumber numberWithInt:4.0];
    [circleChart setStrokeColor:EBBlue];
    [circleChart strokeChart];
    cell.accessoryView = circleChart;
}

/*
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = [[[self.fetchedResultsController sections] objectAtIndex:section] name];
    return [sectionName isEqualToString:@"1"] ? @"收入" : @"支出";
}


*/

-(UIView *)     tableView:(UITableView *)tableView
   viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"section"];
    UISegmentedControl *segmentedControl = (UISegmentedControl *)[cell viewWithTag:1];
    segmentedControl.selectedSegmentIndex = !self.isIncome;
    
    /*
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNRed],
                       [PNPieChartDataItem dataItemWithValue:20 color:PNBlue description:@"WWDC"],
                       [PNPieChartDataItem dataItemWithValue:40 color:PNGreen description:@"GOOL I/O"],
                       ];
    
    
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(80, 20.0, 160, 160) items:items];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:9];
    
    [cell addSubview:pieChart];
    [pieChart strokeChart];
    */
    //fix bug when update section , section has no indexpath and will not be upadted;
    UIView *view = [[UIView alloc] initWithFrame:cell.frame];
    [view addSubview:cell];
    return view;
}

-(CGFloat)        tableView:(UITableView *)tableView
 heightForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"section"];
    return cell.frame.size.height;
}

- (void)        tableView:(UITableView *)tableView
       commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
        forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)        tableView:(UITableView *)tableView
       moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
              toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}
#pragma mark - Table view delegate

- (void)            tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *segueIdentifier = self.editing ? @"showKindDetail" : @"showKindDetail" ;
    [self performSegueWithIdentifier:segueIdentifier sender:cell];
    
}
//


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Kind *kind = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([sender isKindOfClass:[UITableViewCell class] ]) {
        
        if ([segue.identifier isEqualToString:@"showBillByKind"]) {
            if ([segue.destinationViewController isKindOfClass:[BillCDTVC class]]) {
                BillCDTVC *billCoreDataTableViewController = segue.destinationViewController;
                billCoreDataTableViewController.fetchedResultsController = [self fetchedResultsControlleWithKind:kind];
                billCoreDataTableViewController.title = kind.name;
                
            }
        } else if ([segue.identifier isEqualToString:@"showKindDetail"]) {
            if ([segue.destinationViewController isKindOfClass:[KindDetailCVC class]]) {
                KindDetailCVC *kindDetailCVC = segue.destinationViewController;
                kindDetailCVC.kind = kind;
            }
        }   /*  else if ([segue.identifier isEqualToString:@"showKindDetail"]) {
            if ([segue.destinationViewController isKindOfClass:[KindDetailTableViewController class]]) {
                KindDetailTableViewController *kindDetailTableViewController = segue.destinationViewController;
                
                NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
                Kind *kind = [self.fetchedResultsController objectAtIndexPath:indexPath];
                kindDetailTableViewController.kind = kind;
                
                NSLog(@"showKindDetail");
                
            }
        }
            */
    }
    
}

-(NSFetchedResultsController *)fetchedResultsControlleWithKind:(Kind *)kind
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Bill"];
    request.predicate = [NSPredicate predicateWithFormat:@"kind = %@" , kind];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]
                                                            initWithFetchRequest:request
                                                            managedObjectContext:[PubicVariable managedObjectContext]
                                                            sectionNameKeyPath:nil
                                                            cacheName:nil];
    return fetchedResultsController;
}
/*
*/

@end
