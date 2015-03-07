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
#import "BillDetailCVC+CollectionView.h"
#import "MoneyCVCell.h"
#import "ImageCollectionViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>   // kUTTypeImage
#import "UINavigationController+Style.h"
#import "DefaultStyleController.h"


@interface BillDetailCVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic, strong) UIImage *image;


@end

@implementation BillDetailCVC




- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self undoManager] beginUndoGrouping];
    if (!self.bill)self.bill = [Bill billIsIncome:self.isIncome];
    self.isIncome = self.bill.isIncome.boolValue;
    self.title = self.isIncome ? @"收入": @"支出";
    
    NSArray *array = @[@"moneyCell",
                       @"kindCell",
                       @"dateCell",
                       @"locationCell",
                       @"notebodyCell",
                       @"deleteCell"];
    
    self.cellIdentifiers = [array mutableCopy];
    //self.datePickerIndexPath = [NSIndexPath indexPathForItem:3 inSection:0];

    // Do any additional setup after loading the view.
    //[self updateUI];
    [self configBarButtonItem];
    [self registerNotifications];
    
    UIImage *image = [UIImage imageNamed:@"Account details BG"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.collectionView.backgroundView = imageView;
}


-(void)registerNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // others can't edite  when TextFieldDidBeginEditing.

    [center addObserver:self
               selector:@selector(handleTextFieldDidBeginEditingNotification:)
                   name:kTextFieldDidBeginEditingNotification
                 object:nil];
    
    // set detailcell when locationSwitch change.

    
    [center addObserver:self
               selector:@selector(handleSetBillLocationIsOnNotification:)
                   name:kSetBillLocationIsOnNotification
                 object:nil];
    
    //keyboard notification ,scoll textfield to visible.
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//- (IBAction)takePhoto:(UIButton *)sender {
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
//        if ([availableMediaTypes containsObject:(NSString *)kUTTypeImage]) {
//            UIImagePickerController *uiipc = [[UIImagePickerController alloc] init];
//            uiipc.delegate = self;
//            uiipc.mediaTypes = @[(NSString *)kUTTypeImage];
//            uiipc.sourceType = UIImagePickerControllerSourceTypeCamera;
//            uiipc.allowsEditing = YES;
//            [self presentViewController:uiipc animated:YES completion:NULL];
//        }
//    }
//    
//}


//-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    UIImage *image = info[UIImagePickerControllerEditedImage];
//    if (!image) image = info[UIImagePickerControllerOriginalImage];
//    self.bill.image = image;
//    
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self showInputCellWithBaseCellIdentifier:@"photoCell"];
//        [self updateInputPhotoCell];
//    }];
//
//}







#pragma mark - NSUndoManager


-(NSUndoManager *)undoManager
{
    NSManagedObjectContext *managedObjectContext = [PubicVariable managedObjectContext];
    if (!managedObjectContext.undoManager) {
        managedObjectContext.undoManager = [[NSUndoManager alloc] init];
    }
    return managedObjectContext.undoManager;
}


-(void)configBarButtonItem
{
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" ✕"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(cancel:)];
    

    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"✓ "
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(done:)];
    
    UIFont *font = [UIFont systemFontOfSize:25];
    UIColor *titleColor = EBBackGround;
    NSDictionary *attrsDictionary = @{NSFontAttributeName: font,
                                      NSForegroundColorAttributeName: titleColor};
    [leftBarButtonItem setTitleTextAttributes:attrsDictionary forState:UIControlStateNormal];
    [rightBarButtonItem setTitleTextAttributes:attrsDictionary forState:UIControlStateNormal];

    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}


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


-(void)setIsUndo:(BOOL)isUndo
{
    [[self undoManager] endUndoGrouping];
    if (isUndo)[[self undoManager] undoNestedGroup];
}




@end
