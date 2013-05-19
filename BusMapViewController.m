//
//  BusMapViewController.m
//  BusStop
//
//  Created by Lolcat on 18/05/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BusMapViewController.h"

@interface BusMapViewController () {
    NSDictionary *apiData;
    BusStopREST *bench;
    BMRoutes *routes;
    NSString *agencyId;
    BMOptions *mapOptions;
}

@property (nonatomic, retain) BusStopREST *bench;
@property (nonatomic, retain) NSDictionary *apiData;

@end

@implementation BusMapViewController

@synthesize apiData, bench;

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"init with coder");
    if(self = [super initWithCoder:aDecoder]) {        
        bench = [[BusStopREST alloc] init];
        apiData = [[NSDictionary alloc]init];
        agencyId = @"Hillsborough Area Regional Transit";
        mapOptions = [[BMOptions alloc] init];
        routes = [[BMRoutes alloc] init];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMap];
    [self updateAPIData];
    [self updateRoutes];
    [self addVehiclesToRoutes];
}

- (void)initMap
{
    
};

- (void)updateAPIData
{
    apiData = [bench vehiclesForAgency:agencyId];
}

- (void)updateRoutes
{
    for (NSDictionary *routesDict in apiData[@"data"][@"references"][@"routes"]) {
        [routes addRouteWithRoutesDict:routesDict];
        [mapOptions addRouteWithRoutesDict:routesDict];
    }
}

- (void)addVehiclesToRoutes {
    
    for (NSDictionary *vehicleDict in apiData[@"data"][@"list"]) {
        if (vehicleDict[@"tripStatus"] == nil || [vehicleDict[@"tripId"] isEqual: @""])
        {
            NSLog(@"discard");
            continue;
        }
        NSLog(@"vehiclesDict: %@", vehicleDict);
        BMVehicle *vehicle = [[BMVehicle alloc] initWithJSON:vehicleDict
                                                      andAPIData:&apiData];
        
        [routes addVehicle:vehicle];
        NSLog(@"vehiclesTest: %@", vehicle);
    }
    
    NSLog(@"Routes: %@", routes);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
