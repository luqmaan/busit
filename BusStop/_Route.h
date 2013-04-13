// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Route.h instead.

#import <CoreData/CoreData.h>


extern const struct RouteAttributes {
	 NSString *id;
	 NSString *name;
	 NSString *shortName;
} RouteAttributes;

extern const struct RouteRelationships {
	 NSString *stops;
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





@property (nonatomic, retain) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* shortName;



//- (BOOL)validateShortName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSSet *stops;

- (NSMutableSet*)stopsSet;





@end

@interface _Route (CoreDataGeneratedAccessors)

- (void)addStops:(NSSet*)value_;
- (void)removeStops:(NSSet*)value_;
- (void)addStopsObject:(Stop*)value_;
- (void)removeStopsObject:(Stop*)value_;

@end

@interface _Route (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveShortName;
- (void)setPrimitiveShortName:(NSString*)value;





- (NSMutableSet*)primitiveStops;
- (void)setPrimitiveStops:(NSMutableSet*)value;


@end
