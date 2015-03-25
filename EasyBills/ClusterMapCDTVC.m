//
//  ClusterMapCDTVC.m
//  EasyBills
//
//  Created by luojie on 3/24/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "ClusterMapCDTVC.h"
#import "Bill+MKAnnotation.h"
#import "BillDetailCVC.h"
#import "BillCDTVC.h"

@interface ClusterMapCDTVC ()

@property (nonatomic, strong) MKMapView *allAnnotationsMapView;

@end


@implementation ClusterMapCDTVC

- (void)populateWorldWithAllBillAnnotations {
    
    [_allAnnotationsMapView addAnnotations:self.fetchedResultsController.fetchedObjects];
    [self updateVisibleAnnotations];
    
}


- (id<MKAnnotation>)annotationInGrid:(MKMapRect)gridMapRect
                    usingAnnotations:(NSSet *)annotations {
    //Param annotations is the all annotations in grid.
    //visibleAnnotationsInBucket is the visible annotations in grid.
    //annotationsForGridSet is the set of one (or zero) annotation visible in grid.
    NSSet *visibleAnnotationsInBucket = [self.mapView annotationsInMapRect:gridMapRect];
    NSSet *annotationsForGridSet = [annotations objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        BOOL returnValue = ([visibleAnnotationsInBucket containsObject:obj]);
        if (returnValue) {
            *stop = YES;
        }
        return returnValue;
    }];
    
    if (annotationsForGridSet.count != 0) {
        return [annotationsForGridSet anyObject];
    }
    
    //If there is no visible annotation in grid.
    //Then choose the one closest to the center to show
    MKMapPoint centerMapPoint = MKMapPointMake(MKMapRectGetMidX(gridMapRect), MKMapRectGetMidY(gridMapRect));
    NSArray *sortedAnnotations =
    [[annotations allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        MKMapPoint mapPoint1 = MKMapPointForCoordinate(((id<MKAnnotation>)obj1).coordinate);
        MKMapPoint mapPoint2 = MKMapPointForCoordinate(((id<MKAnnotation>)obj2).coordinate);
        
        CLLocationDistance distance1 = MKMetersBetweenMapPoints(mapPoint1, centerMapPoint);
        CLLocationDistance distance2 = MKMetersBetweenMapPoints(mapPoint2, centerMapPoint);
        
        if (distance1 < distance2) {
            return NSOrderedAscending;
        }else if(distance1 > distance2){
            return NSOrderedDescending;
        }else{
            return NSOrderedSame;
        }
        
    }];
    
    return sortedAnnotations.firstObject;
}

- (void)updateVisibleAnnotations {
    
    static float marginFactor = 2.0;
    static float bucketSize = 60.0;
    
    MKMapRect visibleMapRect = [self.mapView visibleMapRect];
    MKMapRect adjustedVisibleMapRect =
    MKMapRectInset(visibleMapRect,
                   -marginFactor * visibleMapRect.size.width,
                   -marginFactor * visibleMapRect.size.height);
    
    CLLocationCoordinate2D leftCoordinate = [self.mapView convertPoint:CGPointZero
                                                 toCoordinateFromView:self.view];
    
    CLLocationCoordinate2D rightCoordinate = [self.mapView convertPoint:CGPointMake(bucketSize,
                                                                                    0)
                                                   toCoordinateFromView:self.view];
   
    double gridSize = MKMapPointForCoordinate(rightCoordinate).x - MKMapPointForCoordinate(leftCoordinate).x;
    MKMapRect gridMapRect = MKMapRectMake(0,
                                          0,
                                          gridSize,
                                          gridSize);
    double startX = floor(MKMapRectGetMinX(adjustedVisibleMapRect)/gridSize) * gridSize;
    double startY = floor(MKMapRectGetMinY(adjustedVisibleMapRect)/gridSize) * gridSize;
    double endX = floor(MKMapRectGetMaxX(adjustedVisibleMapRect)/gridSize) * gridSize;
    double endY = floor(MKMapRectGetMaxY(adjustedVisibleMapRect)/gridSize) * gridSize;
    
    gridMapRect.origin.y = startY;
    while (gridMapRect.origin.y <= endY) {
        
        gridMapRect.origin.x = startX;
        while (gridMapRect.origin.x <= endX) {
            NSSet *allAnnotationsInBucket = [self.allAnnotationsMapView annotationsInMapRect:gridMapRect];
            NSSet *visibleAnnotationsInBucket = [self.mapView annotationsInMapRect:gridMapRect];
            
            NSMutableSet *filteredAnnotationsInBucket = [[allAnnotationsInBucket objectsPassingTest:
                                                          ^BOOL(id obj, BOOL *stop) {
                return ([obj isKindOfClass:[Bill class]]);
                                                              
            }] mutableCopy];
            
            

            if (filteredAnnotationsInBucket.count > 0) {
                

                Bill *annotationForGrid = (Bill *)[self annotationInGrid:gridMapRect
                                                  usingAnnotations:filteredAnnotationsInBucket];

                [filteredAnnotationsInBucket removeObject:annotationForGrid];
                
                [self.mapView addAnnotation:annotationForGrid];

                
                annotationForGrid.containedAnnotations = filteredAnnotationsInBucket;
                
                


                
                
                for (Bill *annotation in filteredAnnotationsInBucket) {
                    
                    annotation.hasClusterAnnotation = [NSNumber numberWithBool:YES];
                    annotation.clusterAnnotationCoordinate = annotationForGrid.coordinate;
                    
                    annotation.containedAnnotations = nil;
                    
                    if ([visibleAnnotationsInBucket containsObject:annotation]) {
                        CLLocationCoordinate2D actualCoordinate = annotation.coordinate;
                        [UIView animateWithDuration:0.3 animations:^{
                            annotation.coordinate = annotation.clusterAnnotation.coordinate;
                        } completion:^(BOOL finished) {
                            annotation.coordinate = actualCoordinate;
                            [self.mapView removeAnnotation:annotation];
                        }];
                    }
                    
                   
                }

            }
            
            
            
            gridMapRect.origin.x += gridSize;
        }
        
        gridMapRect.origin.y += gridSize;
    }
    
    
    
    
}

//- (void)enumFetchedObjects{
//    
//    NSArray *bills = [self.fetchedResultsController fetchedObjects];
//    [bills enumerateObjectsUsingBlock:^(Bill *bill, NSUInteger idx, BOOL *stop) {
//        NSLog(@"Bill Index : %i",idx);
//        if (bill.clusterAnnotation != nil) {
//            NSLog(@"clusterannotation exsit.");
//        }else{
//            NSLog(@"clusterannotation dosn't exsit.");
//            
//        }
//    }];
//}

#pragma mark - UIViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _allAnnotationsMapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    [self populateWorldWithAllBillAnnotations];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self populateWorldWithAllBillAnnotations];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self updateVisibleAnnotations];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    
    for (MKAnnotationView *annotationView in views) {
        if (![annotationView.annotation isKindOfClass:[Bill class]]) {
            continue;
        }
        
        Bill *annotation = annotationView.annotation;
        
        if (annotation.hasClusterAnnotation.boolValue == YES) {
            CLLocationCoordinate2D actualCoordinate = annotation.coordinate;
            CLLocationCoordinate2D containerCoordinate = annotation.clusterAnnotationCoordinate;
            
            annotation.hasClusterAnnotation = [NSNumber numberWithBool:NO];
            annotation.coordinate = containerCoordinate;
            
            [UIView animateWithDuration:0.3 animations:^{
                annotation.coordinate = actualCoordinate;
            }];
        }
        
        
    }
    
    
}

- (void)                  mapView:(MKMapView *)mapView
                   annotationView:(MKAnnotationView *)view
    calloutAccessoryControlTapped:(UIControl *)control{
    
    if ([view.annotation isKindOfClass:[Bill class]]) {
        Bill *annotation = view.annotation;
        if (annotation.containedAnnotations.count > 0) {
            [self performSegueWithIdentifier:@"showBillByMap" sender:view];
        }else{
            [self performSegueWithIdentifier:@"mapShowBill" sender:view];
        }
    }
    
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
        }if ([segueIdentifier isEqualToString:@"showBillByMap"]) {
            if ([viewController isKindOfClass:[BillCDTVC class]]) {
                BillCDTVC *billCoreDataTableViewController = (BillCDTVC *)viewController;
                billCoreDataTableViewController.fetchedResultsController = [self fetchedResultsControlleWithBill:bill];
                billCoreDataTableViewController.title = @"地点";
            }
        }
        
    }
    
}

- (NSFetchedResultsController *)fetchedResultsControlleWithBill:(Bill *)bill {
    
    NSMutableArray *billsToShow = [NSMutableArray arrayWithObject:bill];
    [billsToShow addObjectsFromArray:bill.containedAnnotations.allObjects];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Bill"];
    request.predicate = [NSPredicate predicateWithFormat:@"SELF IN %@" , billsToShow];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]
                                                            initWithFetchRequest:request
                                                            managedObjectContext:[PubicVariable managedObjectContext]
                                                            sectionNameKeyPath:nil
                                                            cacheName:nil];
    return fetchedResultsController;
}


@end