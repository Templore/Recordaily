
#import "CoreDataController+Location.h"

@implementation CoreDataController (Location)

- (Location *)locationWithName:(NSString *)name {
    
    Location *location = nil;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kLocationKey];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"locationName = %@", name];
    
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (results.count == 0) {
        
        location = [NSEntityDescription insertNewObjectForEntityForName:kLocationKey
                                                 inManagedObjectContext:self.managedObjectContext];
    } else if (results.count == 1) {
        
        location = results.firstObject;
        
    } else {
        
        // Error or nil or the count more than one
    }
    
    return location;
}

- (void)configureLocation:(Location *)object withPropertiesInfo:(NSDictionary *)info {
    
    object.locationName = [info objectForKey:kLocationNameKey];
    
    [self saveContext];
}

- (void)removeLocation:(Location *)object {
    
    [object.locationRecords enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(Record * _Nonnull obj, BOOL * _Nonnull stop) {
        
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


#pragma mark ~ SEED INITIAL LOCATION DATA ~

- (void)seedInitialLocationData {
    
    Location *home = [self locationWithName:@"Home"];
    NSMutableDictionary *homePropertiesInfo = [NSMutableDictionary dictionary];
    
    [homePropertiesInfo setObject:@"Home" forKey:kLocationNameKey];
    
    if (home != nil) [self configureLocation:home withPropertiesInfo:homePropertiesInfo];
    
    Location *office = [self locationWithName:@"Office"];
    NSMutableDictionary *officePropertiesInfo = [NSMutableDictionary dictionary];
    
    [officePropertiesInfo setObject:@"Office" forKey:kLocationNameKey];
    
    if (office != nil) [self configureLocation:office withPropertiesInfo:officePropertiesInfo];
    
    Location *library = [self locationWithName:@"Library"];
    NSMutableDictionary *libraryPropertiesInfo = [NSMutableDictionary dictionary];
    
    [libraryPropertiesInfo setObject:@"Library" forKey:kLocationNameKey];
    
    if (library != nil) [self configureLocation:library withPropertiesInfo:libraryPropertiesInfo];
}

@end