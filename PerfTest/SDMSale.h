//
//  SDMSale.h
//  PerfTest
//
//  Created by Tyrone Trevorrow on 19/03/18.
//  Copyright (c) 2018 Sudeium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDMSQLStorable.h"

@class SDMSalesperson, SDMUser;

@interface SDMSale : NSObject <SDMSQLStorable>
@property (nonatomic, copy) NSNumber *saleId;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSDecimalNumber *amount;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, weak) SDMSalesperson *salesperson;
@property (nonatomic, weak) SDMUser *user;

@end
