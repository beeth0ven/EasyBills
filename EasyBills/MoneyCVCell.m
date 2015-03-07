//
//  MoneyCollectionViewCell.m
//  EasyBills
//
//  Created by 罗 杰 on 11/12/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "MoneyCVCell.h"

NSString *const kTextFieldDidBeginEditingNotification = @"TextFieldDidBeginEditingNotification";


@interface MoneyCVCell ()

@property (strong, nonatomic) UIToolbar *keyboardToolBar;


@end



@implementation MoneyCVCell

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

-(void)setBill:(Bill *)bill
{
    _bill = bill;
    self.textField.text = bill.money.floatValue != 0 ? [NSString stringWithFormat:@"%d",abs(bill.money.floatValue)] : nil;
    
    
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    float sum = self.textField.text.floatValue;
    NSLog(@"sum:  %f",sum);
    
    if (!self.bill.isIncome.boolValue) sum = sum * -1;
    NSNumber *sumNumber =[NSNumber numberWithFloat: sum];
    if (![self.bill.money isEqualToNumber:sumNumber]) self.bill.money = sumNumber;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSNotification *notification =
    [NSNotification
     notificationWithName:kTextFieldDidBeginEditingNotification
     object:self
     userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    //textField.inputAccessoryView = self.keyboardToolBar;
    return YES;
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
