// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to StopSchedule.m instead.

#import "_StopSchedule.h"

const struct StopScheduleAttributes StopScheduleAttributes = {
	.dayOfWeek = @"dayOfWeek",
	.headSign = @"headSign",
	.routeId = @"routeId",
	.serviceId = @"serviceId",
	.stopId = @"stopId",
	.timeArrival = @"timeArrival",
	.timeDeparture = @"timeDeparture",
	.tripId = @"tripId",
};

const struct StopScheduleRelationships StopScheduleRelationships = {
};

const struct StopScheduleFetchedProperties StopScheduleFetchedProperties = {
};

@implementation StopScheduleID
@end

@implementation _StopSchedule

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"StopSchedule" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"StopSchedule";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"StopSchedule" inManagedObjectContext:moc_];
}

- (StopScheduleID*)objectID {
	return (StopScheduleID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"dayOfWeekValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"dayOfWeek"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"timeArrivalValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"timeArrival"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"timeDepartureValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"timeDeparture"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic dayOfWeek;



- (int16_t)dayOfWeekValue {
	NSNumber *result = [self dayOfWeek];
	return [result shortValue];
}

- (void)setDayOfWeekValue:(int16_t)value_ {
	[self setDayOfWeek:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveDayOfWeekValue {
	NSNumber *result = [self primitiveDayOfWeek];
	return [result shortValue];
}

- (void)setPrimitiveDayOfWeekValue:(int16_t)value_ {
	[self setPrimitiveDayOfWeek:[NSNumber numberWithShort:value_]];
}





@dynamic headSign;






@dynamic routeId;






@dynamic serviceId;






@dynamic stopId;






@dynamic timeArrival;



- (int64_t)timeArrivalValue {
	NSNumber *result = [self timeArrival];
	return [result longLongValue];
}

- (void)setTimeArrivalValue:(int64_t)value_ {
	[self setTimeArrival:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveTimeArrivalValue {
	NSNumber *result = [self primitiveTimeArrival];
	return [result longLongValue];
}

- (void)setPrimitiveTimeArrivalValue:(int64_t)value_ {
	[self setPrimitiveTimeArrival:[NSNumber numberWithLongLong:value_]];
}





@dynamic timeDeparture;



- (int64_t)timeDepartureValue {
	NSNumber *result = [self timeDeparture];
	return [result longLongValue];
}

- (void)setTimeDepartureValue:(int64_t)value_ {
	[self setTimeDeparture:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveTimeDepartureValue {
	NSNumber *result = [self primitiveTimeDeparture];
	return [result longLongValue];
}

- (void)setPrimitiveTimeDepartureValue:(int64_t)value_ {
	[self setPrimitiveTimeDeparture:[NSNumber numberWithLongLong:value_]];
}





@dynamic tripId;











@end
