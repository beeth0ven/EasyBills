//
//  NSManagedObject+Extension.m
//  EasyBills
//
//  Created by luojie on 5/4/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "NSManagedObject+Extension.h"

@implementation NSManagedObject (Extension)

- (void)moveAllRelatedObectsTo:(NSManagedObject *)destinationManagedObject {
    if (self && destinationManagedObject) {
        NSEntityDescription *entityDescription = self.entity;
        NSEntityDescription *destinationEntityDescription = destinationManagedObject.entity;

        NSArray *relationshipNames = entityDescription.relationshipsByName.allKeys;
        for (NSString *relationshipName in relationshipNames) {
            
            NSArray *destinationRelationshipNames = destinationEntityDescription.relationshipsByName.allKeys;
            if ([destinationRelationshipNames containsObject:relationshipName]) {
                id relatedObject = [self valueForKey:relationshipName];
                if ([relatedObject isKindOfClass:[NSSet class]]) {
                    NSSet *relatedObjects = (NSSet *)relatedObject;
                    NSMutableSet *destinationRelatedObjects = [[destinationManagedObject valueForKey:relationshipName] mutableCopy];
                    [destinationRelatedObjects unionSet:relatedObjects];
                    [destinationManagedObject setValue:destinationRelatedObjects forKey:relationshipName];
                    NSLog(@"Successfully move to many relation ship name: %@.",relationshipName);
                } else {
                    [destinationManagedObject setValue:relatedObject forKey:relationshipName];
                    NSLog(@"Successfully move to one relation ship name: %@.",relationshipName);
                }
                
            }
            
        }
    }
}

@end
