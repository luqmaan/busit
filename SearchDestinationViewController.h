//
//  SearchDestinationViewController.h
//  BusStop
//
//  Created by Adam Lowther on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"

@interface SearchDestinationViewController : UIViewController <UISearchBarDelegate, CLLocationManagerDelegate, MKMapViewDelegate> {
    CLLocationManager *locationManager;
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapToDisplayAddressFromSearchBar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarForAddress;

-(void)displayError:(NSString *)errorMessage;

@end
