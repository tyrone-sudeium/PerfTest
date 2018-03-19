//
//  SDMSalesperson.m
//  PerfTest
//
//  Created by Tyrone Trevorrow on 19/03/18.
//  Copyright (c) 2018 Sudeium. All rights reserved.
//

#import "SDMSalesperson.h"

@implementation SDMSalesperson

+ (NSString*) schema
{
    return @"CREATE TABLE Salesperson (\
    id INTEGER PRIMARY KEY ASC,\
    name TEXT\
    );";
}

+ (NSString*) table
{
    return @"Salesperson";
}

- (instancetype) initWithSQLDict:(NSDictionary *)row inContext:(SDMSQLContext *)context
{
    self = [super init];
    if (self) {
        self.salespersonId = @([row[@"id"] integerValue]);
        self.name = row[@"name"];
    }
    return self;
}

- (NSDictionary*) sqlDict
{
    NSMutableDictionary *d = [NSMutableDictionary new];
    if (self.salespersonId) d[@"id"] = self.salespersonId.description;
    if (self.name) d[@"name"] = self.name;
    return d;
}

@end
