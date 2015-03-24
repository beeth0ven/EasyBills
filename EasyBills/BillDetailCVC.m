//
//  MyCollectionViewController.m
//  EasyBills
//
//  Created by 罗 杰 on 11/10/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "BillDetailCVC.h"
#import "AFTextView.h"
#import <CoreData/CoreData.h>
#import "Bill+Create.h"
#import "PubicVariable.h"
#import "PubicVariable+FetchRequest.h"
#import <CoreLocation/CoreLocation.h>
#import "Kind+Create.h"
#import "DatePickerCVCell.h"
#import "MoneyCVCell.h"
#import "ImageCollectionViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>   // kUTTypeImage
#import "UINavigationController+Style.h"
#import "DefaultStyleController.h"
#import <MapKit/MapKit.h>
#import "UIImage+Extension.h"
#import "Bill+MKAnnotation.h"

@interface BillDetailCVC ()<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,
CLLocationManagerDelegate,
MKMapViewDelegate>

// The Data Source Frome Storyboard Cell Identifiers
@property (strong ,nonatomic) NSMutableArray *cellIdentifiers;
// The Current Input Cell IndexPath
@property (strong ,nonatomic) NSIndexPath *inputCellIndexPath;
// The Core Location Manager
@property (strong, nonatomic) CLLocationManager *locationManager;

// For Debug
@property (weak, nonatomic) UICollectionViewCell *mapCell;

@property (nonatomic) BOOL shouldShowMapCell;

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
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [PubicVariable saveContext];
}


- (void) dealloc{
    if (self.bill != nil) [self.bill removeObserver:self forKeyPath:@"locationIsOn"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (NSUndoManager *)undoManager
{
    NSManagedObjectContext *managedObjectContext = [PubicVariable managedObjectContext];
    if (!managedObjectContext.undoManager) {
        managedObjectContext.undoManager = [[NSUndoManager alloc] init];
    }
    return managedObjectContext.undoManager;
}


#pragma mark - Notifications Method


-(void)registerNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // others can't edite  when TextFieldDidBeginEditing.
    
    [center addObserver:self
               selector:@selector(handleTextFieldDidBeginEditingNotification:)
                   name:kTextFieldDidBeginEditingNotification
                 object:nil];
    
    //keyboard notification ,scoll textfield to visible.
    
    [center addObserver:self
               selector:@selector(keyboardWasShown:)
                   name:UIKeyboardDidShowNotification object:nil];
    
    [center addObserver:self
               selector:@selector(keyboardWillBeHidden:)
                   name:UIKeyboardWillHideNotification object:nil];
    
    //Reset Map Cell State
    [self.bill addObserver:self
                forKeyPath:@"locationIsOn"
                   options:NSKeyValueObservingOptionNew
                   context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if ([keyPath isEqualToString:@"locationIsOn"]) {
        NSNumber *newValue = [change objectForKey:NSKeyValueChangeNewKey];
        if ([newValue respondsToSelector:@selector(boolValue)]) {
            BOOL isOn = newValue.boolValue;
            if (isOn == NO) {
                [self updateMapViewCellWithoutLocation];
            }
        }
 
        
    }
    
}


- (void) handleTextFieldDidBeginEditingNotification:(NSNotification *)paramNotification{
    
    if (self.inputCellIndexPath) {
        [self.collectionView performBatchUpdates:^{
            [self removeDataAndCellAtIndexPath:self.inputCellIndexPath];
            self.inputCellIndexPath = nil;
            
        }
                                      completion:nil];
    }
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize =[[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    UIEdgeInsets contentInsets = self.collectionView.contentInset;
    contentInsets.bottom = kbSize.height;
    
    self.collectionView.contentInset = contentInsets;
    self.collectionView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= (kbSize.height);
    PubicVariable *pubicVariable = [PubicVariable pubicVariable];
    if (!CGRectContainsPoint(aRect, pubicVariable.activeField.frame.origin)) {
        CGRect rect = pubicVariable.activeField.frame;
        [self.collectionView scrollRectToVisible:rect animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = self.collectionView.contentInset;
    contentInsets.bottom = 0;
    [UIView animateWithDuration:0.4 animations:^{
        self.collectionView.contentInset = contentInsets;
        
    }];
    self.collectionView.scrollIndicatorInsets = contentInsets;
    
}




#pragma mark - IBAction Method

- (IBAction)done:(UIBarButtonItem *)sender
{
    [self.view endEditing:YES];
    if (self.bill.money.floatValue != 0) {
        [self setIsUndo:NO];
        [self dismissViewControllerAnimated:YES completion:^(){
            [PubicVariable saveContext];
        }];
    }else{
        NSInteger item = [self.cellIdentifiers indexOfObject:@"moneyCell"];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        MoneyCVCell *moneyCollectionViewCell = (MoneyCVCell *)cell;
        moneyCollectionViewCell.label.textColor = [UIColor redColor];
    }
    
    
}

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    
    [self.view endEditing:YES];
    [self setIsUndo:YES];
    [self dismissViewControllerAnimated:YES completion:^(){}];
    
}

- (IBAction)locationStateChanged:(UISwitch *)sender {
    
    if (sender.isOn) {
        self.shouldShowMapCell = YES;
        [self requestGetCurentLocation];
    }else{
        self.bill.locationIsOn = [NSNumber numberWithBool:NO];
        self.bill.latitude = nil;
        self.bill.longitude = nil;
        [self endEditing];
    }
}

#pragma mark - Core Location Method

//Request Current CLLocationManager Authorization Status
- (void)requestGetCurentLocation{
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusDenied:{
                [self displayAlertWithTitle:@"访问拒绝"
                                    message:@"应用程序没有权利访问定位服务！"];
                break;
            }
            case kCLAuthorizationStatusNotDetermined:{
                [self.locationManager requestWhenInUseAuthorization];
                break;
            }case kCLAuthorizationStatusRestricted:{
                [self displayAlertWithTitle:@"访问受限"
                                    message:@"应用程访问定位服务受到限制！"];
                break;
            }
            default:{
                [self getCurentLocation];
                break;
            }
        }
        
        [self updateLocationCell];

    }
}


//Authorization Status Changed
- (void)        locationManager:(CLLocationManager *)manager
   didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    NSLog(@"The authorization status of location services is changed to: ");
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusDenied:{
            NSLog(@"Denied");
            break;
        }
        case kCLAuthorizationStatusNotDetermined:{
            NSLog(@"Not determined");
            break;
        }case kCLAuthorizationStatusRestricted:{
            NSLog(@"Restricted");
            break;
        }
        default:{
            [self getCurentLocation];
            break;
        }
    }
    
}


-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations
{
    CLLocation *curentLocation = locations.lastObject;
    self.bill.locationIsOn = [NSNumber numberWithBool:YES];
    [self.bill setCoordinate:curentLocation.coordinate];
//    self.bill.latitude = [NSString stringWithFormat:@"%.8f" ,curentLocation.coordinate.latitude];
//    self.bill.longitude = [NSString stringWithFormat:@"%.8f" ,curentLocation.coordinate.longitude];
    [self.locationManager stopUpdatingLocation];
    [self updateLocationCell];
    [self showMapCell];
//    self.locationSwitch.on = YES;
//    [self postNotificationWithLocationIsOn:YES];
    NSLog(@"latitude:%f longitude:%f",curentLocation.coordinate.latitude ,curentLocation.coordinate.longitude);
    
}


-(void) locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
//    [self displayAlertWithTitle:@"访问错误"
//                        message:@"无法获取您的位置！"];
    [self.locationManager stopUpdatingLocation];
//    self.locationSwitch.on = NO;
//    [self locationIsOnStateChanged:self.locationSwitch];
    
}

- (void)getCurentLocation{
    [self.locationManager startUpdatingLocation];
    
}

- (void)displayAlertWithTitle:(NSString *)title
                      message:(NSString *)message{
    
    UIAlertView *alertView =
    [[UIAlertView alloc]
     initWithTitle:title
     message:message
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles: nil];
    
    [alertView show];
    
}


#pragma mark - MKMap View Delegate Method

-(MKAnnotationView *)   mapView:(MKMapView *)mapView
              viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *view = nil;
    static NSString *reuseId = @"billAnnotation";
    view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
    UIColor *color = self.bill.isIncome.boolValue ? EBBlue : EBBackGround;
    view.image = [UIImage pointerImageWithColor:color];
    view.canShowCallout = NO;
//    view.pinColor = self.bill.isIncome.boolValue ? MKPinAnnotationColorGreen : MKPinAnnotationColorRed;
    return view;
}




- (void)reloadDataInMapView:(MKMapView *)mapView{
    [mapView removeAnnotations:mapView.annotations];
    [mapView addAnnotation:(id <MKAnnotation>)self.bill];
    [mapView showAnnotations:mapView.annotations animated:YES];
}

- (void)updateMapCellLabel:(UILabel *)label
                  activity:(UIActivityIndicatorView *)activity{
    
    CLLocation *location =
    [[CLLocation alloc]initWithLatitude:self.bill.latitude.doubleValue
                              longitude:self.bill.longitude.doubleValue];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error){
//                       NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
                       if (!error && [placemarks count] > 0) {
                           CLPlacemark *placemark = [placemarks lastObject];
                           [activity stopAnimating];
                           label.text = [NSString stringWithFormat:@"%@,%@,%@",
                                         placemark.administrativeArea,
                                         placemark.locality,
                                         placemark.thoroughfare];
                       }else{
                           [activity stopAnimating];
                           label.text = @"无法识别您的位置";
                       }
                   }];
}


#pragma mark - UICollection View Data Source Method

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

-(void)configBillCell:(UICollectionViewCell *)cell
{
    if ([cell respondsToSelector:@selector(setBill:)]) {
        [cell performSelector:@selector(setBill:) withObject:self.bill];
    }
    
    if ([cell.reuseIdentifier isEqualToString:@"locationCell"]) {
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
        [self performSelector:@selector(reloadDataInMapView:)
                   withObject:mapView
                   afterDelay:0.3];
//        [self reloadDataInMapView:mapView];
        [self updateMapCellLabel:label activity:activity];
        self.mapCell = cell;
    }
}

- (void)updateLocationCell{
    
    NSString *cellIdentifier = @"locationCell";
    if ([self.cellIdentifiers containsObject:cellIdentifier]) {
        NSInteger row = [self.cellIdentifiers indexOfObject:cellIdentifier];
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForRow:row inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}


- (void)updateMapViewCellWithoutLocation{
//    
//    NSString *cellIdentifier = @"inputlocationCell";
//    if ([self.cellIdentifiers containsObject:cellIdentifier]) {
//        NSInteger row = [self.cellIdentifiers indexOfObject:cellIdentifier];
//        NSIndexPath *indexPath =
//        [NSIndexPath indexPathForRow:row inSection:0];
//        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
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
              ([cell.reuseIdentifier isEqualToString:@"locationCell"] && (self.bill.locationIsOn.boolValue == YES)))
    {
        
        [self showInputViewWithTapAtIndexPath:indexPath];
        
        
    }
    
}


- (void)didSelectDeleteCell{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@DELETE_BILL_ACTIONSHEET_TITLE
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
                                              UICollectionViewCell *inputCell = [self.collectionView cellForItemAtIndexPath:self.inputCellIndexPath];
                                              [self.collectionView scrollRectToVisible:inputCell.frame animated:YES];
                                          }
                                      }
                                      
                                  }];
    
    
}


- (void)showMapCell{
    if (self.shouldShowMapCell) [self showInputCellWithBaseCellIdentifier:@"locationCell"];
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

- (void)endEditing{
    
    [self.view endEditing:YES];
    if (self.inputCellIndexPath){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.inputCellIndexPath.item - 1 inSection:self.inputCellIndexPath.section];
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

#pragma mark - UIAction Sheet Delegate Method


-(void)     actionSheet:(UIActionSheet *)actionSheet
   clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"删除" ]) {
        [self deleteBill];
    }
}

- (void)deleteBill
{
    [[PubicVariable managedObjectContext] deleteObject:self.bill];
    [self dismissViewControllerAnimated:YES completion:^(){}];
    
}

#pragma mark - Some Method

- (void)setUp {
    
    [[self undoManager] beginUndoGrouping];
    if (!self.bill){
//         The bill is created, not passed.
        self.bill = [Bill billIsIncome:self.isIncome];
        
//         The location state is inherit from last bill.
//         If this is the unique bill(last bill don't exist), Then the state is On, by defult.
        if ([self isBillCreateUnique] || [self lastBillLocationStateIsOn]) [self requestGetCurentLocation];
    }
    self.isIncome = self.bill.isIncome.boolValue;
    [self registerNotifications];
    [self setUpBackgroundView];
}

- (BOOL)isBillCreateUnique{
    return [Bill lastCreateBill] == nil;
}

- (BOOL)lastBillLocationStateIsOn
{
    Bill *lastCreateBill = [Bill lastCreateBill];
    return lastCreateBill.locationIsOn.boolValue;
}

- (void)setUpBackgroundView {
    UIImage *image = [UIImage imageNamed:@"Account details BG"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.collectionView.backgroundView = imageView;
    self.title = self.isIncome ? @"收入": @"支出";
}

-(void)setIsUndo:(BOOL)isUndo
{
    [[self undoManager] endUndoGrouping];
    if (isUndo)[[self undoManager] undoNestedGroup];
}




@end
