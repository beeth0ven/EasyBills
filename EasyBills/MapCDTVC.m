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

@interface MapCDTVC ()



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
    [self setupFetchedResultsController];
//    [self performSelector:@selector(setupFetchedResultsController)
//               withObject:nil
//               afterDelay:0.5];


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
    annotationView.image = [UIImage pointerImageWithColor:color];
} 







@end
