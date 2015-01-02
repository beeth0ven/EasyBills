//
//  KindePickerCollectionViewCell.m
//  EasyBills
//
//  Created by 罗 杰 on 11/14/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "KindePickerCollectionViewCell.h"
#import "Kind+Create.h"



NSString *const kSetBillKindNotification = @"SetBillKindNotification";
NSString *const kSetBillKindKey = @"SetKindDateKey";



@interface KindePickerCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


@end


@implementation KindePickerCollectionViewCell

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
    self.kindPickerView.dataSource = self;
    self.kindPickerView.delegate = self;
    self.kindPickerView.showsSelectionIndicator = YES;

}

-(void)setBill:(Bill *)bill
{
    _bill = bill;
    self.fetchedResultsController =[Kind fetchedResultsControllerIsincome:self.bill.isIncome.boolValue];
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:bill.kind];
    [self.kindPickerView selectRow:indexPath.item inComponent:indexPath.section animated:NO];
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
    
    NSNotification *notification =
    [NSNotification
     notificationWithName:kSetBillKindNotification
     object:self
     userInfo:@{kSetBillKindKey : kind.name}];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    self.bill.kind = kind;
    kind.visiteTime = [NSDate date];
    
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
