
#import "CoreDataController.h"
#import "Location.h"

@interface CoreDataController (Location)

// Insert a new object or return a existing one or nil
- (Location *)locationWithName:(NSString *)name;

// Before configure, ensure that the return value of '-locationWithName:' is not nil
- (void)configureLocation:(Location *)object withPropertiesInfo:(NSDictionary *)info;

// Before remove, ensure that the return value of '-locationWithName:' is not nil
- (void)removeLocation:(Location *)object;


- (void)seedInitialLocationData;

@end