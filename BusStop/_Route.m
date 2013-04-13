// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Route.m instead.

#import "_Route.h"

const struct RouteAttributes RouteAttributes = {
	.id = @"id",
	.name = @"name",
	.shortName = @"shortName",
	.url = @"url",
};

const struct RouteRelationships RouteRelationships = {
	.stops = @"stops",
};

const struct RouteFetchedProperties RouteFetchedProperties = {
};

@implementation RouteID
@end

@implementation _Route

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Route" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Route";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Route" inManagedObjectContext:moc_];
}

- (RouteID*)objectID {
	return (RouteID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic id;






@dynamic name;






@dynamic shortName;






@dynamic url;






@dynamic stops;

	
- (NSMutableSet*)stopsSet {
	[self willAccessValueForKey:@"stops"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"stops"];
  
	[self didAccessValueForKey:@"stops"];
	return result;
}
	






@end
