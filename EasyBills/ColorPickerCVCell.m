//
//  ColorPickerCVCell.m
//  EasyBills
//
//  Created by 罗 杰 on 12/27/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "ColorPickerCVCell.h"


@interface ColorPickerCVCell()

@property (strong ,nonatomic) NSArray *colors;
@property (strong ,nonatomic) NSIndexPath *selectedCellIndexpath;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end


@implementation ColorPickerCVCell

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
    [super awakeFromNib];
    self.colors = @[@"cantaloupe",@"honeydew",@"spindrift",@"strawberry",@"lavender",
                    @"carnation",@"salmon",@"banana",@"tangerine",@"orchid",
                    @"iron",@"magnesium",@"mocha",@"ocean",@"eggplant",
                    @"maroon",@"asparagus",@"clover",@"teal",@"plum"];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.colors.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = [self.colors objectAtIndex:indexPath.item];
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    return cell;
}



-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (UICollectionViewCell *cell in collectionView.visibleCells) {
        NSIndexPath *cellIndexpath = [collectionView indexPathForCell:cell];
        float cornerRadius = (indexPath.item == cellIndexpath.item) ? cell.frame.size.width / 2 : 0;
        
        if (cell.layer.cornerRadius != cornerRadius) {
            [UIView transitionWithView:cell
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                cell.layer.cornerRadius = cornerRadius;
                            }
                            completion:nil];
            
        }
        
        
    }
    self.selectedCellIndexpath = indexPath;
    
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
