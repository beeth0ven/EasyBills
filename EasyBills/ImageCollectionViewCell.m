//
//  ImageCollectionViewCell.m
//  EasyBills
//
//  Created by 罗 杰 on 11/29/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "ImageCollectionViewCell.h"
#import "MyCollectionViewController.h"


NSString *const kDeleteBillImageNotification = @"DeleteBillImageNotification";


@interface ImageCollectionViewCell()


@property (strong, nonatomic) UIActionSheet *actionSheet;


@end




@implementation ImageCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib
{
    UILongPressGestureRecognizer *longPress  = [[UILongPressGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(longPressTap:)];
    [self.imageButton addGestureRecognizer:longPress];
    
}

-(void)setBill:(Bill *)bill
{
    _bill = bill;
    [self.imageButton setImage:bill.image forState:UIControlStateNormal];
    
}


- (void)longPressTap:(UILongPressGestureRecognizer *)sender {
    if (self.bill.image) {
        if (!self.actionSheet) {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:@DELETE_BILL_IMAGE_ACTIONSHEET_TITLE
                                                                     delegate:(id <UIActionSheetDelegate>)self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:@"删除"
                                                            otherButtonTitles: nil];
            [self.actionSheet showInView:self.superview];
        }
        
    }
    
}



#pragma mark - UIActionSheetDelegate



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"删除" ]) {
        
        //delete bill image
        self.bill.image = nil;
        [UIView animateWithDuration:2 animations:^{
            self.imageButton.imageView.alpha = 0.5;
            self.imageButton.imageView.image = nil;
        }];
        [UIView animateWithDuration:2 animations:^{
            self.imageButton.imageView.alpha = 1.0;
        }];
        
        NSNotification *notification =
        [NSNotification
         notificationWithName:kDeleteBillImageNotification
         object:self
         userInfo:nil];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];

    }
    self.actionSheet = nil;
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
