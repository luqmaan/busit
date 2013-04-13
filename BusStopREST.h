//
//  BusStopREST.h
//  BusStop
//
//  Created by Chris Woodard on 4/12/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusStopREST : NSObject <NSURLConnectionDelegate> {
    NSMutableData *cumulativeData;
}

-(NSDictionary *)restToJSON:(NSString *)jsonURL;
-(NSDictionary *)agencies;

@end
