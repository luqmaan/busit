//
//  BusStopViewController.m
//  BusStop
//
//  Created by Chris Woodard on 4/12/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BusStopViewController.h"
#import "BusStopManager.h"
#import "BusStopREST.h"

@interface BusStopViewController ()

@end

@implementation BusStopViewController

-(void)showHUD:(NSString *)hudMsg
{
    if(nil == hud)
    {
        hud = [[MBProgressHUD alloc] init];
        hud.labelText = hudMsg;
        [self.view addSubview:hud];
        [hud show:YES];
    }
}

-(void)updateHUD:(NSString *)hudMsg
{
    hud.labelText = hudMsg;
}

-(void)hideHUD
{
    [hud hide:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // actually, do refresh of data here
#if 0
    BusStopREST *bench = [[BusStopREST alloc] init];
    NSDictionary *routes = [bench routesForAgency];
    NSLog(@"routes: %@", routes[@"data"][@"list"]);
    sleep(2);
    NSDictionary *stops = [bench stopsForRoute:@"Hillsborough Area Regional Transit_8"];
    NSLog(@"stops: %@", stops);
    sleep(2);
    NSDictionary *stop = [bench stop:@"Hillsborough Area Regional Transit_2553"];
    NSLog(@"stop: %@", stop);
#endif
   
    BusStopManager *bsm = [[BusStopManager alloc] init];
    [bsm updateBusRouteDataWithCompletion:nil failure:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        dispatch_sync(dispatch_get_main_queue(),^{
            [self showHUD:@"Updating routes"];
        });
        
        BusStopManager *mgr = [[BusStopManager alloc] init];
        
        [mgr updateBusRouteDataWithCompletion:^{
            }
            failure:^{
        }];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self hideHUD];
        });
        
    });

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
