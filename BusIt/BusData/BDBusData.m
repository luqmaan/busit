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
@property NSMutableArray *databaseNames;
@property BIRest *bench;
@property NSString *documentsPath;
@end

@implementation BDBusData

@synthesize database, tableNames, bench, databaseNames, documentsPath;

- (id)init
{
    self = [super init];
    if (self) {
        
        bench = [[BIRest alloc] init];

        // Specify the tables names and database names.
        tableNames = [[NSMutableArray alloc] initWithObjects:@"stops", @"stop_times", @"trips", @"calendar", @"routes", @"shapes", @"calendar_dates", @"fare_attributes", @"fare_rules", nil];
        databaseNames = [[NSMutableArray alloc] initWithObjects:@"gtfs_tampa", nil];
        documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        
        [self copyDatabasesFromProjectToDocuments];
        
        // TODO: Determine which city we are working with.
        // For now, default to Tampa.
        NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"gtfs_tampa.db"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        // Update the cities database if needed
        if ([self shouldUpdateDatabase]) {
            [self downloadDatabase];
        }
        
        [self addDistanceFunction];
        
    }
    return self;
}

- (void)dealloc
{
    [database close];
}

#pragma mark - Database Updates

// Add the databases to the Document's directory.
// It isn't necessary to check if every cities data is up to date; the user only cares about their own city.
- (void)copyDatabasesFromProjectToDocuments
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    for (NSString *databaseName in databaseNames) {
        // The destination path of the database
        NSString *dbPath = [documentsPath stringByAppendingPathComponent:databaseName];
        dbPath = [NSString stringWithFormat:@"%@.db", dbPath];
        
        // Check if the db already exists in the Documents folder
        if (![fileManager fileExistsAtPath:dbPath]) {
            // Copy the db from the Project directory to the Documents directory
            NSString *sourcePath = [[NSBundle mainBundle] pathForResource:databaseName ofType:@"db"];
            NSError *error;
            [fileManager copyItemAtPath:sourcePath toPath:dbPath error:&error];
            if (error) {
                NSLog(@"Error copy file from project directory to documents directory: %@", error);
            }
        }
    }
}

- (BOOL)shouldUpdateDatabase
{
    // TODO: Should return YES when today is past the expiration data of the data
    // How do you find the expiration date?
    return NO;
}

- (void)downloadDatabase
{
    // TODO
    return;
}

// Adds a distance function to the database
- (void)addDistanceFunction
{
    // See http://daveaddey.com/?p=71
    [database makeFunctionNamed:@"distance" maximumArguments:4 withBlock:^(sqlite3_context *context, int argc, sqlite3_value **argv) {
        // check that we have four arguments (lat1, lon1, lat2, lon2)
        assert(argc == 4);
        // check that all four arguments are non-null
        if (sqlite3_value_type(argv[0]) == SQLITE_NULL || sqlite3_value_type(argv[1]) == SQLITE_NULL || sqlite3_value_type(argv[2]) == SQLITE_NULL || sqlite3_value_type(argv[3]) == SQLITE_NULL) {
            sqlite3_result_null(context);
            return;
        }
        // get the four argument values
        double lat1 = sqlite3_value_double(argv[0]);
        double lon1 = sqlite3_value_double(argv[1]);
        double lat2 = sqlite3_value_double(argv[2]);
        double lon2 = sqlite3_value_double(argv[3]);
        // convert lat1 and lat2 into radians now, to avoid doing it twice below
        double lat1rad = DEG2RAD(lat1);
        double lat2rad = DEG2RAD(lat2);
        // apply the spherical law of cosines to our latitudes and longitudes, and set the result appropriately
        // 6378.1 is the approximate radius of the earth in kilometres
        sqlite3_result_double(context, acos(sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(DEG2RAD(lon2) - DEG2RAD(lon1))) * 6378.1);
    }];
}


#pragma mark - Misc. Data

// Find stops nearby the location that are within the given distance.
- (NSArray *)stopsNearLocation:(CLLocation *)location andLimit:(int)limit
{
    FMResultSet *nearby = [database executeQueryWithFormat:@"SELECT *, distance(stop_lat, stop_lon, %f, %f) as \"distance\" FROM stops ORDER BY distance(stop_lat, stop_lon, %f, %f) LIMIT %d", location.coordinate.latitude, location.coordinate.longitude, location.coordinate.latitude, location.coordinate.longitude, limit];
    NSLog(@"nearby %@", nearby);
    NSMutableArray *stops = [[NSMutableArray alloc] init];
    while ([nearby next]) {
        NSLog(@"result: %@ ", [nearby resultDictionary]);
        
    }
    
    return nil;
}

- (NSDictionary *)vehiclesForAgency:(NSString *)agencyId;
{
    return nil;
}

@end
