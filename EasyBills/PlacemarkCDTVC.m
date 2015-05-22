//
//  PlacemarkCDTVC.m
//  EasyBills
//
//  Created by luojie on 4/10/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "PlacemarkCDTVC.h"
#import "PubicVariable+FetchRequest.h"

@interface PlacemarkCDTVC ()

@end

@implementation PlacemarkCDTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Place";
    [self setupFetchedResultsController];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self isDataSourceEmpty]) {
        NSLog(@"isDataSourceEmpty");

        return 1;

        

        
    } else {
        NSLog(@"isNotDataSourceEmpty");

        return [super numberOfSectionsInTableView:tableView];
        
        


    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isDataSourceEmpty]) {
        return 1;
        
        
        
        
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
        
        
        
        
    }
}


-(UITableViewCell *)        tableView:(UITableView *)tableView
                cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    if ([self isDataSourceEmpty]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell"];
        return cell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"placemarkCell"];
        Plackmark *placemark = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        UILabel *placeLabel = (UILabel *)[cell viewWithTag:1];
        UILabel *countLabel = (UILabel *)[cell viewWithTag:2];
        
        placeLabel.text = placemark.name;
        countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)placemark.bills.count];
        
        //    cell.textLabel.text = placemark.name;
        //    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",placemark.bills.count];

    }
    return cell;

}


- (void)setupFetchedResultsController
{
    
    if (!self.fetchedResultsController) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Plackmark"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"bills.@count > 0"];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]
                                                                initWithFetchRequest:request
                                                                managedObjectContext:self.managedObjectContext
                                                                sectionNameKeyPath:nil
                                                                cacheName:nil];
        
        self.fetchedResultsController = fetchedResultsController;
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:^{
        if (![self isDataSourceEmpty]) {
            self.selectedPlacemark = [self.fetchedResultsController objectAtIndexPath:indexPath];
        }
    }];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];


}

- (CGSize)preferredContentSize {
    if (self.presentingViewController) {
        CGSize size = [self.tableView sizeThatFits:self.presentingViewController.view.bounds.size];
        return size;
//        CGSizeMake(size.width / 2,
//                          size.height + 44 * 4);
    }else{
        return [super preferredContentSize];
    }
}

- (BOOL)isDataSourceEmpty {
    NSLog(@"%lu",(unsigned long)self.fetchedResultsController.fetchedObjects.count);
    return (!self.fetchedResultsController
            || self.fetchedResultsController.fetchedObjects.count == 0);
}


@end
