// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Stop.m instead.

#import "_Stop.h"

const struct StopAttributes StopAttributes = {
	.code = @"code",
	.direction = @"direction",
	.id = @"id",
	.lat = @"lat",
	.lon = @"lon",
	.name = @"name",
};

const struct StopRelationships StopRelationships = {
	.relationship = @"relationship",
	.routeIds = @"routeIds",
};

const struct StopFetchedProperties StopFetchedProperties = {
};

@implementation StopID
@end

@implementation _Stop

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Stop" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Stop";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Stop" inManagedObjectContext:moc_];
}

- (StopID*)objectID {
	return (StopID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"latValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lat"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lonValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lon"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic code;






@dynamic direction;






@dynamic id;






@dynamic lat;



- (double)latValue {
	NSNumber *result = [self lat];
	return [result doubleValue];
}

- (void)setLatValue:(double)value_ {
	[self setLat:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatValue {
	NSNumber *result = [self primitiveLat];
	return [result doubleValue];
}

- (void)setPrimitiveLatValue:(double)value_ {
	[self setPrimitiveLat:[NSNumber numberWithDouble:value_]];
}





@dynamic lon;



- (double)lonValue {
	NSNumber *result = [self lon];
	return [result doubleValue];
}

- (void)setLonValue:(double)value_ {
	[self setLon:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLonValue {
	NSNumber *result = [self primitiveLon];
	return [result doubleValue];
}

- (void)setPrimitiveLonValue:(double)value_ {
	[self setPrimitiveLon:[NSNumber numberWithDouble:value_]];
}





@dynamic name;






@dynamic relationship;

	

@dynamic routeIds;

	
- (NSMutableSet*)routeIdsSet {
	[self willAccessValueForKey:@"routeIds"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"routeIds"];
  
	[self didAccessValueForKey:@"routeIds"];
	return result;
}
	






@end
