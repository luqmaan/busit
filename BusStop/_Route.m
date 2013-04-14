// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Route.m instead.

#import "_Route.h"

const struct RouteAttributes RouteAttributes = {
	.distance = @"distance",
	.name = @"name",
	.numStops = @"numStops",
	.routeid = @"routeid",
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
	
	if ([key isEqualToString:@"distanceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"distance"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"numStopsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numStops"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic distance;



- (double)distanceValue {
	NSNumber *result = [self distance];
	return [result doubleValue];
}

- (void)setDistanceValue:(double)value_ {
	[self setDistance:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveDistanceValue {
	NSNumber *result = [self primitiveDistance];
	return [result doubleValue];
}

- (void)setPrimitiveDistanceValue:(double)value_ {
	[self setPrimitiveDistance:[NSNumber numberWithDouble:value_]];
}





@dynamic name;






@dynamic numStops;



- (int32_t)numStopsValue {
	NSNumber *result = [self numStops];
	return [result intValue];
}

- (void)setNumStopsValue:(int32_t)value_ {
	[self setNumStops:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveNumStopsValue {
	NSNumber *result = [self primitiveNumStops];
	return [result intValue];
}

- (void)setPrimitiveNumStopsValue:(int32_t)value_ {
	[self setPrimitiveNumStops:[NSNumber numberWithInt:value_]];
}





@dynamic routeid;






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
