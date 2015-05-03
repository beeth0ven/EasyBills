//
//  Plackmark+Create.m
//  EasyBills
//
//  Created by luojie on 4/9/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "Plackmark+Create.h"
#import "PubicVariable.h"

@implementation Plackmark (Create)


+ (Plackmark *)plackmarkWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    Plackmark *plackmark = nil;
    
    if (name.length) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Plackmark"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@",name];
        
        NSError *error = nil;
        NSArray *matches = [context
                            executeFetchRequest:request error:&error];
        
        
        if (!matches || [matches count] > 1) {
            //error
            NSLog(@"Error ,The same placemark exist.");
        }else if ([matches count] == 0){
            
            plackmark = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Plackmark"
                         inManagedObjectContext:context];
            
            plackmark.name  = name;
            // [PubicVariable saveContext];
        }else if ([matches count] == 1){
            plackmark = [matches lastObject];
        }
    }
    return plackmark;
}


@end
