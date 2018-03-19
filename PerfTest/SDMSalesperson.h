//
//  SDMSalesperson.h
//  PerfTest
//
//  Created by Tyrone Trevorrow on 19/03/18.
//  Copyright (c) 2018 Sudeium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDMSQLStorable.h"

@interface SDMSalesperson : NSObject <SDMSQLStorable>
@property (nonatomic, copy) NSNumber *salespersonId;
@property (nonatomic, copy) NSString *name;
@end
