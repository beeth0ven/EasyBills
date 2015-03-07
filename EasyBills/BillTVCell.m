//
//  BillTableViewCell.m
//  我的账本
//
//  Created by 罗 杰 on 9/22/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "BillTVCell.h"
#import "PNColor.h"
#import "PNChartLabel.h"
#import "PNBar.h"

@interface BillTVCell ()

@property (strong ,nonatomic) PNBar * bar;


@end

@implementation BillTVCell

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
    //[self updateUI];
    
}

-(void)updateUI
{
    
    if (self.bar) [self.bar removeFromSuperview];
    self.bar = [[PNBar alloc] initWithFrame:CGRectMake(15, //Bar X position
                                                       self.frame.size.height - 5, //Bar Y position
                                                       self.frame.size.width - 30, // Bar witdh
                                                       5)]; //Bar height
    self.bar.barRadius = 2.0f;
    self.bar.isHorizontal = YES;
    self.bar.backgroundColor = PNLightGrey;
    self.bar.barColor = [self.barColor colorWithAlphaComponent:0.5];
    self.bar.grade = self.grade;
    [self insertSubview:self.bar atIndex:0];
}


-(void)setGrade:(float)grade
{
    _grade = grade;
    [self updateUI];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
