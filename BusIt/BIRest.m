//
//  BIRest.m
//  BusStop
//
//  Created by Chris Woodard on 4/12/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BIRest.h"

#define kFrakkingLongAPIKey1 @"onebusaway.forest.usf.edu-7e74c063-43c9-4067-8aef-5730aa860628"
#define kFrakkingLongAPIKey2 @"onebusaway.forest.usf.edu-f75b1e48-80c4-4880-a294-e353e13bd9d2"
#define kFrakkingLongAPIKey3 @"onebusaway.forest.usf.edu-74cccb15-6eb5-400b-86d9-3a1db8931efd"

#define kFrakkingLongAPIKey kFrakkingLongAPIKey2

#define kFrakkingStupidAgencyID @"Hillsborough%20Area%20Regional%20Transit"

@implementation BIRest

-(id)init {
    self = [super init];
    if (self) {
        self.offlineMode = NO;
        return self;
    }
    return nil;
}


-(void)fetchURL:(NSString *)urlStr paramStr:(NSString *)paramStr
{
    NSString *wholeURLStr = [NSString stringWithFormat:@"%@?key=%@&%@", urlStr, kFrakkingLongAPIKey, paramStr];
    NSURL *url = [NSURL URLWithString:wholeURLStr];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSLog(@"GET %@", wholeURLStr);
    
    [req setHTTPMethod:@"GET"];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:req delegate:self];
    
    self.cumulativeData = [[NSMutableData alloc] initWithCapacity:0];
    isFinished = NO;
    isScrewed = NO;
    [conn start];
    while(!isFinished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

-(NSDictionary *)restToJSON:(NSString *)jsonURL paramStr:(NSString *)paramStr
{
    [self fetchURL:jsonURL paramStr:paramStr];
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:self.cumulativeData options:0 error:nil];
    [self.cumulativeData setLength:0];
    return response;
}

-(NSString *)strDataForURL:(NSString *)urlStr paramStr:(NSString *)paramStr
{
    [self fetchURL:urlStr paramStr:paramStr];
    NSString *strData = [[NSString alloc] initWithData:self.cumulativeData encoding:NSUTF8StringEncoding];
    [self.cumulativeData setLength:0];
    return strData;
}

#pragma mark - OBA API

-(NSDictionary *)agencies
{
    return [self restToJSON:@"http://onebusaway.forest.usf.edu/api/api/where/agencies-with-coverage.json" paramStr:@""];
}

-(NSDictionary *)agency
{
    return [self restToJSON:@"http://onebusaway.forest.usf.edu/api/api/where/agency/Hillsborough%20Area%20Regional%20Transit.json" paramStr:@""];
}

-(NSDictionary *)routesForAgency
{
    return [self restToJSON:@"http://onebusaway.forest.usf.edu/api/api/where/routes-for-agency/Hillsborough%20Area%20Regional%20Transit.json" paramStr:@""];
}

-(NSDictionary *)stopsForRoute:(NSString *)routeId
{
    NSString *encodedRouteId = [routeId stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"http://onebusaway.forest.usf.edu/api/api/where/stops-for-route/%@.json", encodedRouteId];
    return [self restToJSON:urlStr paramStr:@"includePolylines=false"];
}


-(NSDictionary *)tripsForRoute:(NSString *)routeId
{
    NSString *encodedRouteId = [routeId stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"http://onebusaway.forest.usf.edu/api/api/where/trips-for-route/%@.json", encodedRouteId];
    return [self restToJSON:urlStr paramStr:@""];
}

-(NSDictionary *)stop:(NSString *)stopId
{
    NSString *encodedStopId = [stopId stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"http://onebusaway.forest.usf.edu/api/api/where/stop/%@.json", encodedStopId];
    return [self restToJSON:urlStr paramStr:@"includePolylines=false"];
}

-(NSDictionary *)scheduleForStop:(NSString *)stopId
{
    NSString *encodedStopId = [stopId stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"http://onebusaway.forest.usf.edu/api/api/where/schedule-for-stop/%@.json", encodedStopId];
    return [self restToJSON:urlStr paramStr:@""];
}


-(NSDictionary *)tripDetailsForTrip:(NSString *)tripId
{
    NSString *encodedTripId = [tripId stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"http://onebusaway.forest.usf.edu/api/api/where/trip-details/%@.json", encodedTripId];
    return [self restToJSON:urlStr paramStr:@""];
}

-(NSDictionary *)vehiclesForAgency:(NSString *)agencyId
{
    NSString *encodedAgencyId = [agencyId stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"http://onebusaway.forest.usf.edu/api/api/where/vehicles-for-agency/%@.json", encodedAgencyId];
    
    if (self.offlineMode)
        urlStr = [NSMutableString stringWithString:@"http://localhost:8000/vehicles-for-agency.json"];
    
    return [self restToJSON:urlStr paramStr:@""];
}

-(NSDictionary *)stopsForLocationLat:(NSNumber *)lat Lon:(NSNumber *)lon
{
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"http://onebusaway.forest.usf.edu/api/api/where/stops-for-location.json"];
    NSString *paramStr = [NSString stringWithFormat:@"lat=%@&lon=%@", lat, lon];
    
    if (self.offlineMode)
        urlStr = [NSMutableString stringWithString:@"http://localhost:8000/stops-for-location.json"];
    
    return [self restToJSON:urlStr paramStr:paramStr];
}

-(NSDictionary *)arrivalsAndDeparturesForStop:(NSString *)stopId
{
    NSLog(@"called arrivalsanddeps");
    NSString *encodedStopId = [stopId stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"http://onebusaway.forest.usf.edu/api/api/where/arrivals-and-departures-for-stop/%@.json", encodedStopId];
    
    if (self.offlineMode)
        urlStr = [NSMutableString stringWithString:@"http://localhost:8000/arrivals-and-departures-for-stop.json"];
    
    return [self restToJSON:urlStr paramStr:@""];
}

#pragma mark - NSURLConnection/Data Delegates

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.cumulativeData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.cumulativeData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"BIRest Failed: %@", error);
    // hope we don't get here
    isFinished = YES;
    isScrewed = YES;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    isFinished = YES;
    isScrewed = NO;
}

#pragma mark - OBA API Helpers

+(NSDate *)dateFromObaTimestamp:(NSString *)timestamp
{
    double time = [timestamp doubleValue] / 1000.0;
    return [NSDate dateWithTimeIntervalSince1970:time];
}

+(NSString *)formattedDistanceFromStop:(NSNumber *)distanceFromStop
{
    float meters = [distanceFromStop floatValue];
    float miles = meters * 0.000621371192;
    NSString *distanceString = [NSString stringWithFormat:@"%.2f", miles];
    return distanceString;
}


@end
