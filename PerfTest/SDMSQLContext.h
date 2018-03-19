//
//  SDMSQLContext.h
//  PerfTest
//
//  Created by Tyrone Trevorrow on 19/03/18.
//  Copyright (c) 2018 Sudeium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDMSQLStorable.h"

@interface SDMSQLContext : NSObject

- (void) buildSchemaForClasses: (NSArray*) classes;
- (id<SDMSQLStorable>) objectWithId: (NSNumber*) objectId class: (Class) klass;

- (void) insert: (NSArray*) objects;

@end
