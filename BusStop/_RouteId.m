// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RouteId.m instead.

#import "_RouteId.h"

const struct RouteIdAttributes RouteIdAttributes = {
	.routeId = @"routeId",
};

const struct RouteIdRelationships RouteIdRelationships = {
};

const struct RouteIdFetchedProperties RouteIdFetchedProperties = {
};

@implementation RouteIdID
@end

@implementation _RouteId

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RouteId" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RouteId";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RouteId" inManagedObjectContext:moc_];
}

- (RouteIdID*)objectID {
	return (RouteIdID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic routeId;











@end
