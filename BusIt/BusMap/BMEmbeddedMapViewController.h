//
//  BMEmbeddedMapViewController.h
//  BusIt
//
//  Created by Lolcat on 8/26/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BMStopAnnotationView.h"
#import "BMStopAnnotation.h"
#import "BDStop.H"
#import "BNNearbyViewController.h"


@interface BMEmbeddedMapViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate>

//  http://stackoverflow.com/questions/14968321/container-view-controllers-notify-parent-of-action/18420800#18420800
typedef void(^ActionBlock)();

/** Trigger an action in the parent VC. Used to update the parent VC after the EmbeddedMapView updates its location. */
@property (nonatomic, copy) ActionBlock didUpdateLocationBlock;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *btnUserLocation;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

// not actual init's
- (void)addStopsToMap:(NSArray *)stops;
//- (void)initWithStop:(NSDictionary *)stop andBuses:(NSArray *)busList;
//- (void)initWithRoute:(NSArray *)route andShape:(NSDictionary *)shape;
- (IBAction)zoomToUserLocation:(id)sender;
- (IBAction)showSearchBar:(id)sender;

@end
