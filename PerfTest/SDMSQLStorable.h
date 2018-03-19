//
//  SDMSQLStorable.h
//  PerfTest
//
//  Created by Tyrone Trevorrow on 19/03/18.
//  Copyright (c) 2018 Sudeium. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDMSQLContext;

@protocol SDMSQLStorable <NSObject>
@required
+ (NSString*) schema;
+ (NSString*) table;
- (instancetype) initWithSQLDict: (NSDictionary*) row inContext: (SDMSQLContext*) context;
- (NSDictionary*) sqlDict;
@end
