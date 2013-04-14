//
//  BusRouteOptionsViewController.h
//  BusStop
//
//  Created by Adam Lowther on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BusRouteOptionsViewController : UITableViewController

@property (nonatomic, strong) CLPlacemark *destinationPlacemark;
@property (nonatomic, strong) CLPlacemark *startingPlacemark;

@property (nonatomic, strong) NSArray *possibleRoutes;
@end
