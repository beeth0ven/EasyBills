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
    self.title = @"地点";
    [self setupFetchedResultsController];
}

-(UITableViewCell *)        tableView:(UITableView *)tableView
                cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placemarkCell"];
    Plackmark *placemark = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UILabel *placeLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *countLabel = (UILabel *)[cell viewWithTag:2];
    
    placeLabel.text = placemark.name;
    countLabel.text = [NSString stringWithFormat:@"%i",placemark.bills.count];
    
//    cell.textLabel.text = placemark.name;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",placemark.bills.count];
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
                                                                managedObjectContext:[PubicVariable managedObjectContext]
                                                                sectionNameKeyPath:nil
                                                                cacheName:nil];
        
        self.fetchedResultsController = fetchedResultsController;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath");
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissViewControllerAnimated");
        self.selectedPlacemark = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"dismissViewControllerAnimated");

    }];
    NSLog(@"didSelectRowAtIndexPath");

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
