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
#import "DefaultStyleController.h"
#import "UIImage+Extension.h"
#import "LoadingStatus.h"

@interface MapCDTVC ()

@property (nonatomic, strong) LoadingStatus *loadingStatus;

@end

@implementation MapCDTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupMenuButton];
    self.mapView.delegate = self;
    [self setupFetchedResultsController];
    [self.view addSubview:self.loadingStatus];



}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.navigationController applyDefualtStyle:YES];

}

-(void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];



}

- (void)setupFetchedResultsController
{
    // add a temporary loading view
    
    if (!self.fetchedResultsController) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bill"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        request.predicate = [NSPredicate predicateWithFormat:@"locationIsOn == YES"];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.fetchedResultsController = fetchedResultsController;
                [self mapViewReloadData];

            });
        });

    }
}





#pragma mark - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *view = nil;
    
    if (annotation != mapView.userLocation) {
        static NSString *reuseId = @"billAnnotation";
        view = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
        if (!view) {
            view = [self viewInitForAnnotation:annotation withIdentifier:reuseId];
        }
        view.annotation = annotation;
        if ([annotation isKindOfClass:[Bill class]]) {
            Bill *bill = annotation;
            [self configAnnotationView:view useBill:bill];
        }
    }
    
    
    return view;
}

- (MKAnnotationView *)viewInitForAnnotation:(id<MKAnnotation>)annotation
                         withIdentifier:(NSString *)identifier{
    
    MKAnnotationView *result = nil;
    result = [[MKAnnotationView alloc]
              initWithAnnotation:annotation
              reuseIdentifier:identifier];
    
    result.canShowCallout = YES;
    result.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return result;
}

- (void)configAnnotationView:(MKAnnotationView *)annotationView
                     useBill:(Bill *)bill{
    
    UIColor *color = bill.kind.color;
//    bill.isIncome.boolValue ? EBBlue : EBBackGround;
    annotationView.tintColor = bill.isIncome.boolValue ? EBBlue : PNRed;
    annotationView.image = [UIImage pointerImageWithColor:color];
} 

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    if (self.loadingStatus.superview) {
        [self.loadingStatus removeFromSuperviewWithFade];
    }

}



- (LoadingStatus *)loadingStatus {
    if (!_loadingStatus) {
        _loadingStatus = [LoadingStatus defaultLoadingStatusWithWidth:CGRectGetWidth(self.view.frame)];
    }
    return _loadingStatus;
}




@end
