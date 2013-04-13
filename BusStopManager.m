//
//  BusStopManager.m
//  BusStop
//
//  Created by Chris Woodard on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "BusStopManager.h"
#import "MBProgressHUD.h"
#import "BusStopREST.h"
#import "Route.h"
#import "Stop.h"

@implementation BusStopManager

+(BusStopManager *)sharedManagerWithOnDiskStore
{
	static BusStopManager *sharedMgr = nil;
	static dispatch_once_t token = 0;
	dispatch_once( &token, ^{
		sharedMgr = [[BusStopManager alloc] init];
		sharedMgr.model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"BusRoutes" ofType:@"momd"]]];

        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
    						 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
    						 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
		sharedMgr.coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:sharedMgr.model];
        
		sharedMgr.context = [[NSManagedObjectContext alloc] init];
		[sharedMgr.context setPersistentStoreCoordinator:sharedMgr.coord];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSURL *storeURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/BusRoutes.db", paths[0]]];
        
		sharedMgr.store = [sharedMgr.coord addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:NULL];
        
        sharedMgr.opQueue = [[NSOperationQueue alloc] init];
	});
	return sharedMgr;
}

//TBD - need something else to fill in.  on the way in how about counting up the number of stops and total length of route?
// maybe how frequently the bus runs as well.
-(void)addRouteWithInfo:(NSDictionary *)infoDict
{
    Route *newRoute = [NSEntityDescription insertNewObjectForEntityForName:@"Route" inManagedObjectContext:self.context];
    newRoute.name = infoDict[@"longName"];
    newRoute.shortName = infoDict[@"shortName"];
    newRoute.id = infoDict[@"id"];
    newRoute.stops = [NSMutableSet set];
    NSArray *stops = infoDict[@"stops"];
    for( NSDictionary *stop in stops )
    {
        Stop *newStop = [NSEntityDescription insertNewObjectForEntityForName:@"Stop" inManagedObjectContext:self.context];
        newStop.name = stop[@"name"];
        newStop.code = stop[@"code"];
        newStop.id = stop[@"id"];
        newStop.direction = stop[@"direction"];
        newStop.lat = stop[@"lat"];
        newStop.lon = stop[@"lon"];
        
        [newRoute addStopsObject:newStop];
    }
}

-(void)updateBusRouteDataWithCompletion:(void (^)(void))completion failure:(void (^)(void))failure
{
    BusStopREST *bench = [[BusStopREST alloc] init];
    
    NSArray *allRoutes = [self routes];
    for( Route *route in allRoutes )
    {
        [self.context deleteObject:route];
    }
    
    NSMutableDictionary *routesList = [NSMutableDictionary dictionaryWithCapacity:0];
    
    // get routes and add them to CD store, including route details
    NSDictionary *routes = [bench routesForAgency];
    for( NSDictionary *route in routes[@"data"][@"list"] )
    {
        NSMutableDictionary *routeDict = [NSMutableDictionary dictionaryWithCapacity:0];
        routeDict[@"routeId"] = route[@"id"];
        routeDict[@"longName"] = route[@"longName"];
        routeDict[@"shortName"] = route[@"shortName"];
        routesList[route[@"id"]] = routeDict;
        
        sleep(1);
        // for each route, get stops - name, lat/lon, direction etc.
        NSDictionary *stops = [bench stopsForRoute:route[@"id"]];
        
        #if 0
        // defines legs of route
        NSArray *stopGroupings = stops[@"data"][@"entry"][@"stopGroupings"];
        for( NSDictionary *grp in stopGroupings )
        {
            NSString *grpId = grp[@"id"];
            NSArray *stopGrps = grp[@"stopGroups"];
            for( NSDictionary *stopGrouping in stopGrps )
            {
                NSString *grpName = stopGrouping[@"name"][@"name"];
                NSString *grpType = stopGrouping[@"name"][@"type"];
                NSArray *grpStops = stopGrouping[@"stopIds"];
                
                NSLog(@"stopGroup name: %@", grpName);
                NSLog(@"stopGroup type: %@", grpType);
                NSLog(@"stopGroup stops: %@", grpStops);
            }
        }
        #endif
        
        // has actual stops data
        NSDictionary *refs = stops[@"data"][@"references"];
        NSArray *stops1 = nil;
        if(nil != refs)
            stops1 = refs[@"stops"];
//        stops1 = stops[@"data"][@"references"][@"stops"];
        if(nil != stops1)
        {
            NSLog(@"about to add stops");
            for( NSDictionary *stop in stops1 )
            {
                NSLog(@"candidate stop: %@", stop);
                NSDictionary *busStop = @{@"name":stop[@"name"], @"code":stop[@"code"], @"id":stop[@"id"], @"direction":stop[@"direction"], @"lat":stop[@"lat"], @"lon":stop[@"lon"]};
                NSLog(@"bus stop: %@", busStop);
                NSArray *routeIds = stop[@"routeIds"];
                for( NSString *routeId in routeIds )
                {
                    NSMutableDictionary *route = routesList[routeId];
                    if(nil == route[@"stops"])
                        route[@"stops"] = [NSMutableArray arrayWithCapacity:0];
                    [route[@"stops"] addObject:busStop];
                }
            }
            NSLog(@"Added stops.");
        }
    }
    
    
    NSLog(@"%@", routesList);
    
    // now that we've got the routes and stops, we can write them ou tto CoreData
    for( NSString *routeId in [routesList allKeys])
    {
        [self addRouteWithInfo:routesList[routeId]];
    }

    [self.context save:nil];
 }

-(NSArray *)routes
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Route"];
    NSArray *rows = [self.context executeFetchRequest:fetchRequest error:nil];
    return rows;
}

-(Route *)routeForId:(NSString *)routeId
{
    Route *route = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Route"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id = %@", routeId];
    NSArray *rows = [self.context executeFetchRequest:fetchRequest error:nil];
    if(rows.count>0)
        route = rows[0];
    return route;
}

-(Stop *)stopForId:(NSString *)stopId
{
    Stop *busStop = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Stop"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id = %@", stopId];
    NSArray *rows = [self.context executeFetchRequest:fetchRequest error:nil];
    if(rows.count>0)
        busStop = rows[0];
    return busStop;
}

@end
