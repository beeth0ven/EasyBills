//
//  KindDetailCVC.m
//  EasyBills
//
//  Created by Beeth0ven on 2/27/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "KindDetailCVC.h"
#import "UINavigationController+Style.h"
#import "DefaultStyleController.h"
#import "ColorCenter.h"
#import "ColorCVCell.h"

@interface KindDetailCVC ()

@property (strong ,nonatomic) NSMutableArray *cellIdentifiers;


@end



@implementation KindDetailCVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self undoManager] beginUndoGrouping];
//    if (!self.bill)self.bill = [kind kindIsIncome:self.kind];
    self.isIncome = self.kind.isIncome.boolValue;
    self.title = self.isIncome ? @"收入": @"支出";
    
    NSArray *array = @[@"nameCell",
                       @"colorCell",
                       @"inputcolorCell",
                       @"deleteCell"];
    self.cellIdentifiers = [array mutableCopy];
    //self.datePickerIndexPath = [NSIndexPath indexPathForItem:3 inSection:0];
    
    // Do any additional setup after loading the view.
    //[self updateUI];
//    [self configBarButtonItem];
    [self registerNotifications];
    
    UIImage *image = [UIImage imageNamed:@"Account details BG"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.collectionView.backgroundView = imageView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController applyDefualtStyle:NO];
    [self registerAsObserver];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self unregisterForChangeNotification];
    
}




- (UICollectionView *)colorPickerCollectionView{
    
    UICollectionView *collectionView = nil;
    
    NSInteger index = [self.cellIdentifiers indexOfObject:@"inputcolorCell"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (cell != nil) {
        UIView *view = [cell viewWithTag:1];
        if ([view isKindOfClass:[UICollectionView class]]) {
            collectionView = (UICollectionView *)view;
        }
    }
    return collectionView;
}


#pragma mark - Notifications

- (void)registerAsObserver {
    /*
     Register 'inspector' to receive change notifications for the "openingBalance" property of
     the 'account' object and specify that both the old and new values of "openingBalance"
     should be provided in the observe… method.
     */
    [self.kind addObserver:self
                forKeyPath:@"colorID"
                   options:(NSKeyValueObservingOptionNew |
                            NSKeyValueObservingOptionOld)
                   context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqual:@"colorID"]) {
        
        NSInteger item = [self.cellIdentifiers indexOfObject:@"colorCell"];
        NSIndexPath *indexPath =[NSIndexPath indexPathForItem:item inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        
    }
    
}

- (void)unregisterForChangeNotification {
    [self.kind removeObserver:self
                   forKeyPath:@"colorID"];
}

-(void)registerNotifications
{
//    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];


    
    //keyboard notification ,scoll textfield to visible.
    
//    [center addObserver:self
//               selector:@selector(keyboardWasShown:)
//                   name:UIKeyboardDidShowNotification object:nil];
//    
//    [center addObserver:self
//               selector:@selector(keyboardWillBeHidden:)
//                   name:UIKeyboardWillHideNotification object:nil];
//    
    
}


//- (void)keyboardWasShown:(NSNotification*)aNotification
//{
//    NSDictionary *info = [aNotification userInfo];
//    CGSize kbSize =[[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    
//    UIEdgeInsets contentInsets = self.collectionView.contentInset;
//    contentInsets.bottom = kbSize.height;
//    
//    self.collectionView.contentInset = contentInsets;
//    self.collectionView.scrollIndicatorInsets = contentInsets;
//    
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= (kbSize.height);
//    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin)) {
//        CGRect rect = self.activeField.frame;
//        [self.collectionView scrollRectToVisible:rect animated:YES];
//    }
//}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = self.collectionView.contentInset;
    contentInsets.bottom = 0;
    [UIView animateWithDuration:0.4 animations:^{
        self.collectionView.contentInset = contentInsets;
        
    }];
    self.collectionView.scrollIndicatorInsets = contentInsets;
    
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UICollectionViewDataSource




-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == self.collectionView) {
        
        return 1;

    }else{
        
        return 1;

    }
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.collectionView) {
        
        return [[self cellIdentifiers] count];
        
    }else{
        //color pick collection view case here
        return [[ColorCenter colors] count];

    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    UICollectionViewCell *cell = nil;

    if (collectionView == self.collectionView) {
        
        cellIdentifier = [self cellIdentifiers][indexPath.item];
        
    }else{
        //color pick collection view case here
        cellIdentifier = @"colorUnitCell";
        
    }
    
    cell = [collectionView
            dequeueReusableCellWithReuseIdentifier:cellIdentifier
            forIndexPath:indexPath];
    
    [self configCell:cell
         atIndexPath:indexPath];
    
    return cell;

}

- (void)configCell:(UICollectionViewCell *)cell
       atIndexPath:(NSIndexPath *)indexPath{

    
    if ([cell.reuseIdentifier isEqualToString:@"colorCell"]){
        
        id view = [cell viewWithTag:1];
        if ([view isKindOfClass:[UIView class]]) {
            UIView *colorView = view;
            colorView.backgroundColor = self.kind.color;
        }
        
    }
    else if ([cell.reuseIdentifier isEqualToString:@"colorUnitCell"]) {
        //color pick collection view case here
        
        UIColor *color = (UIColor *)
        [[ColorCenter colors] objectAtIndex:indexPath.row];
        
        cell.layer.cornerRadius = cell.frame.size.width / 2;
        cell.backgroundColor = color;
        
        int colorIDIntValue = self.kind.colorID.intValue;
        cell.selected = (colorIDIntValue == indexPath.item);
        
    }
    
    
}

- (CGSize)          collectionView:(UICollectionView *)collectionView
                            layout:(UICollectionViewLayout*)collectionViewLayout
            sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    
    if (collectionView == self.collectionView) {
        
        NSInteger colorItem = [self.cellIdentifiers indexOfObject:@"inputcolorCell"];
        
        if(colorItem == indexPath.item){
            size = CGSizeMake(297, 235);
            
        }
        else{
            size =  CGSizeMake(297, 64);
            
        }
        return size;
        
    }else{
        //color pick collection view case here

        return CGSizeMake(50, 50);
        
    }
    

}



-(void)     collectionView:(UICollectionView *)collectionView
  didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == self.collectionView) {
        
        
//        [super collectionView:collectionView
//        didSelectItemAtIndexPath:indexPath];
        
    }else{
        //color pick collection view case here
        
        int colorIDIntValue = indexPath.item;
        self.kind.colorID = [NSNumber numberWithInt:colorIDIntValue];
        NSLog(@"selected colorID is : %i",self.kind.colorID.intValue);
        
        for (ColorCVCell *visibleCell in collectionView.visibleCells) {
            NSIndexPath *visibleCellIndexPath = [collectionView indexPathForCell:visibleCell];
            if (([visibleCellIndexPath compare: indexPath]) != NSOrderedSame) {
                if (visibleCell.isSelected) {
                    visibleCell.selected = NO;
                }
            }
        }
        
    }
    
    
}

#pragma mark - NSUndoManager


-(NSUndoManager *)undoManager
{
    NSManagedObjectContext *managedObjectContext = [PubicVariable managedObjectContext];
    if (!managedObjectContext.undoManager) {
        managedObjectContext.undoManager = [[NSUndoManager alloc] init];
    }
    return managedObjectContext.undoManager;
}



@end
