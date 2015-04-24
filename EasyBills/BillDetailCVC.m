//
//  MyCollectionViewController.m
//  EasyBills
//
//  Created by 罗 杰 on 11/10/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "BillDetailCVC.h"
#import "ImageCollectionViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>   // kUTTypeImage
#import "UINavigationController+Style.h"
#import "DefaultStyleController.h"
#import <MapKit/MapKit.h>
#import "Bill+MKAnnotation.h"
#import "BillDetailCVC+CLLocation.h"
#import "BillDetailCVC+MKMapView.h"
#import "BillDetailCVC+UIActionSheet.h"
#import "BillDetailCVC+SetUp.h"
#import "BillDetailCVC+UIDatePicker.h"
#import "BillDetailCVC+UIPickerView.h"
#import "BillDetailCVC+UITextField.h"
#import "UIToolbar+Extension.h"
#import "NSString+Extension.h"
#import "Plackmark+Create.h"
#import "Plackmark.h"


@interface BillDetailCVC ()

// The Data Source Frome Storyboard Cell Identifiers
@property (strong ,nonatomic) NSMutableArray *cellIdentifiers;

// For Debug
@property (weak, nonatomic) UICollectionViewCell *mapCell;


@end

@implementation BillDetailCVC


#pragma mark - View Controller Life Cycle Method



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController applyDefualtStyle:NO];
    [self configTitleColor];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [PubicVariable saveContext];
}




#pragma mark - UICollection View Data Source Method

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [[self cellIdentifiers] count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    NSString *identifier = [self cellIdentifiers][indexPath.item];
    cell = [collectionView
            dequeueReusableCellWithReuseIdentifier:identifier
            forIndexPath:indexPath];
    [self configBillCell:cell];
    return cell;
}


-(void)configBillCell:(UICollectionViewCell *)cell
{
    
    if ([cell.reuseIdentifier isEqualToString:@"moneyCell"]) {
        UIView *view = [cell viewWithTag:1];
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.delegate = self;
            textField.inputAccessoryView = [UIToolbar
                                            keyboardToolBarWithVC:self
                                            doneAction:@selector(endEditing)];
            
            textField.text =
            self.bill.money.floatValue != 0 ?
            [NSString stringWithFormat:@"%.0f",fabsf(self.bill.money.floatValue)]:
            nil;
        }
        
        
    }else if ([cell.reuseIdentifier isEqualToString:@"kindCell"]) {
        UIView *view = [cell viewWithTag:1];
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.text = self.bill.kind.name;
        }
        
    }else if ([cell.reuseIdentifier isEqualToString:@"inputkindCell"]) {
        UIView *view = [cell viewWithTag:1];
        if ([view isKindOfClass:[UIPickerView class]]) {
            UIPickerView *picker = (UIPickerView *)view;
            picker.dataSource = self;
            picker.delegate = self;
            picker.showsSelectionIndicator = YES;
            NSIndexPath *selectIndexPath =
            [self.kindFRC indexPathForObject:self.bill.kind];
            [picker selectRow:selectIndexPath.row
                  inComponent:selectIndexPath.section
                     animated:NO];
        }

    }else if ([cell.reuseIdentifier isEqualToString:@"dateCell"]) {
        UIView *view = [cell viewWithTag:1];
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.text = [PubicVariable stringFromDate:self.bill.date];
        }
    }else if ([cell.reuseIdentifier isEqualToString:@"inputdateCell"]) {
        UIView *view = [cell viewWithTag:1];
        if ([view isKindOfClass:[UIDatePicker class]]) {
            UIDatePicker *datePicker = (UIDatePicker *)view;
            datePicker.date = self.bill.date;
            [datePicker addTarget:self
                           action:@selector(datePickerChanged:)
                 forControlEvents:UIControlEventValueChanged];
        }
    }else if ([cell.reuseIdentifier isEqualToString:@"locationCell"]) {
        // Configure Location Cell
        UIView *view = [cell viewWithTag:1];
        if ([view isKindOfClass:[UISwitch class]]) {
            UISwitch *swich = (UISwitch *)view;
            [swich setOn: self.bill.locationIsOn.boolValue];
            [swich addTarget:self
                      action:@selector(locationStateChanged:)
            forControlEvents:UIControlEventValueChanged];
        }
    }else if ([cell.reuseIdentifier isEqualToString:@"inputlocationCell"]){
        UIActivityIndicatorView *activity   = (UIActivityIndicatorView *)[cell viewWithTag:1];
        UILabel                 *label      = (UILabel *)[cell viewWithTag:2];
        MKMapView               *mapView    = (MKMapView *)[cell viewWithTag:3];
        
        mapView.delegate = self;
        mapView.zoomEnabled = NO;
        mapView.scrollEnabled = NO;
        mapView.pitchEnabled = NO;
        mapView.rotateEnabled = NO;

        [self reloadDataInMapView:mapView];
        [self updateMapCellLabel:label activity:activity];
        self.mapCell = cell;
    }if ([cell.reuseIdentifier isEqualToString:@"notebodyCell"]) {
        UIView *view = [cell viewWithTag:1];
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.delegate = self;
            textField.inputAccessoryView = [UIToolbar
                                            keyboardToolBarWithVC:self
                                            doneAction:@selector(endEditing)];
            
            textField.text = self.bill.note;
        }
        
        
    }
}

- (UICollectionViewCell *)cellWithIdentifier:(NSString *)identifier {
    
    UICollectionViewCell *cell = nil;
    if ([self.cellIdentifiers containsObject:identifier]) {
        NSInteger row = [self.cellIdentifiers indexOfObject:identifier];
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForRow:row inSection:0];
        cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    }
    return cell;
}

- (void)updateCellWithIdentifier:(NSString *)identifier {
    
    UICollectionViewCell *cell = [self cellWithIdentifier:identifier];
    if (cell != nil) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}


- (void)updateMapViewCellWithoutLocation{

    if (self.mapCell != nil) {
        UIActivityIndicatorView *activity   = (UIActivityIndicatorView *)[self.mapCell viewWithTag:1];
        UILabel                 *label      = (UILabel *)[self.mapCell viewWithTag:2];
        MKMapView               *mapView    = (MKMapView *)[self.mapCell viewWithTag:3];
        
        [mapView removeAnnotations:mapView.annotations];
        [mapView showAnnotations:mapView.annotations animated:NO];
        mapView = nil;
        label.text = @"";
        [activity startAnimating];
    }

    
}


- (void)updateMapCellLabel:(UILabel *)label
                  activity:(UIActivityIndicatorView *)activity{
    
    if (self.bill.plackmark.name.length) {
        label.text = self.bill.plackmark.name;
        [activity stopAnimating];
    }
//    else{
//        [self updateMapViewCellWithoutLocation];
//
//        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//        CLLocation *location =[[CLLocation alloc]
//                               initWithLatitude:self.bill.latitude.doubleValue
//                               longitude:self.bill.longitude.doubleValue];
//        
//        [geocoder reverseGeocodeLocation:location
//                       completionHandler:
//         ^(NSArray *placemarks, NSError *error){
//             if (!error && [placemarks count] > 0) {
//                 CLPlacemark *placemark = [placemarks lastObject];
//                 NSString *name = [NSString stringForPlacemark:placemark];
//                 self.bill.plackmark = [Plackmark plackmarkWithName:name];
//             }else{
//                 self.bill.plackmark = [Plackmark plackmarkWithName:@"未知地点"];
//             }
//            
//         }];
        
//    }
    

}




#pragma mark - UICollection View Delegate Method



-(void)         collectionView:(UICollectionView *)collectionView
      didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"deleteCell"]) {
        [self didSelectDeleteCell];
    }else if ([cell.reuseIdentifier isEqualToString:@"kindCell"] ||
              [cell.reuseIdentifier isEqualToString:@"dateCell"] ||
              ([cell.reuseIdentifier isEqualToString:@"locationCell"] &&
               (self.bill.locationIsOn.boolValue == YES)))
    {
        [self showInputViewWithTapAtIndexPath:indexPath];
    }
    
}


- (void)didSelectDeleteCell{
    UIActionSheet *actionSheet =
    [[UIActionSheet alloc] initWithTitle:DELETE_BILL_ACTIONSHEET_TITLE
                                delegate:self
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:@"删除"
                       otherButtonTitles: nil];
    [actionSheet showInView:self.view];
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
                                              UICollectionViewCell *inputCell =
                                              [self.collectionView cellForItemAtIndexPath:self.inputCellIndexPath];
                                              [self.collectionView scrollRectToVisible:inputCell.frame animated:YES];
                                          }
                                      }
                                      
                                  }];
    
    
}


- (void)showMapCell{
    if (self.shouldShowMapCell)
        [self showInputCellWithBaseCellIdentifier:@"locationCell"];
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



-(void)insertDataAndCell:(UICollectionViewCell *)cell
             AtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *indexPaths = @[indexPath];
    NSString *inputCellIdentifier = [NSString stringWithFormat:@"input%@",cell.reuseIdentifier];
    [self.cellIdentifiers insertObject:inputCellIdentifier
                               atIndex:indexPath.item];
    
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
    NSIndexPath *inputCellIndexPath =
    [NSIndexPath indexPathForItem:indexPath.item + 1
                        inSection:0];
    
    if (inputCellIndexPath.item > self.inputCellIndexPath.item) {
        inputCellIndexPath =
        [NSIndexPath indexPathForItem:indexPath.item
                            inSection:0];
    }
    return inputCellIndexPath;
}

- (void)endEditing{
    
    [self.view endEditing:YES];
    if (self.inputCellIndexPath){
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForItem:self.inputCellIndexPath.item - 1
                            inSection:self.inputCellIndexPath.section];
        [self showInputViewWithTapAtIndexPath:indexPath];
    }
}

#pragma mark - UICollection View Layout Method

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    
    NSInteger colorItem = [self.cellIdentifiers indexOfObject:@"inputcolorCell"];
    
    CGFloat cellWidth = collectionView.bounds.size.width - 20;
    
    if ([self inputCellIndexPath] &&
        (self.inputCellIndexPath.item == indexPath.item)) {
        size = CGSizeMake(cellWidth, 200);
        
    }else if(colorItem == indexPath.item){
        size = CGSizeMake(cellWidth, 235);
        
    }
    else{
        size =  CGSizeMake(cellWidth, 64);
        
    }
    return size;
}



#pragma mark - Properties Setter And Getter Method

- (NSMutableArray *)cellIdentifiers {
    if (!_cellIdentifiers) {
        _cellIdentifiers = [@[@"moneyCell",
                              @"kindCell",
                              @"dateCell",
                              @"locationCell",
                              @"notebodyCell",
                              @"deleteCell"] mutableCopy];
        
    }
    return _cellIdentifiers;
}

- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        
    }
    return _locationManager;
}

- (NSFetchedResultsController *)kindFRC {
    if (_kindFRC == nil) {
        _kindFRC =
        [Kind fetchedResultsControllerIsincome:self.bill.isIncome.boolValue];
    }
    return _kindFRC;
}


- (UITextField *)moneyTextField {
    
    if (_moneyTextField == nil) {
        UICollectionViewCell *cell = [self cellWithIdentifier:@"moneyCell"];
        UIView *view = [cell viewWithTag:1];
        if ([view isKindOfClass:[UITextField class]]) {
            _moneyTextField = (UITextField *)view;
        }
    }
    return _moneyTextField;
}

- (UITextField *)noteTextField {
    
    if (_noteTextField == nil) {
        UICollectionViewCell *cell = [self cellWithIdentifier:@"notebodyCell"];
        UIView *view = [cell viewWithTag:1];
        if ([view isKindOfClass:[UITextField class]]) {
            _noteTextField = (UITextField *)view;
        }
    }
    return _noteTextField;
}


@end
