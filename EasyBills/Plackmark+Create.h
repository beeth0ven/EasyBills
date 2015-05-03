//
//  Plackmark+Create.h
//  EasyBills
//
//  Created by luojie on 4/9/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "Plackmark.h"

@interface Plackmark (Create)

+ (Plackmark *)plackmarkWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;


@end
