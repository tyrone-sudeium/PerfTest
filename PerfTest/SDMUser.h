//
//  SDMUser.h
//  PerfTest
//
//  Created by Tyrone Trevorrow on 19/03/18.
//  Copyright (c) 2018 Sudeium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDMSQLStorable.h"

@interface SDMUser : NSObject <SDMSQLStorable>
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@end
