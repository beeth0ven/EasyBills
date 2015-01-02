//
//  NotbodyCollectionViewCell.m
//  EasyBills
//
//  Created by 罗 杰 on 11/12/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "NotbodyCollectionViewCell.h"
#import "MoneyCollectionViewCell.h"
#import "MyCollectionViewController.h"
#import "PubicVariable.h"

@interface NotbodyCollectionViewCell ()

@property (strong, nonatomic) UIToolbar *keyboardToolBar;

@property (weak ,nonatomic) UICollectionView *relateCollectionView;

@end


@implementation NotbodyCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    self.textField.delegate = self;
    self.textField.inputAccessoryView = self.keyboardToolBar;
}

-(UICollectionView *)relateCollectionView
{
    if (!_relateCollectionView) {
        id view = [self superview];
        while (view && ![view isKindOfClass:[UICollectionView class]]) {
            view = [view superview];
        }
        _relateCollectionView = view;
    }
    
    return _relateCollectionView;
    
}


-(void)setBill:(Bill *)bill
{
    _bill = bill;
    self.textField.text = bill.note;
    
    
}


-(UIToolbar *)keyboardToolBar
{
    if (!_keyboardToolBar) {
        _keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 35)];
        
        _keyboardToolBar.barStyle = UIBarStyleDefault;
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *doneBarButton =[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(resignKeyboard)];
        [doneBarButton setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}
                                     forState:UIControlStateNormal];
        
        [_keyboardToolBar setItems:[NSArray arrayWithObjects:
                                    flex,
                                    doneBarButton,
                                    nil]];
        
        
    }
    return _keyboardToolBar;
}

-(void)resignKeyboard
{
    [self endEditing:YES];
}




#pragma mark UITextField Delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    //textField.inputAccessoryView = self.keyboardToolBar;
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSNotification *notification =
    [NSNotification
     notificationWithName:kTextFieldDidBeginEditingNotification
     object:self
     userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    //scoll cell to visible
    PubicVariable *pubicVariable = [PubicVariable pubicVariable];
    pubicVariable.activeField = textField;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.bill.note = textField.text;
    //scoll cell to visible
    PubicVariable *pubicVariable = [PubicVariable pubicVariable];
    pubicVariable.activeField = nil;
  
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
