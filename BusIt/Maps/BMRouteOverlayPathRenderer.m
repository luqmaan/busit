//
//  BMRouteOverlayPathRenderer.m
//  BusIt
//
//  Created by Luq on 11/8/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BMRouteOverlayPathRenderer.h"

@implementation BMRouteOverlayPathRenderer

- (id)initWithShapes:(NSArray *)shapes
{
    self = [super init];
    if (self)
    {
//        float minLat, minLon = 180.0;
//        float maxLat, maxLon = -180.0;
//        MKMapPoint minLatP, minLonP, maxLatP, maxLonP;
//        for (BIShape *shape in shapes) {
//            if (shape.lat < minLat) {
//                minLat = shape.lat;
//                minLatP = shape.point;
//            }
//            if (shape.lat > maxLat) {
//                maxLat = shape.lat;
//                maxLatP = shape.point;
//            }
//            if (shape.lon < minLon) {
//                minLon = shape.lon;
//                minLonP = shape.point;
//            }
//            if (shape.lon > maxLon) {
//                maxLon = shape.lon;
//                maxLonP = shape.point;
//            }
//        }
//        self.shapes = shapes;
//        BIShape *s = shapes[0];
//        self.coordinate = s.location; // should use average of max/min instead
//        double width, height;
//        self.boundingMapRect = MKMapRectMake(minLon, minLat, width, height);
    }
    return self;
}

- (void)createPath
{
//    CGMutablePathRef path = CGPathCreateMutable();
//    int i = 0;
//    for (BIShape *shape in self.shapes) {
//        i++;
//        if (i == 1) {
//            CGPathMoveToPoint(path, NULL, shape.point.x, shape.point.y);
//            continue;
//        }
//        CGPathAddLineToPoint(path, NULL, shape.point.x, shape.point.y);
//    }
//    CGPathCloseSubpath(path);
//    self.fillColor = [UIColor redColor];
//    self.path = path;
    
}

@end
