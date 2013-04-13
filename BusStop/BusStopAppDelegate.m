//
//  BusStopAppDelegate.m
//  BusStop
//
//  Created by Chris Woodard on 4/12/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BusStopAppDelegate.h"
#import "BusStopREST.h"

@implementation BusStopAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
#if 1
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

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
