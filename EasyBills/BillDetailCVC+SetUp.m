//
//  BillDetailCVC+SetUp.m
//  EasyBills
//
//  Created by luojie on 3/26/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "BillDetailCVC+SetUp.h"
#import "BillDetailCVC+CLLocation.h"
#import "BillDetailCVC+Observer.h"
#import "CustomDismissAnimationController.h"

@implementation BillDetailCVC (SetUp)



#pragma mark - SetUp Method

- (void)setUp {
    
    [[self undoManager] beginUndoGrouping];
    if (!self.bill){
        //         The bill is created, not passed.
        self.bill = [Bill billIsIncome:self.isIncome];
        
        //         The location state is inherit from last bill.
        //         If this is the unique bill(last bill don't exist), Then the state is On, by defult.
        if ([self isBillCreateUnique] || [self lastBillLocationStateIsOn]) {
            self.bill.locationIsOn = [NSNumber numberWithBool:YES];
            [self requestGetCurentLocation];
        }
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

- (void)configTitleColor {
    UIColor *color = self.isIncome ? EBBlue: PNRed;
    NSMutableDictionary *titleTextAttributes = [self.navigationController.navigationBar.titleTextAttributes mutableCopy];
    [titleTextAttributes setValue:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes  = titleTextAttributes;
}

-(void)setIsUndo:(BOOL)isUndo
{
    [[self undoManager] endUndoGrouping];
    if (isUndo)[[self undoManager] undoNestedGroup];
}

- (NSUndoManager *)undoManager
{
    NSManagedObjectContext *managedObjectContext = [PubicVariable managedObjectContext];
    if (!managedObjectContext.undoManager) {
        managedObjectContext.undoManager = [[NSUndoManager alloc] init];
    }
    return managedObjectContext.undoManager;
}

#pragma mark - IBAction Method

- (IBAction)done:(UIBarButtonItem *)sender
{
    [self.view endEditing:YES];
    if (self.bill.money.floatValue != 0) {
        // Money != 0
        [self setIsUndo:NO];
        
        UINavigationController *navigationController = self.navigationController;
        id<UIViewControllerTransitioningDelegate> transitioningDelegate = navigationController.transitioningDelegate;
        id<UIViewControllerAnimatedTransitioning> animatedTransitioning = [transitioningDelegate animationControllerForDismissedController:nil];
        if ([animatedTransitioning isKindOfClass:[CustomDismissAnimationController class]]) {
            CustomDismissAnimationController *customDismissAnimationController = (CustomDismissAnimationController *)animatedTransitioning;
            customDismissAnimationController.customDismissAnimationControllerEndPointType = CustomDismissAnimationControllerEndPointTypeSum;
        }
        
        [self dismissViewControllerAnimated:YES completion:^(){
            // [PubicVariable saveContext];
        }];
    }else{
        // Money = 0
        self.navigationItem.prompt = @"金额不能为零";
    }
    
    
}

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^(){
        [self setIsUndo:YES];
    }];
    
    
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




@end
