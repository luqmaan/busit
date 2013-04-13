//
//  BusStopViewController.m
//  BusStop
//
//  Created by Chris Woodard on 4/12/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BusStopViewController.h"
#import "BusStopREST.h"

@interface BusStopViewController ()

@end

@implementation BusStopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // actually, do refresh of data here
#if 0
    BusStopREST *bench = [[BusStopREST alloc] init];
    NSDictionary *agencyInfo = [bench agencies];
    NSLog(@"agencies %@", agencyInfo);
    sleep(2);
    NSDictionary *agency = [bench agency];
    NSLog(@"agency %@", agency);
    sleep(2);
    NSDictionary *routes = [bench routesForAgency];
    NSLog(@"routes: %@", routes);
    sleep(2);
    NSDictionary *stops = [bench stopsForRoute:@"Hillsborough Area Regional Transit_8"];
    NSLog(@"stops: %@", stops);
    sleep(2);
    NSDictionary *stop = [bench stop:@"Hillsborough Area Regional Transit_2553"];
    NSLog(@"stop: %@", stop);
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
