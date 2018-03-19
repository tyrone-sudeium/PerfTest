//
//  SDMSale.m
//  PerfTest
//
//  Created by Tyrone Trevorrow on 19/03/18.
//  Copyright (c) 2018 Sudeium. All rights reserved.
//

#import "SDMSale.h"
#import "SDMSalesperson.h"
#import "SDMUser.h"
#import "SDMSQLContext.h"

@implementation SDMSale

+ (NSString*) schema
{
    return @"CREATE TABLE Sales (\
    id INTEGER PRIMARY KEY ASC,\
    date INTEGER,\
    amount INTEGER,\
    description TEXT,\
    salesperson_id INTEGER,\
    user_id INTEGER,\
    FOREIGN KEY(salesperson_id) REFERENCES Salesperson(id),\
    FOREIGN KEY(user_id) REFERENCES User(id)\
    );";
}

+ (NSString*) table
{
    return @"Sales";
}

- (instancetype) initWithSQLDict: (NSDictionary*) row inContext: (SDMSQLContext*) context
{
    self = [super init];
    if (self) {
        self.saleId = @([row[@"id"] integerValue]);
        self.date = [NSDate dateWithTimeIntervalSince1970: [row[@"date"] doubleValue]];
        self.amount = [NSDecimalNumber decimalNumberWithString: row[@"amount"]];
        self.desc = row[@"description"];
        NSNumber *userId = @([row[@"user_id"] integerValue]);
        NSNumber *salespersonId = @([row[@"salesperson_id"] integerValue]);
        self.user = [context objectWithId: userId class: [SDMUser class]];
        self.salesperson = [context objectWithId: salespersonId class: [SDMSalesperson class]];
    }
    return self;
}

- (NSDictionary*) sqlDict
{
    NSMutableDictionary *d = [NSMutableDictionary new];
    if (self.saleId) d[@"id"] = self.saleId.description;
    if (self.date) d[@"date"] = @([self.date timeIntervalSince1970]).description;
    if (self.amount) d[@"amount"] = self.amount.stringValue;
    if (self.desc) d[@"description"] = self.desc;
    if (self.salesperson) d[@"salesperson_id"] = self.salesperson.salespersonId.description;
    if (self.user) d[@"user_id"] = self.user.userId.description;
    return d;
}

@end
