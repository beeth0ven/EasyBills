//
//  WelcomeViewController.m
//  iCloud App
//
//  Created by iRare Media on 11/8/13.
//  Copyright (c) 2014 iRare Media. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[iCloud sharedCloud] setDelegate:self];
}
- (void)viewWillAppear:(BOOL)animated {
    // Call Super
    [super viewWillAppear:YES];
    [self.navigationController applyDefualtStyle:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    BOOL cloudAvailable = [[iCloud sharedCloud] checkCloudAvailability];
    if (cloudAvailable && [[NSUserDefaults standardUserDefaults] boolForKey:@"userCloudPref"] == YES) {
        self.startCloudButton.alpha = 1.0;
        self.setupCloudButton.alpha = 0.0;
        
        self.startCloudButton.userInteractionEnabled = YES;
        self.setupCloudButton.userInteractionEnabled = NO;
    } else {
        self.setupCloudButton.alpha = 1.0;
        self.startCloudButton.alpha = 0.0;
        
        self.setupCloudButton.userInteractionEnabled = YES;
        self.startCloudButton.userInteractionEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startCloud:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"iCloud Ready" object:self];
    }];
}

- (IBAction)setupCloud:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userCloudPref"] == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"iCloud Disabled", "")
                                                        message:NSLocalizedString( @"You have disabled iCloud for this app. Would you like to turn it on again?", "")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString( @"Cancel", "")
                                              otherButtonTitles:NSLocalizedString( @"Turn On iCloud", ""), nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Setup iCloud", "")
                                                        message:NSLocalizedString( @"iCloud is not available. Sign into an iCloud account on this device and check that this app has authority to use the iCloud.", "")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString( @"Ok", "")
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)iCloudAvailabilityDidChangeToState:(BOOL)cloudIsAvailable withUbiquityToken:(id)ubiquityToken withUbiquityContainer:(NSURL *)ubiquityContainer {
    if (cloudIsAvailable && [[NSUserDefaults standardUserDefaults] boolForKey:@"userCloudPref"] == YES) {
        self.startCloudButton.alpha = 1.0;
        self.setupCloudButton.alpha = 0.0;
        
        self.startCloudButton.userInteractionEnabled = YES;
        self.setupCloudButton.userInteractionEnabled = NO;
    } else {
        self.setupCloudButton.alpha = 1.0;
        self.startCloudButton.alpha = 0.0;
        
        self.setupCloudButton.userInteractionEnabled = YES;
        self.startCloudButton.userInteractionEnabled = NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:NSLocalizedString( @"Turn On iCloud", "")]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userCloudPref"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        BOOL cloudAvailable = [[iCloud sharedCloud] checkCloudAvailability];
        if (cloudAvailable && [[NSUserDefaults standardUserDefaults] boolForKey:@"userCloudPref"] == YES) {
            self.startCloudButton.alpha = 1.0;
            self.setupCloudButton.alpha = 0.0;
            
            self.startCloudButton.userInteractionEnabled = YES;
            self.setupCloudButton.userInteractionEnabled = NO;
        } else {
            self.setupCloudButton.alpha = 1.0;
            self.startCloudButton.alpha = 0.0;
            
            self.setupCloudButton.userInteractionEnabled = YES;
            self.startCloudButton.userInteractionEnabled = NO;
        }
    }
}

@end
