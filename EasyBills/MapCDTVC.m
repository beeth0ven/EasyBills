//
//  MapCDTVC.m
//  EasyBills
//
//  Created by 罗 杰 on 10/24/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "MapCDTVC.h"
#import "Bill+MKAnnotation.h"
#import "SWRevealViewController.h"
#import "UIViewController+Extension.h"
#import "UINavigationController+Style.h"
#import "BillDetailCVC.h"

@interface MapCDTVC ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

@implementation MapCDTVC

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
    [self setupMenuButton];

    self.mapView.delegate = self;
    [self performSelector:@selector(setupFetchedResultsController) withObject:nil afterDelay:0.5];


}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController applyDefualtStyle:YES];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

}

-(void) setupFetchedResultsController
{
    if (!self.fetchedResultsController) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bill"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        request.predicate = nil;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[PubicVariable managedObjectContext]
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






#pragma mark - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *view = nil;
    
    if (!(annotation == mapView.userLocation)) {
        static NSString *reuseId = @"billAnnotation";
        view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
        if (!view) {
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
            view.canShowCallout = YES;
            view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        view.annotation = annotation;
        if ([annotation isKindOfClass:[Bill class]]) {
            Bill *bill = annotation;
            view.pinColor = bill.isIncome.boolValue ? MKPinAnnotationColorGreen : MKPinAnnotationColorRed;
            
        }
    }
    
    
    
    return view;
}




 #pragma mark - CLLocationManagerDelegate
 
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
}

-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"mapShowBill" sender:view];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[MKAnnotationView class]]) {
        [self prepareViewController:segue.destinationViewController
                           forSegue:segue.identifier
                   toShowAnnotation:((MKAnnotationView *)sender).annotation];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void) prepareViewController:(UIViewController *)viewController
                     forSegue:(NSString *)segueIdentifier
                   toShowAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[Bill class]]) {
        Bill *bill = annotation;
        if ([segueIdentifier isEqualToString:@"mapShowBill"]) {
            if ([viewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navigationController = (UINavigationController *)viewController;
                if ([navigationController.topViewController isKindOfClass:[BillDetailCVC class]]) {
                    BillDetailCVC *myCollectionViewController = (BillDetailCVC *)navigationController.topViewController;
                    myCollectionViewController.bill = bill;
                }
                
            }
        }
        
    }
    
}


@end
