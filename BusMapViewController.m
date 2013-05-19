//
//  BusMapViewController.m
//  BusStop
//
//  Created by Lolcat on 18/05/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BusMapViewController.h"

@interface BusMapViewController ()

@end

@implementation BusMapViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"init with coder");
    if(self = [super initWithCoder:aDecoder]) {        
        bench = [[BusStopREST alloc] init];
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
    NSDictionary *apiData = [bench vehiclesForAgency:@"Hillsborough Area Regional Transit"];
    
    NSArray *vehicles = [[apiData objectForKey:@"data"] objectForKey:@"list"];
    
    for (NSDictionary *vehicleDict in vehicles) {
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
