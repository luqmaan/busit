//
//  BusStopManager.h
//  BusStop
//
//  Created by Chris Woodard on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Route.h"
#import "Stop.h"
#import <CoreData/CoreData.h>

@interface BusStopManager : NSObject 

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStore *store;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coord;
@property (nonatomic, strong) NSOperationQueue *opQueue;

+(BusStopManager *)sharedManagerWithOnDiskStore;

-(void)updateBusRouteDataWithCompletion:(void (^)(void))completion failure:(void (^)(void))failure;

-(NSArray *)routes;
-(Route *)routeForId:(NSString *)routeId;
-(Stop *)stopForId:(NSString *)stopId;
-(NSArray *)stopsClosestToLatitude:(double)latitude andLogitude:(double)longitude withinMeters:(double)distanceInMeters limit:(NSInteger)numStopsToReturn;

@end
