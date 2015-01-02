//
//  KindTableViewCell.m
//  我的账本
//
//  Created by 罗 杰 on 9/10/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "KindTableViewCell.h"
#import "PNChartDelegate.h"
#import "PNChart.h"
#import "PubicVariable.h"
#import "Kind+Create.h"


@interface KindTableViewCell ()

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


@end


@implementation KindTableViewCell 

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
    [super awakeFromNib];
    // Initialization code
    self.fetchedResultsController =[Kind fetchedResultsControllerIsincome:self.bill.isIncome.boolValue];
    
    self.label.text = @"类别";
    self.textField.text = self.bill.kind.name;
    self.textField.textColor = PNFreshGreen;
    
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:self.bill.kind];
    self.pickerView = [[UIPickerView  alloc] initWithFrame:CGRectZero];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.pickerView selectRow:indexPath.item inComponent:indexPath.section animated:NO];
    self.pickerView.showsSelectionIndicator = YES;
    self.textField.inputView = self.pickerView;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark UIPickerViewDataSource Methods
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //NSLog(@"section:  %lu",(unsigned long)[[self.fetchedResultsController sections] count]);
    return [[self.fetchedResultsController sections] count];
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //NSLog(@"row:  %lu",(unsigned long)[[[self.fetchedResultsController sections] objectAtIndex:component] numberOfObjects]);
    return [[[self.fetchedResultsController sections] objectAtIndex:component] numberOfObjects];
    
    
}



#pragma mark UIPickerViewDelegate Methods

-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{

    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:component];
    Kind *kind = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return  kind.name;
}

-(void)pickerView:(UIPickerView *)pickerView
     didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:component];
    Kind *kind = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.bill.kind = kind;
    self.textField.text = kind.name;
}


@end
