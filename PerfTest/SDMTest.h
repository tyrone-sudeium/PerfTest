//
//  SDMTest.h
//  PerfTest
//
//  Created by Tyrone Trevorrow on 16/03/18.
//  Copyright (c) 2018 Sudeium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDMTest : NSObject

+ (NSString*) runEulerTest;
+ (NSString*) runSqliteTest;

+ (NSNumber*) maximalTotalFromString: (NSString*) str;
+ (NSArray*) randomNames: (NSUInteger) count;

@end
