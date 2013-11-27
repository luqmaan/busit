//
//  BIRoute.m
//  BusIt
//
//  Created by Lolcat on 9/26/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BIRoute.h"

@interface BIRoute () {}

@property NSArray *stopsArray;
@property NSArray *tripsArray;

@end

@implementation BIRoute

@synthesize routeId, routeShortName, routeLongName, routeType, routeUrl, routeColor, routeTextColor, hue, stopsArray, tripsArray;

- (BIRoute *)initWithGtfsResult:(NSDictionary *)resultDict
{
    self = [super init];
    if (self) {
        routeId = [NSNumber numberWithInt:[resultDict[@"route_id"]intValue]];
        routeShortName = resultDict[@"route_short_name"];
        routeLongName = resultDict[@"route_long_name"];
        routeType = resultDict[@"route_type"];
        routeUrl = resultDict[@"route_url"];
        routeColor = [BIHelpers colorWithHexString:resultDict[@"route_color"]];
        routeTextColor = [BIHelpers colorWithHexString:resultDict[@"route_text_color"]];
        hue = ([routeId intValue] % 10) / 10.0;
    }
    return self;
}

- (NSArray *)stops {
    if (!stopsArray) {
        [self fetchStops];
    }
    return stopsArray;
}

-(void)fetchStops
{
    BIBusData *busData = [[BIBusData alloc] init];
    // Query for nearby stops
    NSString *query = [NSString stringWithFormat:@"SELECT trips.trip_headsign, stops.* FROM stop_times, trips INNER JOIN stops ON stop_times.stop_id = stops.stop_id WHERE stop_times.trip_id = trips.trip_id AND trips.route_id = '%@' GROUP BY stop_id", routeId];
    FMResultSet *rs = [[busData database] executeQuery:query];
    NSMutableArray *stops = [[NSMutableArray alloc] init];
    while ([rs next]) {
        BIStop *stop = [[BIStop alloc] initWithGtfsResult:[rs resultDictionary]];
        [stops addObject:stop];
    }
    stopsArray = [stops copy];  // Convert to NSArray
}

- (NSArray *)stopsMatchingQuery:(NSString *)query
{
    return nil;
}

- (NSArray *)trips {
    if (!tripsArray) {
        [self fetchTrips];
    }
    return tripsArray;
}

- (void)fetchTrips
{
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM trips WHERE route_id = %@ GROUP BY shape_id", routeId];
    BIBusData *busData = [[BIBusData alloc] init];
    FMResultSet *rs = [[busData database] executeQuery:query];
    NSMutableArray *trips = [[NSMutableArray alloc] init];
    while ([rs next]) {
        BITrip *trip = [[BITrip alloc] initWithGTFSResult:[rs resultDictionary]];
        [trips addObject:trip];
    }
    tripsArray = [trips copy];  // Convert to NSArray
}

- (Shape *)shapeForTrip:(BITrip *)trip
{
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM shapes WHERE shape_id = %@", trip.shapeId];
    BIBusData *busData = [[BIBusData alloc] init];
    FMResultSet *rs = [[busData database] executeQuery:query];
    Shape *shape = [[Shape alloc] init];
    while ([rs next]) {
        NSDictionary *resultDict = [rs resultDictionary];
        ShapePoint *point = [[ShapePoint alloc] initWithLatitude:[resultDict[@"shape_pt_lat"] floatValue]
                                                       longitude:[resultDict[@"shape_pt_lon"] floatValue]
                                                        sequence:[resultDict[@"shape_pt_sequence"] intValue]];
        [shape addPoint:point];
    }
    ShapeReducer *reducer = [[ShapeReducer alloc] init];
    shape = [reducer reduce:shape tolerance:0.001];
    return shape;
}

@end
