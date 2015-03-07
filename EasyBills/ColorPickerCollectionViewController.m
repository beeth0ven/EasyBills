//
//  ColorPickerCollectionViewController.m
//  EasyBills
//
//  Created by 罗 杰 on 12/26/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "ColorPickerCollectionViewController.h"
#import "UINavigationController+Style.h"

@interface ColorPickerCollectionViewController ()

@property (strong ,nonatomic) NSArray *colors;
@property (strong ,nonatomic) NSIndexPath *selectedCellIndexpath;

@end

@implementation ColorPickerCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.colors = @[@"cantaloupe",@"honeydew",@"spindrift",@"strawberry",@"lavender",
                    @"carnation",@"salmon",@"banana",@"tangerine",@"orchid",
                    @"iron",@"magnesium",@"mocha",@"ocean",@"eggplant",
                    @"maroon",@"asparagus",@"clover",@"teal",@"plum"];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController applyDefualtStyle:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.layer.cornerRadius = cell.frame.size.width / 2;
    return cell;
}



-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (UICollectionViewCell *cell in collectionView.visibleCells) {
        NSIndexPath *cellIndexpath = [collectionView indexPathForCell:cell];
        float cornerRadius = (indexPath.item == cellIndexpath.item) ? cell.frame.size.width / 2 : 0;
        
        if (cell.layer.cornerRadius != cornerRadius) {
            [UIView transitionWithView:cell
                              duration:1
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
-(void)setSelectedCellIndexpath:(NSIndexPath *)selectedCellIndexpath
{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:_selectedCellIndexpath];
    cell.layer.cornerRadius = 0;
    
    UICollectionViewCell *newCell = [self.collectionView cellForItemAtIndexPath:selectedCellIndexpath];
    cell.layer.cornerRadius = newCell.frame.size.width / 2;
    
    _selectedCellIndexpath = selectedCellIndexpath;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
