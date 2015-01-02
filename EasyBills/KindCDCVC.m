//
//  KindCDCVC.m
//  EasyBills
//
//  Created by 罗 杰 on 11/9/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "KindCDCVC.h"
#import "PubicVariable.h"
#import "KIndCollectionViewCell.h"
#import "Kind.h"



@interface KindCDCVC ()

@end

@implementation KindCDCVC



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"类别";
    if (!self.fetchedResultsController) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kind"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"isIncome" ascending:NO],[NSSortDescriptor sortDescriptorWithKey:@"visiteTime" ascending:NO]];
        request.predicate = nil;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[PubicVariable managedObjectContext]
                                                                              sectionNameKeyPath:@"isIncome"
                                                                                       cacheName:nil];
    }
}
/*
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kindCell" forIndexPath:indexPath];
    Kind *kind = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([cell isKindOfClass:[KindCollectionViewCell class]]) {
        [self configCell:(KindCollectionViewCell *)cell WithKind:kind];
    }
    return cell;
}



-(void)configCell:(KIndCollectionViewCell *)cell WithKind:(Kind *)kind
{
    cell.textLabel.text = [kind.name description];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
