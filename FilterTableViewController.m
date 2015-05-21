//
//  FilterTableViewController.m
//  PopToFilter
//
//  Created by luojie on 3/29/15.
//  Copyright (c) 2015 luojie. All rights reserved.
//

#import "FilterTableViewController.h"
#import "Filter.h"

@interface FilterTableViewController ()


@property (strong, nonatomic) NSIndexPath *selectedFilterIndexPath;

@end

@implementation FilterTableViewController


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    Filter *filter = [self selectedFilter];
    return self.filters.count + filter.filterTypes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    Filter *selectFilter = [self selectedFilter];
    if ([self isTypeRowAtIndexPath:indexPath]) {
        //The row is type row.
        NSInteger typeRow = indexPath.row - self.selectedFilterIndexPath.row -1;
        NSString *typeString =
        [selectFilter.filterTypes objectAtIndex:typeRow];
        cell = [tableView dequeueReusableCellWithIdentifier:@"filterTypeCell"];
        cell.textLabel.text = typeString;
        cell.textLabel.textColor = typeRow == selectFilter.selectIndex ? EBBlue : [UIColor blackColor];

        cell.accessoryType = typeRow == selectFilter.selectIndex ?
                                        UITableViewCellAccessoryCheckmark :
                                        UITableViewCellAccessoryNone;
        cell.indentationLevel = 1;
//        typeRow == 0 ? 1 : 2;
        return cell;
    }
    
    
    //The row is filter row.
    NSIndexPath *filterIndexPath = [indexPath copy];
    if ([self isMoreThanTypeRowAtIndexPath:indexPath]) {
        //The row filter row which is more than type row.
        NSInteger row = indexPath.row - selectFilter.filterTypes.count;
        filterIndexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
    }
    Filter *filter = [self.filters objectAtIndex:filterIndexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:@"filterCell"];
    if (cell != nil) {
        BOOL isCurrentSelectFilter = [self isSelectFilterRowAtIndexPath:indexPath];
        cell.textLabel.text = filter.name;
        cell.detailTextLabel.text = [filter.filterTypes objectAtIndex:filter.selectIndex];
        cell.detailTextLabel.textColor = filter.selectIndex == 0 ? EBBackGround : EBBlue;
        cell.accessoryType =    isCurrentSelectFilter ?
                                UITableViewCellAccessoryCheckmark :
                                UITableViewCellAccessoryDisclosureIndicator;
        
        NSString *imageName =   isCurrentSelectFilter ?
                                @"BottonIcon" :
                                @"RightIcon";

        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc]
                                  initWithFrame:CGRectMake(0,
                                                           0,
                                                           14,
                                                           14)];
        imageView.tintColor = isCurrentSelectFilter ? EBBlue : EBBackGround;
        imageView.image = image;
        cell.accessoryView = imageView;
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Filter *selectFilter = [self selectedFilter];
    if ([self isTypeRowAtIndexPath:indexPath]) {
        //The selected row is type row.
        NSInteger typeRow = indexPath.row - self.selectedFilterIndexPath.row -1;
        selectFilter.selectIndex = typeRow;
        [self reloadSelectFilterRows];
        return;
    }
    
    //The selected row is filter row.
    NSIndexPath *filterIndexPath = [indexPath copy];
    if ([self isSelectFilterRowAtIndexPath:indexPath]) {
        //The selected row is current selected filter row .
        filterIndexPath = nil;
        
    }else if ([self isMoreThanTypeRowAtIndexPath:indexPath]) {
        //The selected row is more than type row.
        NSInteger row = indexPath.row - selectFilter.filterTypes.count;
        filterIndexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectedFilterIndexPath) {
        UITableViewCell *selectedFilterCell = [tableView cellForRowAtIndexPath:self.selectedFilterIndexPath];
        NSString *imageName = @"RightIcon";
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc]
                                  initWithFrame:CGRectMake(0,
                                                           0,
                                                           14,
                                                           14)];
        imageView.tintColor = EBBackGround;

        imageView.image = image;
        selectedFilterCell.accessoryView = imageView;
//        selectedFilterCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if ([self isSelectFilterRowAtIndexPath:indexPath] == NO) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *imageName = @"BottonIcon";
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc]
                                  initWithFrame:CGRectMake(0,
                                                           0,
                                                           14,
                                                           14)];
        imageView.tintColor = EBBlue;
        imageView.image = image;
        cell.accessoryView = imageView;
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    self.selectedFilterIndexPath = filterIndexPath;

}


- (BOOL)isLessThanTypeRowAtIndexPath:(NSIndexPath *)indexPath {
    Filter *selectFilter = [self selectedFilter];
    return  (selectFilter != nil &&
             indexPath.row <= self.selectedFilterIndexPath.row);
}

- (BOOL)isTypeRowAtIndexPath:(NSIndexPath *)indexPath {
    Filter *selectFilter = [self selectedFilter];
    return  (selectFilter != nil &&
             self.selectedFilterIndexPath.row < indexPath.row &&
             indexPath.row <= self.selectedFilterIndexPath.row + selectFilter.filterTypes.count);
}

- (BOOL)isMoreThanTypeRowAtIndexPath:(NSIndexPath *)indexPath {
    Filter *selectFilter = [self selectedFilter];
    return (selectFilter != nil &&
            self.selectedFilterIndexPath.row + selectFilter.filterTypes.count < indexPath.row);
}

- (BOOL)isSelectFilterRowAtIndexPath:(NSIndexPath *)indexPath {
    Filter *selectFilter = [self selectedFilter];
    return  (selectFilter != nil &&
             [self.selectedFilterIndexPath compare: indexPath] == NSOrderedSame);
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString( @"Filter:", "");
}

//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"section"];
//    UIView *view = [[UIView alloc] initWithFrame:cell.frame];
//    [view addSubview: cell];
//    return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGSize)preferredContentSize {
    if (self.presentingViewController) {
        CGSize size = [self.tableView sizeThatFits:self.presentingViewController.view.bounds.size];
        return CGSizeMake( 200.0,
                          size.height + 44 * 4);
    }else{
        return [super preferredContentSize];
    }
}

//- (NSArray *)filters {
//    if (!_filters) {
//        Filter *timeFilter = [Filter filterWithType: LJFilterTime];
//        Filter *kindFilter = [Filter filterWithType: LJFilterKind];
//        _filters = @[timeFilter,kindFilter];
//    }
//    return _filters;
//}

- (Filter *)selectedFilter {
    Filter *result = nil;
    if (self.selectedFilterIndexPath != nil &&
        self.selectedFilterIndexPath.row < [[self filters] count]) {
        result = [self.filters objectAtIndex:self.selectedFilterIndexPath.row];
    }
    return result;
}

- (void) setSelectedFilterIndexPath:(NSIndexPath *)selectedFilterIndexPath {
    
    [self.tableView beginUpdates];
    
    if (_selectedFilterIndexPath != nil) {
        Filter *oldFilter =
        _selectedFilterIndexPath.row < self.filters.count ?
        [self.filters objectAtIndex:_selectedFilterIndexPath.row] :
        nil;
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSInteger row = _selectedFilterIndexPath.row + 1;
        [oldFilter.filterTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSInteger currentRow = row + idx;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentRow inSection:_selectedFilterIndexPath.section];
            [indexPaths addObject:indexPath];
        }];
        
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
    
    if (selectedFilterIndexPath != nil) {
        Filter *newFilter =
        selectedFilterIndexPath.row < self.filters.count ?
        [self.filters objectAtIndex:selectedFilterIndexPath.row] :
        nil;
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSInteger row = selectedFilterIndexPath.row + 1;
        [newFilter.filterTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSInteger currentRow = row + idx;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentRow inSection:selectedFilterIndexPath.section];
            [indexPaths addObject:indexPath];
        }];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
    
    _selectedFilterIndexPath = selectedFilterIndexPath;
    
    [self.tableView endUpdates];

}

- (void)reloadSelectFilterRows {
    if (self.selectedFilterIndexPath) {
        Filter *selectFilter = [self selectedFilter];
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSInteger count = 0;
        for (count = 0;
             count <= selectFilter.filterTypes.count;
             count++) {
            NSInteger row = self.selectedFilterIndexPath.row + count;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:self.selectedFilterIndexPath.section];
            [indexPaths addObject:indexPath];
        }
//        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView endUpdates];
        
    }
}




@end
