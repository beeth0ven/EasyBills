//
//  ListViewController.m
//  iCloud App
//
//  Created by iRare Media on 11/8/13.
//  Copyright (c) 2014 iRare Media. All rights reserved.
//

#import "ListViewController.h"
#import "AppDelegate.h"
#import "NSURL+Extension.h"
#import "UINavigationController+Style.h"
#import "DefaultStyleController.h"

@interface ListViewController ()<UIAlertViewDelegate> {
    NSMutableArray *fileNameList;
    NSMutableArray *fileObjectList;
    UIRefreshControl *refreshControl;
    NSString *fileText;
    NSString *fileTitle;
    BOOL isSeguePerforming;
    BOOL shouldPopViewControllerAnimated;
    NSDate *alertCreatedDate;
} @end

@implementation ListViewController

#pragma mark - View Lifecycle

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Setup iCloud
    [[iCloud sharedCloud] setDelegate:self]; // Set this if you plan to use the delegate
    [[iCloud sharedCloud] setVerboseLogging:YES]; // We want detailed feedback about what's going on with iCloud, this is OFF by default
    [[iCloud sharedCloud] setupiCloudDocumentSyncWithUbiquityContainer:nil]; // You must call this setup method before performing any document operations
    
    // Setup File List
    if (fileNameList == nil) fileNameList = [NSMutableArray array];
    if (fileObjectList == nil) fileObjectList = [NSMutableArray array];
    
    // Display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Create refresh control
    if (refreshControl == nil) refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshCloudList) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    // Subscribe to iCloud Ready Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCloudListAfterSetup) name:@"iCloud Ready" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    // Call Super
    [super viewWillAppear:YES];
    [self.navigationController applyDefualtStyle:NO];
    if (shouldPopViewControllerAnimated) {
        return;
    }
    // Present Welcome Screen
    if ([self appIsRunningForFirstTime] == YES || [[iCloud sharedCloud] checkCloudAvailability] == NO || [[NSUserDefaults standardUserDefaults] boolForKey:@"userCloudPref"] == NO) {
        if (!isSeguePerforming) {
            [self performSegueWithIdentifier:@"showWelcome" sender:self];
            isSeguePerforming = YES;
        }
        return;
    }
    
    /* --- Force iCloud Update ---
     This is done automatically when changes are made, but we want to make sure the view is always updated when presented */
    [[iCloud sharedCloud] updateFiles];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    isSeguePerforming = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)appIsRunningForFirstTime {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        // App already launched
        return NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
        return YES;
    }
}

#pragma mark - IBAction Method

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    shouldPopViewControllerAnimated = YES;
    [self dismissViewControllerAnimated:YES completion:^(){
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
}
#pragma mark - iCloud Methods

- (void)iCloudDidFinishInitializingWitUbiquityToken:(id)cloudToken withUbiquityContainer:(NSURL *)ubiquityContainer {
    NSLog(@"Ubiquity container initialized. You may proceed to perform document operations.");
}

- (void)iCloudAvailabilityDidChangeToState:(BOOL)cloudIsAvailable withUbiquityToken:(id)ubiquityToken withUbiquityContainer:(NSURL *)ubiquityContainer {
    if (!cloudIsAvailable) {
//        NSTimeInterval timeInterval = -[alertCreatedDate timeIntervalSinceNow];
//        if (!alertCreatedDate || timeInterval > 1) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iCloud Unavailable" message:@"iCloud is no longer available. Make sure that you are signed into a valid iCloud account." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
//            [alert show];
//            alertCreatedDate = [NSDate date];
//        }
        
        if (!isSeguePerforming) {
            isSeguePerforming = YES;
            [self performSegueWithIdentifier:@"showWelcome" sender:self];
        }
    }
}

- (void)iCloudFilesDidChange:(NSMutableArray *)files withNewFileNames:(NSMutableArray *)fileNames {
    // Get the query results
    NSLog(@"Files: %@", fileNames);
    
    fileNameList = fileNames; // A list of the file names
    fileObjectList = files; // A list of NSMetadata objects with detailed metadata
    
    [refreshControl endRefreshing];
    [self showEmptyBackgroundIfNeeded];
    [self.tableView reloadData];
}

- (void)iCloudFileUpdateDidEnd {
    
    [self showEmptyBackgroundIfNeeded];

}
- (void)refreshCloudList {
    [[iCloud sharedCloud] updateFiles];
}

- (void)refreshCloudListAfterSetup {
    // Reclaim delegate and then update files
    [[iCloud sharedCloud] setDelegate:self];
    [[iCloud sharedCloud] updateFiles];
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [fileNameList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *fileName = [fileNameList objectAtIndex:indexPath.row];
    
    NSNumber *filesize = [[iCloud sharedCloud] fileSize:fileName];
//    NSDate *updated = [[iCloud sharedCloud] fileModifiedDate:fileName];
    
    __block NSString *documentStateString = @"";
    [[iCloud sharedCloud] documentStateForFile:fileName completion:^(UIDocumentState *documentState, NSString *userReadableDocumentState, NSError *error) {
        if (!error) {
            documentStateString = userReadableDocumentState;
        }
    }];
    
    NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
    long long  byteCount = [filesize longLongValue];
    NSLog(@"%@", [formatter stringFromByteCount:byteCount]);
    
    NSString *fileDetail =[formatter stringFromByteCount:byteCount];

    
//    NSString *fileDetail = [NSString stringWithFormat:@"%@ bytes, updated %@.\n%@", filesize, [MHPrettyDate prettyDateFromDate:updated withFormat:MHPrettyDateFormatWithTime], documentStateString];
    
    // Configure the cell...
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button setTitle:@"HI" forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"CloseNavigationBarIcon"];
    [button setImage:image forState:UIControlStateNormal];
    button.tintColor = EBBackGround;
    button.frame = CGRectMake(0, 0, image.size.height, image.size.height);
    [button addTarget:self
               action:@selector(performDelete:)
     forControlEvents:UIControlEventTouchUpInside];

    cell.textLabel.text = fileName;
    cell.detailTextLabel.text = fileDetail;
    cell.accessoryView = button;
//    cell.detailTextLabel.numberOfLines = 2;
//    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
//     cell.imageView.image = [self iconForFile:fileName]; // Uncomment this line to enable file icons for each cell
    
    if ([documentStateString isEqualToString:@"Document is in conflict"]) {
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    
    return cell;
}

- (UIView *) superviewOfType:(Class)paramSuperviewClass
                     forView:(UIView *)paramView{
    
    if (paramView.superview != nil){
        if ([paramView.superview isKindOfClass:paramSuperviewClass]){
            return paramView.superview;
        } else {
            return [self superviewOfType:paramSuperviewClass
                                 forView:paramView.superview];
        }
    }
    
    return nil;
    
}

- (void) performDelete:(UIButton *)paramSender{
    
    /* Handle the tap event of the button */
     UITableViewCell *parentCell =
    (UITableViewCell *)[self superviewOfType:[UITableViewCell class]
                                     forView:paramSender];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:parentCell];
    if (indexPath) {
        [self deleteDocumentAtIndexPath:indexPath];
    }
    /* Now do something with the cell if you want to */
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title =  [NSString stringWithFormat:NSLocalizedString( @"Data missing", "")];;
    NSString *message = [NSString stringWithFormat:NSLocalizedString( @"Restored file will overwrite local file.All your local data will lose.", "")];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString( @"Cancel", "")
                                          otherButtonTitles:NSLocalizedString( @"Overwrite", ""), nil];
    alert.delegate = self;
    [alert show];
    
  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    
    if (indexPath) {
        if ([buttonTitle isEqualToString:NSLocalizedString( @"Overwrite", "")]) {
            NSString *fileName = [fileNameList objectAtIndex:indexPath.row];
            [self restoreBackupWithName:fileName];
        }
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    }

    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self deleteDocumentAtIndexPath:indexPath];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)deleteDocumentAtIndexPath:(NSIndexPath *)indexPath {
    [[iCloud sharedCloud] deleteDocumentWithName:[fileNameList objectAtIndex:indexPath.row] completion:^(NSError *error) {
        if (error) {
            NSLog(@"Error deleting document: %@", error);
        } else {
            [[iCloud sharedCloud] updateFiles];
            
            [fileObjectList removeObjectAtIndex:indexPath.row];
            [fileNameList removeObjectAtIndex:indexPath.row];
            
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self showEmptyBackgroundIfNeeded];
        }
    }];
}

#pragma mark - BACKUP
- (IBAction)backup:(id)sender {

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    [appDelegate.managedObjectContext performBlock:^{
        // Save all contexts
        [appDelegate saveContext];
        //        [cdh.sourceContext performBlockAndWait:^{[cdh.sourceContext save:nil];}];
        //        [cdh.importContext performBlockAndWait:^{[cdh.importContext save:nil];}];
        //        [cdh.context performBlockAndWait:^{[cdh.context save:nil];}];
        //        [cdh.parentContext performBlockAndWait:^{[cdh.parentContext save:nil];}];
        //
        NSLog(@"Creating a dated backup of the Stores directory...");
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"[yyyy-MM-dd] hh.mm a"];
        NSString *date = [formatter stringFromDate:[NSDate date]];
        NSString *zipFileName =
        [NSString stringWithFormat:@"%@.zip", date];
        NSURL *zipFile =
        [NSURL zipFolderAtURL:[appDelegate applicationStoresDirectory]
              withZipfileName:zipFileName];
        NSData *fileData = [NSData dataWithContentsOfURL:zipFile];
        
        if ([[iCloud sharedCloud] doesFileExistInCloud:zipFileName]) {
            NSString *title =  [NSString stringWithFormat:NSLocalizedString( @"Success", "")];;
            NSString *message = [NSString stringWithFormat:NSLocalizedString( @"A backup file alredy exist.", "")];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString( @"Ok", ""), nil];
            [alert show];
        } else {
            [[iCloud sharedCloud] saveAndCloseDocumentWithName:zipFileName withContent:fileData completion:^(UIDocument *cloudDocument, NSData *documentData, NSError *error) {
                if (!error) {
                    NSLog(@"iCloud Document, %@, saved with data: %@", cloudDocument.fileURL.lastPathComponent, [[NSString alloc] initWithData:documentData encoding:NSUTF8StringEncoding]);
                    //                [self alertSuccess:YES];
                    
                } else {
                    NSLog(@"iCloud Document save error: %@", error);
                }
                [NSURL deleteFileAtURL:zipFile];
            }];

        }
        
        
        
        
        
        
        //        NSLog(@"Copying the backup zip to Dropbox...");
        //        DBPath *zipFileInDropbox =
        //        [[DBPath root] childPath:zipFile.lastPathComponent];
        //        if ([DropboxHelper fileExistsAtDropboxPath:zipFileInDropbox]) {
        //            NSLog(@"Removing existing backup with same name...");
        //            [DropboxHelper deleteFileAtDropboxPath:zipFileInDropbox];
        //        }
        //        [DropboxHelper copyFileAtURL:zipFile toDropboxPath:zipFileInDropbox];
        //        NSLog(@"Deleting the local backup zip...");
        //        [DropboxHelper deleteFileAtURL:zipFile];
        //        [DropboxHelper listFilesAtDropboxPath:[DBPath root]];
    }];
    //    } else {
    //        [self alertSuccess:NO];
    //    }
    
    
    
    
}
- (void)alertSuccess:(BOOL)success {
    NSString *title;
    NSString *message;
    if (success) {
        title = [NSString stringWithFormat:NSLocalizedString( @"Success", "")];
        message = [NSString stringWithFormat:NSLocalizedString( @"A backup has been created.", "")];
    } else {
        title = [NSString stringWithFormat:NSLocalizedString( @"Fail", "")];
        message = NSLocalizedString( @"Something went wrong when create backups.", "");
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString( @"Ok", ""), nil];
    [alert show];
}


- (void)restoreBackupWithName:(NSString *)fileName {
    [[iCloud sharedCloud] retrieveCloudDocumentWithName:fileName completion:^(UIDocument *cloudDocument, NSData *documentData, NSError *error) {
        if (!error) {
            //            fileText = [[NSString alloc] initWithData:documentData encoding:NSUTF8StringEncoding];
            //            fileTitle = cloudDocument.fileURL.lastPathComponent;
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            //            [appDelegate saveContext];
            [appDelegate.managedObjectContext performBlock:^{
                //                NSLog(@"before       size :%lu",(unsigned long)[NSData dataWithContentsOfURL:[appDelegate storeURL]].length);
                //
                //                NSLog(@"documentData size :%lu",(unsigned long)documentData.length);
                
                NSURL  *zipFileInSandbox =
                [[[appDelegate applicationStoresDirectory] URLByDeletingLastPathComponent]
                 URLByAppendingPathComponent:fileName];
                NSURL  *unzipFolder =
                [[[appDelegate applicationStoresDirectory] URLByDeletingLastPathComponent]
                 URLByAppendingPathComponent:@"Stores_New"];
                NSURL *oldBackupURL =
                [[[appDelegate applicationStoresDirectory] URLByDeletingLastPathComponent]
                 URLByAppendingPathComponent:@"Stores_Old"];
                
                
                if ([documentData writeToURL:zipFileInSandbox atomically:YES]) {
                    [NSURL unzipFileAtURL:zipFileInSandbox toURL:unzipFolder];
                    
                    if ([[NSFileManager defaultManager] fileExistsAtPath:unzipFolder.path]) {
                        [NSURL deleteFileAtURL:oldBackupURL];
                        [NSURL renameLastPathComponentOfURL:[appDelegate applicationStoresDirectory]
                                                     toName:@"Stores_Old"];
                        [NSURL renameLastPathComponentOfURL:unzipFolder
                                                     toName:@"Stores"];
                        if ([appDelegate reloadStore]) {
                            [NSURL deleteFileAtURL:oldBackupURL];
                            UIAlertView *failAlert = [[UIAlertView alloc]
                                                      initWithTitle:NSLocalizedString( @"Restore Complete!", "")
                                                      message:NSLocalizedString( @"All data has been restored from the selected backup", "")
                                                      delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:NSLocalizedString( @"Ok", ""), nil];
                            [failAlert show];
                            
                        } else { // Attempt Recovery
                            [NSURL renameLastPathComponentOfURL:[appDelegate applicationStoresDirectory]
                                                         toName:@"Stores_FailedRestore"];
                            [NSURL renameLastPathComponentOfURL:oldBackupURL
                                                         toName:@"Stores"];
                            [NSURL deleteFileAtURL:oldBackupURL];
                            //                            if (![appDelegate reloadStore]) {
                            UIAlertView *failAlert = [[UIAlertView alloc]
                                                      initWithTitle:NSLocalizedString( @"Failed to Restore", "")
                                                      message:NSLocalizedString( @"Please try to restore from another backup" , "")
                                                      delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:NSLocalizedString( @"Close", ""), nil];
                            [failAlert show];
                            //                            }
                        }
                    }
                    
                    //                    NSLog(@"after        size :%lu",(unsigned long)[NSData dataWithContentsOfURL:[appDelegate storeURL]].length);
                    
                }
            }];
            
            
        } else {
            NSLog(@"Error retrieveing document: %@", error);
        }
    }];
    
}


- (void)showEmptyBackgroundIfNeeded {
    //If there is no data, Display a label instead.
//        [UIView transitionWithView:self.tableView
//                          duration:0.5
//                           options:UIViewAnimationOptionTransitionCrossDissolve
//                        animations:^{
                            if (fileNameList.count == 0){
//                                self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                                self.tableView.backgroundView = [self emptyBackgroundView];
                            } else {
                                self.tableView.backgroundView = nil;
//                                self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                            }
//                        } completion:nil];
    
}

- (UIView *)emptyBackgroundView {
    UIView *result = [[UIView alloc] initWithFrame:self.tableView.bounds];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"";//NSLocalizedString( @"Empty", "");
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textColor = EBBackGround;
    [label sizeToFit];
    label.center = CGPointMake(self.tableView.bounds.size.width  / 2,
                               self.tableView.bounds.size.height / 2 );
    [result addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = [UIImage imageNamed:@"DrawerIcon"];
    [imageView sizeToFit];
    imageView.tintColor = EBBackGround;
    imageView.center = CGPointMake(self.tableView.bounds.size.width  / 2,
                                   self.tableView.bounds.size.height / 2 - 50);
    [result addSubview:imageView];
    return result;
}

//#pragma mark - Navigation

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // Make sure your segue name in storyboard is the same as this line
//    if ([[segue identifier] isEqualToString:@"documentView"]) {
//        // Get reference to the destination view controller
//        DocumentViewController *viewController = [segue destinationViewController];
//        
//        // Pass any objects to the view controller here, like...
//        [viewController setFileText:fileText];
//        [viewController setFileName:fileTitle];
//    } else if ([[segue identifier] isEqualToString:@"newDocument"]) {
//        // Get reference to the destination view controller
//        DocumentViewController *viewController = [segue destinationViewController];
//        
//        // Pass any objects to the view controller here, like...
//        [viewController setFileText:@"Document text"];
//        [viewController setFileName:@""];
//    }
//}

//#pragma mark - Goodies
//
//- (UIImage *)iconForFile:(NSString *)documentName {
//    UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:[[[iCloud sharedCloud] ubiquitousDocumentsDirectoryURL] URLByAppendingPathComponent:documentName]];
//    if (controller) {
//        return [controller.icons lastObject]; // arbitrary selection--gives you the largest icon in this case
//    }
//    
//    return nil;
//}

@end
