//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "DefaultStyleController.h"
#import "AppDelegate.h"
#import "Chameleon.h"
#import "UIViewController+Extension.h"
#import "UINavigationController+Style.h"

@interface SidebarViewController ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

@end

@implementation SidebarViewController {
    NSArray *menuItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBackgroundImage];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    //title cell can't be selected
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //row 1 is the defualt selected
    BOOL selected =
    (indexPath.row == 1)?
    YES :
    NO;
    
    [self setCell:cell selected:selected];

    return cell;
}


#pragma mark - Table view data delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)selectedRowIndexPath
{
    if (selectedRowIndexPath.row > 0) {
        //update the all cell selected state
        for (UITableViewCell *cell in self.tableView.visibleCells) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            
            BOOL selected =
            (indexPath.row == selectedRowIndexPath.row)?
            YES :
            NO;
            
            [self setCell:cell selected:selected];
        }
        
        //choose the center controller
        NSInteger index = selectedRowIndexPath.row - 1;
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        UINavigationController *frontViewController = [appDelegate.viewControllers objectAtIndex:index];
        

        
//        [frontViewController.view addSubview:self.visualEffectView];
//        [frontViewController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//        [frontViewController.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
        
        //Change front view
        [self.revealViewController
         setFrontViewController:frontViewController];
        
        [self.revealViewController
         setFrontViewPosition:FrontViewPositionLeft
         animated:YES];


    }
    
}



- (void)showFrontViewController:(UIViewController *)frontViewController{
    
    [self.revealViewController
     setFrontViewController:frontViewController];
    
    [self.revealViewController
     setFrontViewPosition:FrontViewPositionLeft
     animated:YES];
    
}

- (void)setCell:(UITableViewCell *)cell
       selected:(BOOL)selected{
    
    UIImageView *cellImageView  = (UIImageView *)   [cell viewWithTag:0];
    UILabel     *label          = (UILabel *)       [cell viewWithTag:1];
    
    BOOL canConfigureImageView = NO;

    if (cellImageView != nil) {
        canConfigureImageView = YES;
    }

    
    UIColor *textColor = EBBackGround;
    UIColor *backgroundColor = [UIColor clearColor];

    if (selected == YES) {
        textColor = [UIColor whiteColor];
        backgroundColor = EBBackGround;
    }
    
    if (canConfigureImageView)
        cellImageView.tintColor = textColor;
    label.font = [label.font fontWithSize:24.0];
    label.textColor = textColor;
    cell.backgroundColor = backgroundColor;
    
}

#pragma mark - SWReveal View Controller Delegate



- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
    
    UINavigationController *frontViewController = (UINavigationController *)revealController.frontViewController;
    switch (position) {
        case FrontViewPositionLeft:{
            
            if (self.visualEffectView.superview) {
                [self.visualEffectView removeFromSuperview];
                [frontViewController.view addSubview:self.visualEffectView];
            }
            
            [frontViewController.view addGestureRecognizer:revealController.panGestureRecognizer];
            [frontViewController.view addGestureRecognizer:revealController.tapGestureRecognizer];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.visualEffectView.alpha = 0.0;
            } completion:^(BOOL finished) {
                if (self.visualEffectView.superview) {
                    [self.visualEffectView removeFromSuperview];
                }
            }];
            
            
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            [frontViewController updateStatusBar];
            
            break;
        }
        case FrontViewPositionRight:{
            [frontViewController.view addSubview:self.visualEffectView];
            [UIView animateWithDuration:0.3 animations:^{
                self.visualEffectView.alpha = 1.0;
            }];
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

            break;
        }
        default: {
            break;
        }
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);

    
}

- (BOOL)revealControllerPanGestureShouldBegin:(SWRevealViewController *)revealController {
    FrontViewPosition position = self.revealViewController.frontViewPosition;
    BOOL result = NO;
    switch (position) {
        case FrontViewPositionLeft:{
            result = NO;
            break;
        }
        case FrontViewPositionRight:{
            result = YES;
            break;
        }
        default: {
            break;
        }
    }
    return result;
}


- (NSString*)stringFromFrontViewPosition:(FrontViewPosition)position
{
    NSString *str = nil;
    if ( position == FrontViewPositionLeft ) str = @"FrontViewPositionLeft";
    if ( position == FrontViewPositionRight ) str = @"FrontViewPositionRight";
    if ( position == FrontViewPositionRightMost ) str = @"FrontViewPositionRightMost";
    if ( position == FrontViewPositionRightMostRemoved ) str = @"FrontViewPositionRightMostRemoved";
    return str;
}

#pragma mark - Property Setter And Getter Method

- (UIView *)maskView {
    UIView *frontView = self.revealViewController.frontViewController.view;
    CGRect bounds = frontView.bounds;
    if (_maskView) {
        _maskView.frame = bounds;
        return _maskView;
    }
    _maskView = [[UIView alloc] initWithFrame:bounds];
    _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _maskView.alpha = 0;
    return _maskView;
}


- (UIVisualEffectView *)visualEffectView {
    UIView *frontView = self.revealViewController.frontViewController.view;
    CGRect bounds = frontView.bounds;
    if (_visualEffectView) {
        _visualEffectView.frame = bounds;
        return _visualEffectView;
    }
    _visualEffectView = [[UIVisualEffectView alloc]
                         initWithEffect:[UIBlurEffect effectWithStyle: UIBlurEffectStyleDark]];
    _visualEffectView.frame = bounds;
    _visualEffectView.alpha = 0;
    return _visualEffectView;
}


@end
