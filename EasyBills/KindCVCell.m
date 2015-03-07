//
//  KindCollectionViewCell.m
//  EasyBills
//
//  Created by 罗 杰 on 11/12/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "KindCVCell.h"
#import "Kind+Create.h"

@implementation KindCVCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)setBill:(Bill *)bill
{
    _bill = bill;

    Kind *kind = bill.kind;
    self.detailLabel.text = kind.name;
}


-(void) handleSetBillDateNotification:(NSNotification *)paraNotification
{
    NSString *kindName = paraNotification.userInfo[kSetBillKindKey];
    self.detailLabel.text = kindName;
}


-(void)awakeFromNib
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(handleSetBillDateNotification:)
                   name:kSetBillKindNotification
                 object:nil];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
