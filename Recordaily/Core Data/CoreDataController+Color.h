
#import "CoreDataController.h"
#import "Color.h"

@interface CoreDataController (Color)

// Insert a new object or return a existing one or nil
- (Color *)colorWithName:(NSString *)name;

// Before configure, ensure that the return value of '-colorWithName:' is not nil
- (void)configureColor:(Color *)object withPropertiesInfo:(NSDictionary *)info;


- (void)seedInitialColorData;

@end