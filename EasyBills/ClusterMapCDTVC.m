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
#import "CustomPresentAnimationController.h"
#import "CustomDismissAnimationController.h"
#import "PlacemarkCDTVC.h"

@interface ClusterMapCDTVC ()

@property (nonatomic, strong) MKMapView *allAnnotationsMapView;

@property (nonatomic, strong) CustomPresentAnimationController *customPresentAnimationController;
@property (nonatomic, strong) CustomDismissAnimationController *customDismissAnimationController;

@property (nonatomic, strong) PlacemarkCDTVC *pmcdtvc;

@end


@implementation ClusterMapCDTVC

- (void)populateWorldWithAllBillAnnotations {
    
    _allAnnotationsMapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    [_allAnnotationsMapView addAnnotations:self.fetchedResultsController.fetchedObjects];
//    [self updateVisibleAnnotations];
    
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
            
//            if (allAnnotationsInBucket.count) {
//                NSLog(@"visibleAnnotationsInBucket count: %i",visibleAnnotationsInBucket.count);
//                
//                NSLog(@"allAnnotationsInBucket count: %i",allAnnotationsInBucket.count);
//                
//                NSLog(@"filteredAnnotationsInBucket count: %i",filteredAnnotationsInBucket.count);
//                
//
//            }
           
            if (filteredAnnotationsInBucket.count > 0) {
                

                Bill *annotationForGrid = (Bill *)[self annotationInGrid:gridMapRect
                                                  usingAnnotations:filteredAnnotationsInBucket];
//                NSLog(@"filteredAnnotationsInBucket count0: %i",filteredAnnotationsInBucket.count);

                [filteredAnnotationsInBucket removeObject:annotationForGrid];
                
                [self.mapView addAnnotation:annotationForGrid];

                
                annotationForGrid.containedAnnotations = filteredAnnotationsInBucket;
                
                
//                NSLog(@"filteredAnnotationsInBucket count1: %i",filteredAnnotationsInBucket.count);

                
                
                for (Bill *annotation in filteredAnnotationsInBucket) {
                    
                    annotation.hasClusterAnnotation = [NSNumber numberWithBool:YES];
                    annotation.clusterAnnotationCoordinate = annotationForGrid.coordinate;
                    
                    annotation.containedAnnotations = nil;
                    
//                    NSLog(@"filteredAnnotationsInBucket count2: %i",filteredAnnotationsInBucket.count);

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
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateVisibleAnnotations];
//    [self populateWorldWithAllBillAnnotations];
}

#pragma mark - NSFetched Results Controller Delegate
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
//{
//    [super controllerDidChangeContent:controller];
//    [self updateVisibleAnnotations];
//}


#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (self.fetchedResultsController &&
        !self.allAnnotationsMapView)
        [self populateWorldWithAllBillAnnotations];
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
        [mapView deselectAnnotation:annotation animated:YES];
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
    }else if ([sender isKindOfClass:[Plackmark class]]) {
        [self prepareViewController:segue.destinationViewController
                           forSegue:segue.identifier
                   toShowPlacemark:(Plackmark *)sender];
        
    }else if ([sender isKindOfClass:[UIBarButtonItem class]]){
        [self prepareViewController:segue.destinationViewController
                           forSegue:segue.identifier];
    }

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)prepareViewController:(UIViewController *)viewController
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
                    //Configure custom transition.
                    if ([annotation isKindOfClass:[Bill class]]) {
                        Bill *bill = (Bill *)annotation;
                        CGPoint point = [self.mapView convertCoordinate:bill.coordinate toPointToView:nil];
                        self.customPresentAnimationController.startPoint = point;
                        self.customDismissAnimationController.operatorPoint = point;
                        self.customDismissAnimationController.sumPoint = point;
                        self.customDismissAnimationController.customDismissAnimationControllerEndPointType = CustomDismissAnimationControllerEndPointTypeOperator;
                        navigationController.transitioningDelegate = self;
                    }

                    
                }
                
            }
        }if ([segueIdentifier isEqualToString:@"showBillByMap"]) {
            if ([viewController isKindOfClass:[BillCDTVC class]]) {
                BillCDTVC *billCoreDataTableViewController = (BillCDTVC *)viewController;
                billCoreDataTableViewController.fetchedResultsController = [self fetchedResultsControlleWithBill:bill];
                billCoreDataTableViewController.title = bill.subtitle;
            }
        }
        
    }
    
    
}

- (void)prepareViewController:(UIViewController *)viewController
                    forSegue:(NSString *)segueIdentifier
            toShowPlacemark:(Plackmark *)plackmark {
    if ([segueIdentifier isEqualToString:@"showBillByMap"]) {
        if ([viewController isKindOfClass:[BillCDTVC class]]) {
            BillCDTVC *billCoreDataTableViewController = (BillCDTVC *)viewController;
            billCoreDataTableViewController.fetchedResultsController = [self fetchedResultsControlleWithPlackmark:plackmark];
            billCoreDataTableViewController.title = plackmark.name;
        }
    }
}

-(void)prepareViewController:(UIViewController *)viewController
                    forSegue:(NSString *)segueIdentifier {
    if ([segueIdentifier isEqualToString:@"showLocation"]) {
        if ([viewController isKindOfClass:[PlacemarkCDTVC class]]) {
            self.pmcdtvc = (PlacemarkCDTVC *)viewController;
            UIPopoverPresentationController *ppc = self.pmcdtvc.popoverPresentationController;
            ppc.backgroundColor = self.pmcdtvc.tableView.backgroundColor;
            ppc.delegate = self;
            
        }
    }

}



- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    
    if ([keyPath isEqualToString:@"selectedPlacemark"]){
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        if ([newValue isKindOfClass:[Plackmark class]]) {
            Plackmark *plackmark = (Plackmark *)newValue;
            if (plackmark != nil) {
//                [self.pmcdtvc removeObserver:self
//                                  forKeyPath:@"selectedPlacemark"];
                [self performSegueWithIdentifier:@"showBillByMap" sender:plackmark];
//                [self updateCellWithIdentifier:@"inputlocationCell"];
                
            }
        }
        
    }
    
}

- (void)setPmcdtvc:(PlacemarkCDTVC *)pmcdtvc {
    
    [_pmcdtvc removeObserver:self
                  forKeyPath:@"selectedPlacemark"];
    
    _pmcdtvc = pmcdtvc;
    
    [pmcdtvc addObserver:self
               forKeyPath:@"selectedPlacemark"
                  options:NSKeyValueObservingOptionNew
                  context:&pmcdtvc];
    
}

- (void)dealloc {
    self.pmcdtvc = nil;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}


- (NSFetchedResultsController *)fetchedResultsControlleWithBill:(Bill *)bill {
    
    NSMutableArray *billsToShow = [NSMutableArray arrayWithObject:bill];
    [billsToShow addObjectsFromArray:bill.containedAnnotations.allObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@ && locationIsOn == YES" , billsToShow];
    return [self billFetchedResultsControlleWithPredicate:predicate];
}

- (NSFetchedResultsController *)fetchedResultsControlleWithPlackmark:(Plackmark *)plackmark {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"plackmark = %@" , plackmark];
    return [self billFetchedResultsControlleWithPredicate:predicate];
}

- (NSFetchedResultsController *)billFetchedResultsControlleWithPredicate:(NSPredicate *)predicate {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Bill"];
    request.predicate = predicate;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]
                                                            initWithFetchRequest:request
                                                            managedObjectContext:[PubicVariable managedObjectContext]
                                                            sectionNameKeyPath:nil
                                                            cacheName:nil];
    
    return fetchedResultsController;

}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    [super controller:controller
      didChangeObject:anObject
          atIndexPath:indexPath
        forChangeType:type
         newIndexPath:newIndexPath];
    
    id<MKAnnotation> object = [self.fetchedResultsController objectAtIndexPath:newIndexPath];
    
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.allAnnotationsMapView addAnnotation:object];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.allAnnotationsMapView removeAnnotation:object];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //                [self.mapView removeAnnotation:object];
            //                [self.mapView addAnnotation:object];
            //
            break;
            
        case NSFetchedResultsChangeMove:
            //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return self.customPresentAnimationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.customDismissAnimationController;
}

    
- (CustomPresentAnimationController *)customPresentAnimationController {
    if (!_customPresentAnimationController) {
        _customPresentAnimationController = [[CustomPresentAnimationController alloc]init];
    }
    return _customPresentAnimationController;
}

- (CustomDismissAnimationController *)customDismissAnimationController {
    if (!_customDismissAnimationController) {
        _customDismissAnimationController = [[CustomDismissAnimationController alloc]init];
    }
    return _customDismissAnimationController;
}

@end
