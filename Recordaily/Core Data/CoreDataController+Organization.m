
#import "CoreDataController+Organization.h"

@implementation CoreDataController (Organization)

- (Organization *)organizationWithName:(NSString *)name {
    
    Organization *organization = nil;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kOrganizationKey];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"organizationName = %@", name];
    
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (results.count == 0) {
        
        organization = [NSEntityDescription insertNewObjectForEntityForName:kOrganizationKey
                                                     inManagedObjectContext:self.managedObjectContext];
    } else if (results.count == 1) {
        
        organization = results.firstObject;
        
    } else {
        
        // Error or nil or the count more than one
    }
    
    return organization;
}

- (void)configureOrganization:(Organization *)object withPropertiesInfo:(NSDictionary *)info {
    
    object.organizationName = [info objectForKey:kOrganizationNameKey];
    object.organizationDescription = [info objectForKey:kOrganizationDescriptionKey];
    
    NSString *colorName = [info objectForKey:kColorNameKey];
    Color *color = [self colorWithName:colorName];
    object.organizationColor = color;
    
    [self saveContext];
}

- (void)removeOrganization:(Organization *)object {
    
    [object.organizationRecords enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(Record * _Nonnull obj, BOOL * _Nonnull stop) {
        
        if (obj.recordDueDate == nil) {
            
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"kUnfinishedEventCount"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"kUnfinishedEventUniqueID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }];
    
    /* 
     *  If delete, all records associated with it will also be deleted.
     *  Set the delete rule in '.xcdatamodeld' file.
     */
    [self.managedObjectContext deleteObject:object];
    
    [self saveContext];
}


#pragma mark ~ SEED INITIAL ORGANIZATION DATA ~

- (void)seedInitialOrganizationData {
    
    Organization *personal = [self organizationWithName:@"Personal"];
    NSMutableDictionary *personalPropertiesInfo = [NSMutableDictionary dictionary];
    Color *personalColor = [self colorWithName:@"Sea Foam"];
    
    [personalPropertiesInfo setObject:@"Personal" forKey:kOrganizationNameKey];
    [personalPropertiesInfo setObject:@"" forKey:kOrganizationDescriptionKey];
    
    if (personalColor != nil && personal != nil)
    {
        [personalPropertiesInfo setObject:personalColor.colorName forKey:kColorNameKey];
        [self configureOrganization:personal withPropertiesInfo:personalPropertiesInfo];
    }
    
    Organization *work = [self organizationWithName:@"Work"];
    NSMutableDictionary *workPropertiesInfo = [NSMutableDictionary dictionary];
    Color *workColor = [self colorWithName:@"Aqua"];
    
    [workPropertiesInfo setObject:@"Work" forKey:kOrganizationNameKey];
    [workPropertiesInfo setObject:@"" forKey:kOrganizationDescriptionKey];
    
    if (workColor != nil && work != nil)
    {
        [workPropertiesInfo setObject:workColor.colorName forKey:kColorNameKey];
        [self configureOrganization:work withPropertiesInfo:workPropertiesInfo];
    }
    
    Organization *family = [self organizationWithName:@"Family"];
    NSMutableDictionary *familyPropertiesInfo = [NSMutableDictionary dictionary];
    Color *familyColor = [self colorWithName:@"Salmon"];
    
    [familyPropertiesInfo setObject:@"Family" forKey:kOrganizationNameKey];
    [familyPropertiesInfo setObject:@"" forKey:kOrganizationDescriptionKey];
    
    if (familyColor != nil && family != nil)
    {
        [familyPropertiesInfo setObject:familyColor.colorName forKey:kColorNameKey];
        [self configureOrganization:family withPropertiesInfo:familyPropertiesInfo];
    }
}

@end