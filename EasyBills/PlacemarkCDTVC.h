//
//  PlacemarkCDTVC.h
//  EasyBills
//
//  Created by luojie on 4/10/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Plackmark+Create.h"

@interface PlacemarkCDTVC : CoreDataTableViewController

@property (nonatomic, strong) Plackmark *selectedPlacemark;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
