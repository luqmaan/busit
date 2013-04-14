//
//  SearchStartingViewController.h
//  BusStop
//
//  Created by Adam Lowther on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SearchStartingViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray *placemarkFromDestination;
@property (strong, nonatomic) CLPlacemark *placemarkToPass;

@end
