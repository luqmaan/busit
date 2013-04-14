// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RouteId.h instead.

#import <CoreData/CoreData.h>


extern const struct RouteIdAttributes {
	__unsafe_unretained NSString *routeId;
} RouteIdAttributes;

extern const struct RouteIdRelationships {
} RouteIdRelationships;

extern const struct RouteIdFetchedProperties {
} RouteIdFetchedProperties;




@interface RouteIdID : NSManagedObjectID {}
@end

@interface _RouteId : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RouteIdID*)objectID;





@property (nonatomic, strong) NSString* routeId;



//- (BOOL)validateRouteId:(id*)value_ error:(NSError**)error_;






@end

@interface _RouteId (CoreDataGeneratedAccessors)

@end

@interface _RouteId (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveRouteId;
- (void)setPrimitiveRouteId:(NSString*)value;




@end
