//
//  BMEmbeddedMapViewController.h
//  BusIt
//
//  Created by Lolcat on 8/26/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BMEmbeddedMapViewController : UIViewController  <MKMapViewDelegate>

// not actual init's
- (void)initWithStop:(NSDictionary *)stop andBuses:(NSArray *)busList;
- (void)initWithStops:(NSDictionary *)apiData;
- (void)initWithRoute:(NSArray *)route andShape:(NSDictionary *)shape;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
