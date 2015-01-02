//
//  KindNameTableViewCell.m
//  EasyBills
//
//  Created by 罗 杰 on 12/11/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "KindNameTableViewCell.h"

@implementation KindNameTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setKind:(Kind *)kind
{
    _kind = kind;
    self.textField.text = kind.name;
}


- (void)awakeFromNib
{
    // Initialization code
    self.textField.delegate = self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark UITextField Delegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.kind.name = textField.text;
}

/*
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSNotification *notification =
    [NSNotification
     notificationWithName:kTextFieldDidBeginEditingNotification
     object:self
     userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

*/
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    BOOL result;
    
    NSString *name = textField.text;
    
    if (name.length > 0) {
        if ([Kind kindIsExistedWithName:name isIncome:self.kind.isIncome.boolValue] &&![name isEqualToString:self.kind.name]) {
            // the same two name
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"存在同名类别"
                                                              delegate:nil
                                                     cancelButtonTitle:@"确认"
                                                     otherButtonTitles:nil];
            [alertView show];
            result = NO;
        }else{
            result = YES;
        }
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"请输入一个名字"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确认"
                                                 otherButtonTitles:nil];
        [alertView show];
        result = NO;
    }
    
    
    return result;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    //textField.inputAccessoryView = self.keyboardToolBar;
    return YES;
}



@end
