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
}

@property (nonatomic, strong) NSDictionary *apiData;

@end

@implementation BusMapViewController

@synthesize apiData, bench;

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"init with coder");
    if(self = [super initWithCoder:aDecoder]) {        
        bench = [[BusStopREST alloc] init];
        apiData = [[NSDictionary alloc]init];
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
    [self updateAPIData];
    [self addVehiclesToRoutes];
    
}

- (void)updateAPIData
{
    apiData = [bench vehiclesForAgency:@"Hillsborough Area Regional Transit"];
}

- (void)addVehiclesToRoutes {
    
    for (NSDictionary *vehicleDict in [[apiData objectForKey:@"data"] objectForKey:@"list"]) {
        if ([vehicleDict objectForKey:@"tripStatus"] == nil || [[vehicleDict objectForKey:@"tripId"] isEqual: @""])
        {
            NSLog(@"discard");
        }
        else {
            NSLog(@"vehiclesDict: %@", vehicleDict);
            BMVehicle *vehicleTest = [[BMVehicle alloc] initWithJSON:vehicleDict
                                                          andAPIData:&apiData];
            NSLog(@"vehiclesTest: %@", vehicleTest);
            break;
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
