// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Route.h instead.

#import <CoreData/CoreData.h>


extern const struct RouteAttributes {
	__unsafe_unretained NSString *distance;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *numStops;
	__unsafe_unretained NSString *routeid;
	__unsafe_unretained NSString *shortName;
	__unsafe_unretained NSString *url;
} RouteAttributes;

extern const struct RouteRelationships {
	__unsafe_unretained NSString *stops;
} RouteRelationships;

extern const struct RouteFetchedProperties {
} RouteFetchedProperties;

@class Stop;








@interface RouteID : NSManagedObjectID {}
@end

@interface _Route : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RouteID*)objectID;





@property (nonatomic, strong) NSNumber* distance;



@property double distanceValue;
- (double)distanceValue;
- (void)setDistanceValue:(double)value_;

//- (BOOL)validateDistance:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* numStops;



@property int32_t numStopsValue;
- (int32_t)numStopsValue;
- (void)setNumStopsValue:(int32_t)value_;

//- (BOOL)validateNumStops:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* routeid;



//- (BOOL)validateRouteid:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* shortName;



//- (BOOL)validateShortName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *stops;

- (NSMutableSet*)stopsSet;





@end

@interface _Route (CoreDataGeneratedAccessors)

- (void)addStops:(NSSet*)value_;
- (void)removeStops:(NSSet*)value_;
- (void)addStopsObject:(Stop*)value_;
- (void)removeStopsObject:(Stop*)value_;

@end

@interface _Route (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveDistance;
- (void)setPrimitiveDistance:(NSNumber*)value;

- (double)primitiveDistanceValue;
- (void)setPrimitiveDistanceValue:(double)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveNumStops;
- (void)setPrimitiveNumStops:(NSNumber*)value;

- (int32_t)primitiveNumStopsValue;
- (void)setPrimitiveNumStopsValue:(int32_t)value_;




- (NSString*)primitiveRouteid;
- (void)setPrimitiveRouteid:(NSString*)value;




- (NSString*)primitiveShortName;
- (void)setPrimitiveShortName:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (NSMutableSet*)primitiveStops;
- (void)setPrimitiveStops:(NSMutableSet*)value;


@end
