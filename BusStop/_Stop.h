// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Stop.h instead.

#import <CoreData/CoreData.h>


extern const struct StopAttributes {
	__unsafe_unretained NSString *code;
	__unsafe_unretained NSString *direction;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *lat;
	__unsafe_unretained NSString *lon;
	__unsafe_unretained NSString *name;
} StopAttributes;

extern const struct StopRelationships {
	__unsafe_unretained NSString *relationship;
	__unsafe_unretained NSString *routeIds;
} StopRelationships;

extern const struct StopFetchedProperties {
} StopFetchedProperties;

@class Route;
@class RouteId;








@interface StopID : NSManagedObjectID {}
@end

@interface _Stop : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (StopID*)objectID;





@property (nonatomic, strong) NSString* code;



//- (BOOL)validateCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* direction;



//- (BOOL)validateDirection:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lat;



@property double latValue;
- (double)latValue;
- (void)setLatValue:(double)value_;

//- (BOOL)validateLat:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lon;



@property double lonValue;
- (double)lonValue;
- (void)setLonValue:(double)value_;

//- (BOOL)validateLon:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Route *relationship;

//- (BOOL)validateRelationship:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *routeIds;

- (NSMutableSet*)routeIdsSet;





@end

@interface _Stop (CoreDataGeneratedAccessors)

- (void)addRouteIds:(NSSet*)value_;
- (void)removeRouteIds:(NSSet*)value_;
- (void)addRouteIdsObject:(RouteId*)value_;
- (void)removeRouteIdsObject:(RouteId*)value_;

@end

@interface _Stop (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCode;
- (void)setPrimitiveCode:(NSString*)value;




- (NSString*)primitiveDirection;
- (void)setPrimitiveDirection:(NSString*)value;




- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSNumber*)primitiveLat;
- (void)setPrimitiveLat:(NSNumber*)value;

- (double)primitiveLatValue;
- (void)setPrimitiveLatValue:(double)value_;




- (NSNumber*)primitiveLon;
- (void)setPrimitiveLon:(NSNumber*)value;

- (double)primitiveLonValue;
- (void)setPrimitiveLonValue:(double)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (Route*)primitiveRelationship;
- (void)setPrimitiveRelationship:(Route*)value;



- (NSMutableSet*)primitiveRouteIds;
- (void)setPrimitiveRouteIds:(NSMutableSet*)value;


@end
