//
//  BusMapViewController.h
//  BusStop
//
//  Created by Lolcat on 18/05/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BusStopREST.h"
#import "BMVehicle.h"

@interface BusMapViewController : UIViewController {
    BusStopREST *bench;
}

@end
