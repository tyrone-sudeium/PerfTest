//
//  SDMTest.m
//  PerfTest
//
//  Created by Tyrone Trevorrow on 16/03/18.
//  Copyright (c) 2018 Sudeium. All rights reserved.
//

#import "SDMTest.h"
#import "SDMUser.h"
#import "SDMSalesperson.h"
#import "SDMSale.h"
#import "SDMSQLContext.h"

static NSString *triangleStr = nil;
static NSArray *firstNames = nil;
static NSArray *surnames = nil;
static NSArray *hostnames = nil;


@implementation SDMTest

+ (void) load
{
    [self loadDataFromDiskIfNecessary];
}

+ (void) loadDataFromDiskIfNecessary
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        triangleStr = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"triangle" ofType: @"txt"]
                                                encoding: NSUTF8StringEncoding
                                                   error: nil];
        firstNames = [NSKeyedUnarchiver unarchiveObjectWithFile: [[NSBundle mainBundle] pathForResource: @"firstnames" ofType: @"dat"]];
        surnames = [NSKeyedUnarchiver unarchiveObjectWithFile: [[NSBundle mainBundle] pathForResource: @"surnames" ofType: @"dat"]];
        hostnames = [NSKeyedUnarchiver unarchiveObjectWithFile: [[NSBundle mainBundle] pathForResource: @"hostnames" ofType: @"dat"]];
    });
}

+ (NSString*) runEulerTest {
    CFTimeInterval start = CACurrentMediaTime();
    [self maximalTotalFromString: triangleStr];
    CFTimeInterval end = CACurrentMediaTime();
    CFTimeInterval duration = end - start;

    return [NSString stringWithFormat: @"Euler test: %.4f", duration];
}

+ (NSString*) runSqliteTest {
    NSArray *users;
    NSArray *salespeople;
    NSArray *sales;
    NSMutableString *output = [NSMutableString new];
    SDMSQLContext *sqlContext = [SDMSQLContext new];

    {
        CFTimeInterval start = CACurrentMediaTime();

        users = [self randomUsers: 200];
        salespeople = [self randomSalespeople: 10];
        sales = [self randomSales: 4000 users: users salespeople: salespeople];

        CFTimeInterval end = CACurrentMediaTime();
        CFTimeInterval duration = end - start;

        [output appendFormat: @"Create test data: %.4f\n", duration];
    }

    {
        CFTimeInterval start = CACurrentMediaTime();

        [sqlContext buildSchemaForClasses: @[SDMUser.class, SDMSale.class, SDMSalesperson.class]];
        [sqlContext insert: users];
        [sqlContext insert: salespeople];
        [sqlContext insert: sales];

        CFTimeInterval end = CACurrentMediaTime();
        CFTimeInterval duration = end - start;

        [output appendFormat: @"Insert: %.4f\n", duration];
    }

    {
        CFTimeInterval start = CACurrentMediaTime();

        [sqlContext allObjects: [SDMSale class]];

        CFTimeInterval end = CACurrentMediaTime();
        CFTimeInterval duration = end - start;

        [output appendFormat: @"Query data: %.4f\n", duration];
    }
    [output appendFormat: @"Ran %llu SQL queries", (unsigned long long)sqlContext.queryCount];

    return output;
}

+ (NSNumber*) maximalTotalFromString: (NSString*) str {
    NSMutableArray *t = [self triangleLinesFromString: str];
    for (NSInteger i = t.count - 1; i >= 0; i--) {
        if (i == t.count - 1) {
            continue;
        }
        NSMutableArray *a = [t objectAtIndex: i];
        for (NSInteger j = 0; j < [a count]; j++) {
            NSNumber *x = [a objectAtIndex: j];
            NSNumber *bl = [[t objectAtIndex: i + 1] objectAtIndex: j];
            NSNumber *br = [[t objectAtIndex: i + 1] objectAtIndex: j + 1];
            [a replaceObjectAtIndex: j withObject: @(MAX(bl.integerValue, br.integerValue) + x.integerValue)];
        }
    }
    return [[t objectAtIndex: 0] objectAtIndex: 0];
}

+ (NSMutableArray*) triangleLinesFromString: (NSString*) str {
    NSArray *lineStrs = [str componentsSeparatedByString: @"\n"];
    NSMutableArray *lines = [NSMutableArray arrayWithCapacity: lineStrs.count];
    for (NSString *line in lineStrs) {
        if ([line length] > 0) {
            [lines addObject: [self numbersFromLine: line]];
        }
    }
    return lines;
}

+ (NSMutableArray*) numbersFromLine: (NSString*) str {
    NSArray *numberStrs = [str componentsSeparatedByString: @" "];
    NSMutableArray *numbers = [NSMutableArray arrayWithCapacity: numberStrs.count];
    for (NSString *numberStr in numberStrs) {
        [numbers addObject: @([numberStr integerValue])];
    }
    return numbers;
}

+ (NSArray*) randomNames: (NSUInteger) count
{
    // This method seems weird but it should prevent duplicates.
    NSMutableSet *allNamesSet = [NSMutableSet setWithCapacity: firstNames.count * surnames.count];
    for (NSInteger i = 0; i < firstNames.count; i++) {
        for (NSInteger j = 0; j < surnames.count; j++) {
            [allNamesSet addObject: [NSString stringWithFormat: @"%@ %@", firstNames[i], surnames[j]]];
        }
    }
    NSMutableArray *allNames = allNamesSet.allObjects.mutableCopy;
    // Shuffle
    for (NSUInteger i = 0; i < allNames.count - 1; i++) {
        NSUInteger remaining = allNames.count - i;
        [allNames exchangeObjectAtIndex: i withObjectAtIndex: i + arc4random_uniform(remaining)];
    }

    return [allNames subarrayWithRange: NSMakeRange(0, count)];
}

+ (NSArray*) randomUsers: (NSUInteger) count
{    
    NSArray *names = [self randomNames: count];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity: count];
    for (NSUInteger i = 0; i < count; i++) {
        NSString *hostname = hostnames[arc4random_uniform(hostnames.count)];
        NSString *name = [names objectAtIndex: i];
        NSString *firstName = [[name componentsSeparatedByString: @" "] objectAtIndex: 0];
        NSString *surname = [[name componentsSeparatedByString: @" "] objectAtIndex: 1];
        NSString *email = [NSString stringWithFormat: @"%@.%@@%@",
                           [firstName substringToIndex: 1],
                           surname,
                           hostname];
        SDMUser *user = [SDMUser new];
        user.name = name;
        user.email = email;
        user.userId = @(i);
        [arr addObject: user];
    }
    return arr;
}

+ (NSArray*) randomSalespeople: (NSUInteger) count
{
    NSArray *names = [self randomNames: count];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity: count];
    for (NSUInteger i = 0; i < count; i++) {
        SDMSalesperson *person = [SDMSalesperson new];
        person.name = [names objectAtIndex: i];
        person.salespersonId = @(i);
        [arr addObject: person];
    }
    return arr;
}

+ (NSArray*) randomSales: (NSUInteger) count users: (NSArray*) users salespeople: (NSArray*) salespeople
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity: count];
    for (NSUInteger i = 0; i < count; i++) {
        SDMSale *sale = [SDMSale new];
        sale.date = [NSDate dateWithTimeIntervalSince1970: 946648800 + arc4random_uniform(567648000)];
        sale.user = [users objectAtIndex: arc4random_uniform((uint32_t)users.count)];
        sale.salesperson = [salespeople objectAtIndex: arc4random_uniform((uint32_t)salespeople.count)];
        sale.desc = [NSString stringWithFormat: @"Thing %llu", (unsigned long long) i];
        sale.amount = [NSDecimalNumber decimalNumberWithString: [NSString stringWithFormat: @"%llu", (unsigned long long) arc4random_uniform(100000) + 1000]];
        [arr addObject: sale];
    }
    return arr;
}

@end
