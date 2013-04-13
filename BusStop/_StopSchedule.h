// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to StopSchedule.h instead.

#import <CoreData/CoreData.h>


extern const struct StopScheduleAttributes {
	__unsafe_unretained NSString *dayOfWeek;
	__unsafe_unretained NSString *headSign;
	__unsafe_unretained NSString *routeId;
	__unsafe_unretained NSString *serviceId;
	__unsafe_unretained NSString *stopId;
	__unsafe_unretained NSString *timeArrival;
	__unsafe_unretained NSString *timeDeparture;
	__unsafe_unretained NSString *tripId;
} StopScheduleAttributes;

extern const struct StopScheduleRelationships {
} StopScheduleRelationships;

extern const struct StopScheduleFetchedProperties {
} StopScheduleFetchedProperties;











@interface StopScheduleID : NSManagedObjectID {}
@end

@interface _StopSchedule : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (StopScheduleID*)objectID;





@property (nonatomic, strong) NSNumber* dayOfWeek;



@property int16_t dayOfWeekValue;
- (int16_t)dayOfWeekValue;
- (void)setDayOfWeekValue:(int16_t)value_;

//- (BOOL)validateDayOfWeek:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* headSign;



//- (BOOL)validateHeadSign:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* routeId;



//- (BOOL)validateRouteId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* serviceId;



//- (BOOL)validateServiceId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* stopId;



//- (BOOL)validateStopId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* timeArrival;



@property int64_t timeArrivalValue;
- (int64_t)timeArrivalValue;
- (void)setTimeArrivalValue:(int64_t)value_;

//- (BOOL)validateTimeArrival:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* timeDeparture;



@property int64_t timeDepartureValue;
- (int64_t)timeDepartureValue;
- (void)setTimeDepartureValue:(int64_t)value_;

//- (BOOL)validateTimeDeparture:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tripId;



//- (BOOL)validateTripId:(id*)value_ error:(NSError**)error_;






@end

@interface _StopSchedule (CoreDataGeneratedAccessors)

@end

@interface _StopSchedule (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveDayOfWeek;
- (void)setPrimitiveDayOfWeek:(NSNumber*)value;

- (int16_t)primitiveDayOfWeekValue;
- (void)setPrimitiveDayOfWeekValue:(int16_t)value_;




- (NSString*)primitiveHeadSign;
- (void)setPrimitiveHeadSign:(NSString*)value;




- (NSString*)primitiveRouteId;
- (void)setPrimitiveRouteId:(NSString*)value;




- (NSString*)primitiveServiceId;
- (void)setPrimitiveServiceId:(NSString*)value;




- (NSString*)primitiveStopId;
- (void)setPrimitiveStopId:(NSString*)value;




- (NSNumber*)primitiveTimeArrival;
- (void)setPrimitiveTimeArrival:(NSNumber*)value;

- (int64_t)primitiveTimeArrivalValue;
- (void)setPrimitiveTimeArrivalValue:(int64_t)value_;




- (NSNumber*)primitiveTimeDeparture;
- (void)setPrimitiveTimeDeparture:(NSNumber*)value;

- (int64_t)primitiveTimeDepartureValue;
- (void)setPrimitiveTimeDepartureValue:(int64_t)value_;




- (NSString*)primitiveTripId;
- (void)setPrimitiveTripId:(NSString*)value;




@end
