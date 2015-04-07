//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "DefaultStyleController.h"
#import "AppDelegate.h"
#import "Chameleon.h"

@interface SidebarViewController ()


@end

@implementation SidebarViewController {
    NSArray *menuItems;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"Account details BG"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.tableView.backgroundView = imageView;
    
}

//- (void)viewDidAppear:(BOOL)animated {
//    UITableViewCell *cell = [self tableView:self.tableView
//                       cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    UIImageView *imageView = (UIImageView *)[cell viewWithTag:5];
//
//    NSLog(@"TableView Width: %.0f",self.tableView.frame.size.width);
//    NSLog(@"Cell Width: %.0f",cell.frame.size.width);
//    NSLog(@"Center x: %.0f",imageView.center.x);
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    label.textColor = textColor;
    cell.backgroundColor = backgroundColor;
    
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    /*

    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    // Set the photo if it navigates to the PhotoView
    if ([segue.identifier isEqualToString:@"showPhoto"]) {
        PhotoViewController *photoController = (PhotoViewController*)segue.destinationViewController;
        NSString *photoFilename = [NSString stringWithFormat:@"%@_photo.jpg", [menuItems objectAtIndex:indexPath.row]];
        photoController.photoFilename = photoFilename;
    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
 
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
     */
    
}

@end
