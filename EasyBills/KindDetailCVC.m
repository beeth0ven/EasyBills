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
#import "UIFont+Extension.h"
#import "UIToolbar+Extension.h"
#import "ColorCVCell.h"
#import "AppDelegate.h"
#import "NSString+Extension.h"

@interface KindDetailCVC ()

@property (strong ,nonatomic) NSMutableArray *cellIdentifiers;

@property (strong ,nonatomic) UITextField *activeField;


@end



@implementation KindDetailCVC

#define ColorCellWidth 40.0f
#define ColorCellSpace 10.0f
#define CellMargin 10.0f



#pragma mark - UIView Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
    
    
    //self.datePickerIndexPath = [NSIndexPath indexPathForItem:3 inSection:0];
    
    // Do any additional setup after loading the view.
    //[self updateUI];
//    [self configBarButtonItem];
    }

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController applyDefualtStyle:NO];
//    [self registerAsObserver];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (self.kind.name.length == 0) {
//        NSInteger index = [self.cellIdentifiers indexOfObject:@"nameCell"];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
//        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//    }
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


- (void)endEditing{
    
    [self.view endEditing:YES];

}


-(void)setIsUndo:(BOOL)isUndo
{
    [[self undoManager] endUndoGrouping];
    if (isUndo)[[self undoManager] undoNestedGroup];
}

- (void)setUp {
    
    [[self undoManager] beginUndoGrouping];
    if (!self.kind){
        BOOL lastCreatedKindIsIncome = [Kind lastCreatedKindIsIncomeInManagedObjectContext:self.managedObjectContext];
        self.kind = [Kind kindWithName:@""
                              isIncome:lastCreatedKindIsIncome
                inManagedObjectContext:self.managedObjectContext];
    }else{
        self.isIncome = self.kind.isIncome.boolValue;
    }
    [self registerNotifications];
    [self setUpBackgroundView];
    [self updateTitle];
}

- (void)setUpBackgroundView {
    UIImage *image = [UIImage imageNamed:@"Account details BG"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.collectionView.backgroundView = imageView;
    
}

- (void)updateTitle {
    if (self.kind.name.length > 0) {
        self.title = self.kind.name;
    }else{
        self.title = @"未命名";
    }
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
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];


    
//    keyboard notification ,scoll textfield to visible.
    
    [center addObserver:self
               selector:@selector(keyboardWasShown:)
                   name:UIKeyboardDidShowNotification object:nil];
    
    [center addObserver:self
               selector:@selector(keyboardWillBeHidden:)
                   name:UIKeyboardWillHideNotification object:nil];
    
    
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
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin)) {
        CGRect rect = self.activeField.frame;
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

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UICollection View Data Source




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
        //main collection view case here
        NSInteger count = self.kind.isDefault.boolValue ? [[self cellIdentifiers] count]-1 :[[self cellIdentifiers] count];
        return count;
        
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
    
    
    
    if ([cell.reuseIdentifier isEqualToString:@"nameCell"]){
        
        UIView *view = [cell viewWithTag:3];
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.delegate = self;
            textField.inputAccessoryView = [UIToolbar
                                            keyboardToolBarWithVC:self
                                            doneAction:@selector(endEditing)];
            if (self.kind.name.length > 0) {
                textField.text = self.kind.name;
            } else {
                textField.text = nil;
            }
            textField.enabled = !self.kind.isDefault.boolValue;
        }
        
        
    }else if ([cell.reuseIdentifier isEqualToString:@"isIncomeCell"]){
        
        UIView *view = [cell viewWithTag:3];
        if ([view isKindOfClass:[UISwitch class]]) {
            UISwitch *switchControl = (UISwitch *)view;
            [switchControl setOn:self.kind.isIncome.boolValue];
            switchControl.enabled = !self.kind.isDefault.boolValue;
            
        }
        
        
    }else if ([cell.reuseIdentifier isEqualToString:@"colorCell"]){
//        
//        id view = [cell viewWithTag:1];
//        if ([view isKindOfClass:[UIView class]]) {
//            UIView *colorView = view;
//            colorView.backgroundColor = self.kind.color;
//        }
        
    }
    
    else if ([cell.reuseIdentifier isEqualToString:@"inputcolorCell"]) {
        UICollectionView *collectionView = (UICollectionView *)[cell viewWithTag:1];
//        CGSize cellSize = [self collectionView:collectionView
//                                        layout:collectionView.collectionViewLayout
//                        sizeForItemAtIndexPath:indexPath];
//        CGFloat minSpacingForCells = collectionView.frame.size.width-(5*cellSize.width)/9*2;
//        collectionView.m
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
    }else if ([cell.reuseIdentifier isEqualToString:@"colorUnitCell"]) {
        //color pick collection view case here
        
        UIColor *color = (UIColor *)
        [[ColorCenter colors] objectAtIndex:indexPath.row];
        
        if ([cell isKindOfClass:[ColorCVCell class]]) {
            ColorCVCell *colorCVCell = (ColorCVCell *)cell;
            colorCVCell.favoriteColor = color;
            colorCVCell.notFavoriteColor = [color colorWithAlphaComponent:0.9];
//            
            int colorIDIntValue = self.kind.colorID.intValue;
            colorCVCell.favorite = (colorIDIntValue == indexPath.item);

        }
        
    }
    
    UIView *view = [cell viewWithTag:2];
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        label.font = [UIFont wawaFontWithSize:25];
    }
    
    
}



- (CGSize)          collectionView:(UICollectionView *)collectionView
                            layout:(UICollectionViewLayout*)collectionViewLayout
            sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    
    if (collectionView == self.collectionView) {
        
        NSInteger colorItem = [self.cellIdentifiers indexOfObject:@"inputcolorCell"];
        CGFloat width = collectionView.bounds.size.width-2*CellMargin;
        
        if(colorItem == indexPath.item){
            size = CGSizeMake(width, 211);
            
        }
        else{
            size =  CGSizeMake(width, 64);
            
        }
        return size;
        
    }else{
        //color pick collection view case here

        return CGSizeMake(ColorCellWidth, ColorCellWidth);
        
    }
    

}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    if (collectionView == self.collectionView) {
        return 0;
    }else{

        return (collectionView.bounds.size.width-5*ColorCellWidth) / 4;
    }
}


#pragma mark - UICollection View Delegate


-(void)     collectionView:(UICollectionView *)collectionView
  didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == self.collectionView) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        if ([cell.reuseIdentifier isEqualToString:@"deleteCell"]) {
            [self didSelectDeleteCell];
        }
        
//        [super collectionView:collectionView
//        didSelectItemAtIndexPath:indexPath];
        
    }else{
        //color pick collection view case here
        
        NSInteger colorIDIntValue = indexPath.item;
        self.kind.colorID = [NSNumber numberWithInteger:colorIDIntValue];
        NSLog(@"selected colorID is : %i",self.kind.colorID.intValue);
        
        for (ColorCVCell *visibleCell in collectionView.visibleCells) {
            NSIndexPath *visibleCellIndexPath = [collectionView indexPathForCell:visibleCell];
            if (([visibleCellIndexPath compare: indexPath]) != NSOrderedSame) {
                //Not selected cell.
                visibleCell.favorite = NO;

            }else{
                //Is selected cell.
                if (!visibleCell.isFavorite) {
                    //Change if cell is not selected, before.
                    visibleCell.favorite = YES;
                }
            }
        }
        
    }
    
    
}

- (void)didSelectDeleteCell{
    UIActionSheet *actionSheet =
    [[UIActionSheet alloc] initWithTitle:DELETE_KIND_ACTIONSHEET_TITLE
                                delegate:self
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:@"删除"
                       otherButtonTitles: nil];
    [actionSheet showInView:self.view];
}

#pragma mark - IBAction Method

- (IBAction)done:(UIBarButtonItem *)sender
{
    [self.view endEditing:YES];

    if (self.kind.name.length == 0) {
        self.navigationItem.prompt = @"请输入一个名字";
        return;
    }
    
    if (![self.kind isUnique]) {
        self.navigationItem.prompt = [NSString stringWithFormat:
                                      @"’%@‘已存在",
                                      self.kind.name];
        return;
    }
    
    [self setIsUndo:NO];
    
    //Save before dismiss so that the pre view can update UI.
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
    
    [self dismissViewControllerAnimated:YES completion:^(){

    }];
    
}

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^(){
        [self setIsUndo:YES];
    }];
    
    
}

- (IBAction)changeIncomeMode:(UISwitch *)sender {
    BOOL isExisted = [Kind kindIsExistedWithName:self.kind.name
                                        isIncome:self.kind.isIncome.boolValue
                          inManagedObjectContext:self.kind.managedObjectContext];
    if (isExisted){
        NSString *isIncomeString = self.kind.isIncome.boolValue ? @"支出" : @"收入";
        NSString *message = [NSString stringWithFormat:@"‘%@’下已经存在‘%@’",
                             isIncomeString,self.kind.name];
        UIAlertView *alert =
        [[UIAlertView alloc]
         initWithTitle:@"提示"
         message:message
         delegate:nil
         cancelButtonTitle:@"好"
         otherButtonTitles:nil];
        
        [alert show];

        [sender setOn:!sender.isOn];
    } else if (self.kind.bills.count == 0) {
        self.kind.isIncome = [NSNumber numberWithBool:sender.isOn];
    }  else {
        NSLog(@"This kind has bills.");
        
        NSString *message = [NSString stringWithFormat:@"‘%@’下存在%lu比笔记录。需要将它们移动到‘其他’吗？",
                             self.kind.name,(unsigned long)self.kind.bills.count];
        UIAlertView *alert =
        [[UIAlertView alloc]
         initWithTitle:@"提示"
         message:message
         delegate:self
         cancelButtonTitle:@"取消"
         otherButtonTitles:@"移动",nil];
        
        [alert show];
        
    }
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text = textField.text.trimmedString;
    self.kind.name = textField.text;
    [self updateTitle];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //scoll cell to visible
    self.activeField = textField;
}

#pragma mark - UIAlert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"移动"]) {
        [self.kind removeAllBills];
        self.kind.isIncome = [NSNumber numberWithBool:!self.kind.isIncome.boolValue];
    }else if([buttonTitle isEqualToString:@"取消"]){
        NSInteger item = [self.cellIdentifiers indexOfObject:@"isIncomeCell"];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

#pragma mark - UIAction Sheet Delegate Method


-(void)     actionSheet:(UIActionSheet *)actionSheet
   clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"删除" ]) {
        [self deleteKind];
    }
}

- (void)deleteKind
{
    [self.kind removeAllBills];
    [self.kind.managedObjectContext deleteObject:self.kind];
    [self dismissViewControllerAnimated:YES completion:^(){
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate saveContext];
    }];
    
}

#pragma mark - NSUndoManager


-(NSUndoManager *)undoManager
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (!managedObjectContext.undoManager) {
        managedObjectContext.undoManager = [[NSUndoManager alloc] init];
    }
    return managedObjectContext.undoManager;
}

#pragma mark - Properties Setter And Getter Method
- (NSMutableArray *)cellIdentifiers {
    if (!_cellIdentifiers) {
        _cellIdentifiers = [@[@"nameCell",
                              @"isIncomeCell",
                              @"colorCell",
                              @"inputcolorCell",
                              @"deleteCell"] mutableCopy];
        
    }
    return _cellIdentifiers;
}

@end
