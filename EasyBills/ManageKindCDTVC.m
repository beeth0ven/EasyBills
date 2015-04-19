//
//  ManageKindCDTVC.m
//  EasyBills
//
//  Created by luojie on 4/19/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "ManageKindCDTVC.h"
#import "PubicVariable+FetchRequest.h"

@interface ManageKindCDTVC ()

@property (strong ,nonatomic) NSNumber *total;
@property (strong, nonatomic) NSArray *filters;


@end

@implementation ManageKindCDTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setupFetchedResultsController];
    [self resetFetchedResultsController];
}


- (void)setupFetchedResultsController {
    if (!self.fetchedResultsController) {
        
//        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kind"];
//        request.sortDescriptors = @[[NSSortDescriptor
//                                     sortDescriptorWithKey:@"sumMoney"
//                                     ascending: YES]
//                                    //                                [NSSortDescriptor sortDescriptorWithKey:@"isIncome" ascending:NO],
//                                    //                                [NSSortDescriptor sortDescriptorWithKey:@"visiteTime" ascending:NO]
//                                    ];
//        
//        request.predicate = [PubicVariable predicateWithIncomeMode:isIncomeYes];
//        
//        self.fetchedResultsController = [[NSFetchedResultsController alloc]
//                                         initWithFetchRequest:request
//                                         managedObjectContext:[PubicVariable managedObjectContext]
//                                         sectionNameKeyPath:nil
//                                         cacheName:nil];
        
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kind"];
        request.sortDescriptors = @[
//                                    [NSSortDescriptor sortDescriptorWithKey:@"isIncome" ascending:NO],
                                    [NSSortDescriptor sortDescriptorWithKey:@"visiteTime" ascending:YES]];
        request.predicate = [PubicVariable predicateWithIncomeMode:isIncomeNil];
        
        NSError *error;
        NSArray *matches = [[PubicVariable managedObjectContext]
                            executeFetchRequest:request error:&error];
        NSLog(@"matches : %i",matches.count);
        
        
//        self.fetchedResultsController =
        NSFetchedResultsController *frc =
        [[NSFetchedResultsController alloc]
                                         initWithFetchRequest:request
                                         managedObjectContext:[PubicVariable managedObjectContext]
                                         sectionNameKeyPath:nil
                                         cacheName:nil];
        NSLog(@"frc objexts: %i",frc.fetchedObjects.count);
        NSLog(@"frc sections: %i",frc.sections.count);
//        NSLog(@"frc rows: %i",frc.sections.firstObject.);


    }
}

- (void)resetFetchedResultsController
{
    
    
    self.total = [NSNumber numberWithFloat:
                  [PubicVariable sumMoneyWithIncomeMode:isIncomeNo
                                           withDateMode:all]];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kind"];
    request.sortDescriptors = @[[NSSortDescriptor
                                 sortDescriptorWithKey:@"sumMoney"
                                 ascending:isIncomeNo == isIncomeYes ? NO : YES]
                                //                                [NSSortDescriptor sortDescriptorWithKey:@"isIncome" ascending:NO],
                                //                                [NSSortDescriptor sortDescriptorWithKey:@"visiteTime" ascending:NO]
                                ];
    
    request.predicate = [PubicVariable predicateWithIncomeMode:isIncomeNo];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:[PubicVariable managedObjectContext]
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
    
    NSLog(@"frc objexts: %i",self.fetchedResultsController.fetchedObjects.count);
    NSLog(@"frc sections: %i",self.fetchedResultsController.sections.count);
    //    [self enumerateSumMoney];
    
    //    [self updataHeaderView];
    
    
    
}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *cellIdentifier = @"kind";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    Kind *kind = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@  ",[kind.name description]];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  ",
//                                 (kind.isIncome.boolValue ?
//                                 @"收入" :
//                                 @"支出")];
//
//    return cell;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
