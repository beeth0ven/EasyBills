//
//  MyCollectionViewController+CollectionView.m
//  EasyBills
//
//  Created by 罗 杰 on 11/15/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "MyCollectionViewController+CollectionView.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "PhotoCollectionViewCell.h"



@implementation MyCollectionViewController (CollectionView)



- (void) handleTextFieldDidBeginEditingNotification:(NSNotification *)paramNotification{
    
    if (self.inputCellIndexPath) {
        [self.collectionView performBatchUpdates:^{
            [self removeDataAndCellAtIndexPath:self.inputCellIndexPath];
            self.inputCellIndexPath = nil;

        }
                                 completion:nil];
    }
    
}

-(void) handleSetBillLocationIsOnNotification:(NSNotification *)paraNotification
{
    BOOL switchIsOn = [(NSNumber *)(paraNotification.userInfo[kSetBillLocationIsKey]) boolValue];
    BOOL locationIsOn = self.bill.locationIsOn.boolValue;
    
    if (switchIsOn) {
        //is on
        if (!locationIsOn) {
            //swich is on and before get current location;
            [self showInputCellWithBaseCellIdentifier:@"locationCell"];
        }

    }else{
        //is off
        [self.view endEditing:YES];
        if (self.inputCellIndexPath){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.inputCellIndexPath.item - 1 inSection:self.inputCellIndexPath.section];
            [self showInputViewWithTapAtIndexPath:indexPath];
        }
    }
    
}

-(void)showInputCellWithBaseCellIdentifier:(NSString *)identifier
{
    NSInteger item = [self.cellIdentifiers indexOfObject:identifier];
    if (item > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        if (self.inputCellIndexPath.item != item +1) {
            [self showInputViewWithTapAtIndexPath:indexPath];
        }
    }
    
}

- (void) handleDeleteBillImageNotification:(NSNotification *)paramNotification{
    
    NSInteger item = [self.cellIdentifiers indexOfObject:@"photoCell"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [self showInputViewWithTapAtIndexPath:indexPath];
    cell.bill = self.bill;
    
}

#pragma mark - imageCell config



-(void)updateInputPhotoCell
{
    //just set new image and enable photo button
    NSInteger item = [self.cellIdentifiers indexOfObject:@"inputphotoCell"];
    if (item > 0) {
        
        //set image
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        cell.bill = self.bill;
       
        //enable photo button
        NSIndexPath *baseCellindexPath = [NSIndexPath indexPathForItem:item - 1 inSection:0];
        PhotoCollectionViewCell *photoCollectionViewCell = (PhotoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:baseCellindexPath];
        photoCollectionViewCell.bill = self.bill;

    }
    
    
}


- (IBAction)imageViewShownStateChange:(UIButton *)sender {
    NSInteger item = [self.cellIdentifiers indexOfObject:@"photoCell"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    [self showInputViewWithTapAtIndexPath:indexPath];

}
- (IBAction)showImage:(UIButton *)sender {
    if (self.bill.image) {
        JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
        imageInfo.image = self.bill.image;
        imageInfo.referenceRect = sender.frame;
        imageInfo.referenceView = sender.superview;
        // Setup view controller
        JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                               initWithImageInfo:imageInfo
                                               mode:JTSImageViewControllerMode_Image
                                               backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
        
        // Present the view controller.
        [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
    }
    
}


#pragma mark - UICollectionViewDataSource




-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self cellIdentifiers] count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    NSString *identifier = [self cellIdentifiers][indexPath.item];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [self configBillCell:cell];
    return cell;
}

/*
 
 -(NSString *)identifierAtIndexPath:(NSIndexPath *)indexPath
 {
 NSString *identifier;
 
 if ([self showDatePicker] && (self.datePickerIndexPath.item == indexPath.item)) {
 identifier = @"datepickerCell";
 }else if ([self showDatePicker] && (indexPath.item > self.datePickerIndexPath.item)) {
 identifier = [self cellIdentifier][indexPath.item - 1];
 }else{
 identifier = [self cellIdentifier][indexPath.item];
 }
 return identifier;
 }
 
 */


-(void)configBillCell:(UICollectionViewCell *)cell
{
    if ([cell respondsToSelector:@selector(setBill:)]) {
        [cell performSelector:@selector(setBill:) withObject:self.bill];
    }
}


#pragma mark - UICollectionViewDelegate



-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"deleteCell"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@DELETE_BILL_ACTIONSHEET_TITLE
                                                                 delegate:(id <UIActionSheetDelegate>)self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:@"删除"
                                                        otherButtonTitles: nil];
        [actionSheet showInView:self.view];
    }else if ([cell.reuseIdentifier isEqualToString:@"kindCell"] ||
              [cell.reuseIdentifier isEqualToString:@"dateCell"] ||
              ([cell.reuseIdentifier isEqualToString:@"locationCell"] && (self.bill.locationIsOn.boolValue == YES)))
    {
    
        [self showInputViewWithTapAtIndexPath:indexPath];
        
        
    }
    
}

-(void)showInputViewWithTapAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView performBatchUpdates:^{
        
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];

        NSIndexPath *inputCellIndexPath = [NSIndexPath indexPathForItem:indexPath.item + 1  inSection:0];
        
        [self.view endEditing:YES];
        
        if (!self.inputCellIndexPath) {
            
            [self insertDataAndCell:cell AtIndexPath:inputCellIndexPath];
            self.inputCellIndexPath = inputCellIndexPath;
            
        }else if([inputCellIndexPath isEqual:self.inputCellIndexPath]){
            
            [self removeDataAndCellAtIndexPath:inputCellIndexPath];
            self.inputCellIndexPath = nil;
            
        }else if(![inputCellIndexPath isEqual:self.inputCellIndexPath]){
            
            inputCellIndexPath = self.inputCellIndexPath;
            [self removeDataAndCellAtIndexPath:inputCellIndexPath];
            
            inputCellIndexPath = [self calculateIndexPathforNewInputCell:indexPath];
            [self insertDataAndCell:cell AtIndexPath:inputCellIndexPath];
            
            self.inputCellIndexPath = inputCellIndexPath;
        }
        
    }
                                  completion:^(BOOL finished){
                                      
                                      if (finished) {
                                          if (self.inputCellIndexPath) {
                                              UICollectionViewCell *inputCell = [self.collectionView cellForItemAtIndexPath:self.inputCellIndexPath];
                                              [self.collectionView scrollRectToVisible:inputCell.frame animated:YES];
                                          }
                                      }
                                      
                                  }];
    
    
}

-(void)insertDataAndCell:(UICollectionViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *indexPaths = @[indexPath];
    NSString *inputCellIdentifier = [NSString stringWithFormat:@"input%@",cell.reuseIdentifier];
    [self.cellIdentifiers insertObject:inputCellIdentifier atIndex:indexPath.item];
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
    
    
}


-(void)removeDataAndCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *indexPaths = @[indexPath];
    [self.cellIdentifiers removeObjectAtIndex:indexPath.item];
    [self.collectionView deleteItemsAtIndexPaths:indexPaths];
}



-(NSIndexPath *)calculateIndexPathforNewInputCell:(NSIndexPath *)indexPath
{
    NSIndexPath *inputCellIndexPath = [NSIndexPath indexPathForItem:indexPath.item + 1  inSection:0];
    if (inputCellIndexPath.item > self.inputCellIndexPath.item) {
        inputCellIndexPath = [NSIndexPath indexPathForItem:indexPath.item  inSection:0];
    }
    return inputCellIndexPath;
}


/*
 NSArray *indexPaths = @[[NSIndexPath indexPathForItem:indexPath.item + 1  inSection:0]];
 [collectionView performBatchUpdates:^{
 if (!self.showDatePicker) {
 [self.collectionView insertItemsAtIndexPaths:indexPaths];
 }else{
 [self.collectionView deleteItemsAtIndexPaths:indexPaths];
 }
 
 }
 completion:nil];
 */
//[self.collectionView  reloadData];
#pragma mark - UICollectionViewLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    
    NSInteger colorItem = [self.cellIdentifiers indexOfObject:@"inputcolorCell"];
    
    if ([self inputCellIndexPath] && (self.inputCellIndexPath.item == indexPath.item)) {
        size = CGSizeMake(297, 200);
        
    }else if(colorItem == indexPath.item){
        size = CGSizeMake(297, 235);
        
    }
    else{
        size =  CGSizeMake(297, 64);
        
    }
    return size;
}


@end
