//
//  BDBusData.m
//  BusIt
//
//  Created by Lolcat on 8/30/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BDBusData.h"

@interface BDBusData() {}

@property NSMutableArray *tableNames;
@property BIRest *bench;

@end

@implementation BDBusData

@synthesize database, tableNames, bench;

- (id)init
{
    self = [super init];
    if (self) {
        tableNames = [[NSMutableArray alloc] initWithObjects:@"stops", @"stop_times", @"trips", @"calendar", @"routes", @"shapes", @"calendar_dates", @"fare_attributes", @"fare_rules", nil];
        bench = [[BIRest alloc] init];
        database = [self openDatabase];
        if ([self shouldCreateSchema]) {
            [self createSchema];
            [self updateTables];
        }
        if ( 1 /* today is past the expiration data of the data stored in the sqlite */) {
            [self updateTables];
        }
    }
    return self;
}

- (void)dealloc
{
    [database close];
}

- (FMDatabase *)openDatabase
{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"gtfs.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    return db;
}

#pragma mark - SQLite Setup

- (void)dropTables
{
    [database executeUpdate:@"PRAGMA writable_schema = 1;"];
    [database executeUpdate:@"delete from sqlite_master where type = 'table';"];
    [database executeUpdate:@"PRAGMA writable_schema = 0;"];
    [database executeUpdate:@"VACUUM"];
    FMResultSet *rs = [database executeQuery:@"PRAGMA INTEGRITY_CHECK;"];
    while (rs.next) {
        NSLog(@"Integrity check: %@", rs.resultDictionary);
    }
}

- (BOOL)shouldCreateSchema
{
    for (NSString *table in tableNames) {
        NSString *query = [NSString stringWithFormat:@"SELECT count(name) FROM sqlite_master WHERE type='table' AND name ='%@';", table];
        NSUInteger count = [database intForQuery:query];
        if (count == 0) {
            NSLog(@"Need to update schema. Missing table %@", table);
            return YES;
        }
    }
    return NO;
}

- (void)logSchema
{
    FMResultSet *results = [database executeQuery:@"SELECT rootpage, name, sql FROM sqlite_master ORDER BY name;"];
    NSLog(@"tables: %@ %@ %d %@", results, [results resultDictionary], results.columnCount, [results columnNameForIndex:0]);
    for (id column in [results columnNameToIndexMap]) {
        NSLog(@"col: %@", column);
    }
    while ([results next]) {
        NSLog(@"%@ %@ %@", results[1], results[0], results[2]);
    }
}

- (void)createSchema
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"schema" ofType:@"sql"];
    NSString *schemaStr = [NSString stringWithContentsOfFile:path
                                                    encoding:NSUTF8StringEncoding
                                                       error:NULL];
    schemaStr = [schemaStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSArray* schemaArr = [schemaStr componentsSeparatedByString:@";"];
    for (NSString *update in schemaArr) {
        [database executeUpdate:update];
    }
}

- (void)updateTables
{
    [self dropTables];
    [self createSchema];
    for (NSString *tableName in tableNames) {
        NSLog(@"Updating table: %@", tableName);
        NSMutableString *csvStr = [NSMutableString stringWithString:[bench gtfsSqlForTable:tableName]];
        NSLog(@"Downloaded data");
        NSRange firstLineRange = [csvStr rangeOfString:@"\n"]; // position of first \n
        firstLineRange.length = firstLineRange.location;
        firstLineRange.location = 0;
        NSString *firstLine = [csvStr substringWithRange:firstLineRange];
        NSString *queryStr = [NSString stringWithFormat:@"'); INSERT INTO %@ (%@) VALUES ('", tableName, firstLine];
        [csvStr deleteCharactersInRange:firstLineRange];
        NSRange lastLine = NSMakeRange([csvStr length] - 1, 1);
        [csvStr deleteCharactersInRange:lastLine];
        [csvStr replaceOccurrencesOfString:@"'"
                                withString:@"''"
                                   options:NSCaseInsensitiveSearch
                                     range:NSMakeRange(0, [csvStr length])];
        [csvStr replaceOccurrencesOfString:@"\""
                                withString:@"\\\""
                                   options:NSCaseInsensitiveSearch
                                     range:NSMakeRange(0, [csvStr length])];
        [csvStr replaceOccurrencesOfString:@","
                                withString:@"','"
                                   options:NSCaseInsensitiveSearch
                                     range:NSMakeRange(0, [csvStr length])];
        [csvStr replaceOccurrencesOfString:@"\n"
                                withString:queryStr
                                   options:NSCaseInsensitiveSearch
                                     range:NSMakeRange(0, [csvStr length])];
        [csvStr appendString:@"');"];
        NSString *queries = [csvStr substringFromIndex:3];
        NSError *error;
        NSLog(@"Prepared inserts, about to perform query");
        [database executeBatch:queries error:&error];
        if (error)
            NSLog(@"%@", error);
    }
}


#pragma mark - Misc. Data

- (NSArray *)stopsNearLocation:(CLLocationCoordinate2D)location andRadius:(CGFloat)miles
{
    return nil;
}

- (NSDictionary *)vehiclesForAgency:(NSString *)agencyId;
{
    return nil;
}

@end
