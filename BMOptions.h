//
//  BIBusMapOptions.h
//  BusStop
//
//  Created by Lolcat on 18/05/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BIOptions : NSMutableDictionary {
    NSMutableArray* visibleRouteIds;
}

@property (nonatomic, retain) NSMutableArray* visibleRouteIds;

@end

