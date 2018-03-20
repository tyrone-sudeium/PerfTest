//
//  SDMSQLContext.m
//  PerfTest
//
//  Created by Tyrone Trevorrow on 19/03/18.
//  Copyright (c) 2018 Sudeium. All rights reserved.
//

#import "SDMSQLContext.h"
#import "sqlite3.h"

@interface SDMSQLContext ()
@property (nonatomic, assign) sqlite3 *db;
@property (nonatomic, strong) NSCache *objectCache;
@end

@interface SDMSQLCallbackContext : NSObject
@property (nonatomic, strong) NSMutableArray *rows;
@end

@implementation SDMSQLCallbackContext

@end

static int SDMSQLContextCallback(void *context, int argc, char **argv, char **azColName) {
    SDMSQLCallbackContext *bridgedContext = (__bridge id) context;
    if (bridgedContext.rows == nil) {
        bridgedContext.rows = [NSMutableArray new];
    }
    NSMutableDictionary *row = [NSMutableDictionary dictionaryWithCapacity: argc];
    for (int i = 0; i < argc; i++) {
        NSString *col = [NSString stringWithUTF8String: azColName[i]];
        if (argv[i]) {
            [row setObject: [NSString stringWithUTF8String: argv[i]] forKey: col];
        } else {
            [row setObject: [NSNull null] forKey: col];
        }
    }
    [bridgedContext.rows addObject: row];

    return SQLITE_OK;
}

@implementation SDMSQLContext

- (instancetype) init
{
    self = [super init];
    if (self) {
        _objectCache = [[NSCache alloc] init];
        int rc = sqlite3_open(":memory:", &_db);
        NSAssert(rc == SQLITE_OK, [NSString stringWithUTF8String: sqlite3_errmsg(_db)]);
        if (rc != SQLITE_OK) {
            sqlite3_close(_db);
            _db = nil;
        }
    }
    return self;
}

-  (id<SDMSQLStorable>)objectWithId:(NSNumber *)objectId class:(Class)klass
{
    NSString *cacheKey = [NSString stringWithFormat: @"%@.%@", klass, objectId];
    id cachedObject = [self.objectCache objectForKey: cacheKey];
    if (cachedObject) {
        return cachedObject;
    }
    NSString *table = [klass table];
    NSString *sql = [NSString stringWithFormat: @"SELECT * FROM %@ WHERE id = %@", table, objectId];
    NSArray *rows = [self runSQL: sql];
    if (rows.count == 0) {
        return nil;
    }
    id<SDMSQLStorable> object = [[klass alloc] initWithSQLDict: [rows objectAtIndex: 0] inContext: self];
    [self.objectCache setObject: object forKey: cacheKey];
    return object;
}

- (void) buildSchemaForClasses:(NSArray *)classes
{
    NSMutableArray *statements = [NSMutableArray arrayWithCapacity: classes.count + 2];
    [statements addObject: @"BEGIN TRANSACTION;"];
    for (Class klass in classes) {
        NSString *schema = [klass schema];
        [statements addObject: schema];
    }
    [statements addObject: @"COMMIT;"];
    NSString *sql = [statements componentsJoinedByString: @"\n"];
    [self runSQL: sql];
}

- (void) insert:(NSArray *)objects
{
    NSMutableString *sql = [NSMutableString new];
    [sql appendString: @"BEGIN TRANSACTION;\n"];
    for (id<SDMSQLStorable> obj in objects) {
        NSString *table = [[obj class] table];
        NSDictionary *sqlDict = [obj sqlDict];
        NSArray *keys = [sqlDict allKeys];
        NSMutableArray *values = [NSMutableArray arrayWithCapacity: keys.count];
        for (NSString *key in keys) {
            [values addObject: [NSString stringWithFormat: @"'%@'", sqlDict[key]]];
        }
        [sql appendFormat: @"INSERT INTO %@ (%@) VALUES (%@);",
         table,
         [keys componentsJoinedByString: @","],
         [values componentsJoinedByString: @","]];
    }
    [sql appendString: @"COMMIT;"];
    [self runSQL: sql];
}

- (NSArray*) runSQL: (NSString*) sql
{
    char *errMsg = nil;
    SDMSQLCallbackContext *ctx = [SDMSQLCallbackContext new];
    int rc = sqlite3_exec(_db, [sql UTF8String], &SDMSQLContextCallback, (__bridge void*) ctx, &errMsg);
    if (rc != SQLITE_OK) {
        NSLog(@"SQL Error: %s", errMsg);
        sqlite3_free(errMsg);
        return nil;
    }
    return ctx.rows;
}

- (void) dealloc
{
    sqlite3_close(_db);
}

@end
