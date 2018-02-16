
#import "CoreDataController.h"
#import "Organization.h"

@interface CoreDataController (Organization)

// Insert a new object or return a existing one or nil
- (Organization *)organizationWithName:(NSString *)name;

// Before configure, ensure that the return value of '-organizationWithName:' is not nil
- (void)configureOrganization:(Organization *)object withPropertiesInfo:(NSDictionary *)info;

// Before remove, ensure that the return value of '-organizationWithName:' is not nil
- (void)removeOrganization:(Organization *)object;


- (void)seedInitialOrganizationData;

@end