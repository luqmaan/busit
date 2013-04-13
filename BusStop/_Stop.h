// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Stop.h instead.

#import <CoreData/CoreData.h>


extern const struct StopAttributes {
	 NSString *code;
	 NSString *direction;
	 NSString *id;
	 NSString *lat;
	 NSString *lon;
	 NSString *name;
} StopAttributes;

extern const struct StopRelationships {
	 NSString *relationship;
} StopRelationships;

extern const struct StopFetchedProperties {
} StopFetchedProperties;

@class Route;








@interface StopID : NSManagedObjectID {}
@end

@interface _Stop : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (StopID*)objectID;





@property (nonatomic, retain) NSString* code;



//- (BOOL)validateCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* direction;



//- (BOOL)validateDirection:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSNumber* lat;



@property double latValue;
- (double)latValue;
- (void)setLatValue:(double)value_;

//- (BOOL)validateLat:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSNumber* lon;



@property double lonValue;
- (double)lonValue;
- (void)setLonValue:(double)value_;

//- (BOOL)validateLon:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) Route *relationship;

//- (BOOL)validateRelationship:(id*)value_ error:(NSError**)error_;





@end

@interface _Stop (CoreDataGeneratedAccessors)

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


@end
