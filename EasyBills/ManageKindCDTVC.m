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
#import "KindDetailCVC.h"
#import "UIStoryboardSegue+Extension.h"

@interface ManageKindCDTVC ()

@property (weak, nonatomic) IBOutlet UILabel *equalLabel;
@property (weak, nonatomic) IBOutlet UILabel *billCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *kindCountLabel;


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

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    if (self.shouldRelaodData){
//        [self.tableView reloadData];
//        self.shouldRelaodData = NO;
//    }
//}


#pragma mark - UITable View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kind"];
    Kind *kind = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configCell:cell WithKind:kind];
    return cell;
}

-(void)configCell:(UITableViewCell *)cell WithKind:(Kind *)kind {
    
    UILabel *nameLabel =  (UILabel *)[cell viewWithTag:1];
    UILabel *countLabel =  (UILabel *)[cell viewWithTag:2];
    UILabel *isIncomeLabel =  (UILabel *)[cell viewWithTag:3];
    
    nameLabel.text = [NSString stringWithFormat:@"%@  ",(kind.name.length > 0) ? kind.name : @"未命名"];
    countLabel.text = [NSString stringWithFormat:@" 共%lu笔   ",
                       (unsigned long)kind.bills.count];
    isIncomeLabel.text = [NSString stringWithFormat:@" %@ ",kind.isIncomeDescription];
    


    nameLabel.backgroundColor = kind.color;
    isIncomeLabel.backgroundColor = kind.isIncome.boolValue ? EBBlue : PNRed;

//    [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
////     cell.textLabel.backgroundColor];
//    [cell.detailTextLabel setHighlightedTextColor:[UIColor whiteColor]];
////     cell.detailTextLabel.backgroundColor];

}

- (CGFloat)     tableView:(UITableView *)tableView
  heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 60.0f;
}

#pragma mark - UITable View Delegate
- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showKindDetail" sender:cell];

    self.shouldRelaodData = YES;
//    [self.tableView
//     reloadRowsAtIndexPaths:@[indexPath]
//     withRowAnimation:UITableViewRowAnimationAutomatic];
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
    NSNumber *count = [self.fetchedResultsController.fetchedObjects
                     valueForKeyPath:@"@sum.bills.@count"];
    
    self.billCountLabel.text = [NSString stringWithFormat:@" 共%lu笔   ",
                          count.integerValue];
    
    self.kindCountLabel.text = [NSString stringWithFormat:@" 共%lu种   ",
                            (unsigned long)self.fetchedResultsController.fetchedObjects.count];
    
    self.equalLabel.font = [self.equalLabel.font fontWithSize:25];
    
}

- (void)setupFetchedResultsController {
    if (!self.fetchedResultsController) {
        NSFetchRequest *request = [[NSFetchRequest alloc]
                                   initWithEntityName:@"Kind"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"isIncome" ascending:YES],
                                    [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES]];
        request.predicate = nil;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                         initWithFetchRequest:request
                                         managedObjectContext:self.managedObjectContext
                                         sectionNameKeyPath:nil
                                         cacheName:nil];
        
    }
    [self upadateFootView];
}
#pragma mark - IBAction Method

- (IBAction)addKind:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"showKindDetail" sender:sender];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [segue passManagedObjectContextIfNeeded];
    
    if ([segue.identifier isEqualToString:@"showKindDetail"]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navigationController = segue.destinationViewController;
                if ([navigationController.topViewController isKindOfClass:[KindDetailCVC class]]) {
                    KindDetailCVC *kindDetailCVC = (KindDetailCVC *)navigationController.topViewController;
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
                    Kind *kind = [self.fetchedResultsController objectAtIndexPath:indexPath];
                    kindDetailCVC.kind = kind;
                    NSLog(@"showKindDetail");
                }
            }
        }
       
    }
    
}


@end
