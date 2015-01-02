//
//  NoteTableViewCell.m
//  我的账本
//
//  Created by 罗 杰 on 9/10/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "NoteTableViewCell.h"

@interface NoteTableViewCell()



@end


@implementation NoteTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    self.afTextView = [[AFTextView alloc]initWithFrame:CGRectMake(10, 0, 310, 232)];
    self.afTextView.font =[UIFont systemFontOfSize:17.0];
    self.afTextView.text = self.bill.note;
    self.afTextView.placeholder = @"特别说明...";
    self.afTextView.textColor = PNFreshGreen;
    self.afTextView.delegate = self;
    
    [self.contentView addSubview:self.afTextView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated

{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.bill.note = textView.text;
}


@end
