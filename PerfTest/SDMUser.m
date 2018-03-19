//
//  SDMUser.m
//  PerfTest
//
//  Created by Tyrone Trevorrow on 19/03/18.
//  Copyright (c) 2018 Sudeium. All rights reserved.
//

#import "SDMUser.h"

@implementation SDMUser

+ (NSString*) schema
{
    return @"CREATE TABLE User (\
    id INTEGER PRIMARY KEY ASC,\
    name TEXT,\
    email TEXT\
    );";
}

+ (NSString*) table
{
    return @"User";
}

- (instancetype) initWithSQLDict:(NSDictionary *)row inContext:(SDMSQLContext *)context
{
    self = [super init];
    if (self) {
        self.userId = @([row[@"id"] integerValue]);
        self.name = row[@"name"];
        self.email = row[@"email"];
    }
    return self;
}

- (NSDictionary*) sqlDict
{
    NSMutableDictionary *d = [NSMutableDictionary new];
    if (self.userId) d[@"id"] = self.userId.description;
    if (self.name) d[@"name"] = self.name;
    if (self.email) d[@"email"] = self.email;
    return d;
}

@end
