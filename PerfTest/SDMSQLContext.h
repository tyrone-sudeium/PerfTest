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
@property (nonatomic, readonly, assign) NSUInteger queryCount;

- (void) buildSchemaForClasses: (NSArray*) classes;
- (id<SDMSQLStorable>) objectWithId: (NSNumber*) objectId class: (Class) klass;

- (void) insert: (NSArray*) objects;
- (NSArray*) allObjects: (Class) klass;

@end
