
#import "CoreDataController+Record.h"

@implementation CoreDataController (Record)

- (Record *)insertRecordWithPropertiesInfo:(NSDictionary *)info {
    
    Record *record = [NSEntityDescription insertNewObjectForEntityForName:kRecordKey
                                                   inManagedObjectContext:self.managedObjectContext];
    [self configureRecord:record withPropertiesInfo:info];
    
    [self saveContext];
    
    return record;
}

- (void)removeRecordWithUniqueID:(NSString *)uniqueID {
    
    Record *record = [self recordWithUniqueID:uniqueID];
    
    [self.managedObjectContext deleteObject:record];
    
    [self saveContext];
}

- (void)updateRecordWithUniqueID:(NSString *)uniqueID propertiesInfo:(NSDictionary *)info {
    
    Record *record = [self recordWithUniqueID:uniqueID];
    
    [self configureRecord:record withPropertiesInfo:info];
    
    [self saveContext];
}

- (void)configureRecord:(Record *)record withPropertiesInfo:(NSDictionary *)info {
    
    record.recordUniqueID   = [self uniqueIDWithManagedObject:record];
    record.recordSubject    = [info objectForKey:kRecordSubjectKey]; // Required!
    record.recordDate       = [info objectForKey:kRecordDateKey]; // Required!
    record.recordDueDate    = [info objectForKey:kRecordDueDateKey]; // If non-nil, then required!
    record.recordSectionID  = [self dateNumberFromDate:record.recordDate];
    
    NSString *organizationName = [info objectForKey:kOrganizationNameKey]; // Required!
    Organization *organization = [self organizationWithName:organizationName];
    record.recordOrganization  = organization;
    
    NSString *locationName = [info objectForKey:kLocationNameKey]; // Required!
    Location *location = [self locationWithName:locationName];
    record.recordLocation = location;
}

- (Record *)recordWithUniqueID:(NSString *)uniqueID {
    
    Record *record = nil;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kRecordKey];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"recordUniqueID = %@", uniqueID];
    
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    NSAssert(results.count == 1, @"Error fetching request");
    
    if (results.count == 1) record = results.firstObject;
    
    return record;
}

- (NSArray *)fetchRecordsWithDate:(NSDate *)aDate {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kRecordKey];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"recordSectionID = %@", [self dateNumberFromDate:aDate]];
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (NSInteger)numberOfRecordsInTotal {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kRecordKey];
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return results.count;
}

- (void)autoTerminateUnfinishedRecord {
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kUnfinishedEventCount"] == 1) {
        
        NSString *uniqueID = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUnfinishedEventUniqueID"];
        Record *record = [self recordWithUniqueID:uniqueID];
        
        if (![[NSCalendar currentCalendar] isDateInToday:record.recordDate]) {
            
            NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:record.recordDate];
            record.recordDueDate = [NSDate dateWithTimeInterval:(24 * 60 * 60 - 1) sinceDate:startOfDay];
            
            [self saveContext];
            
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"kUnfinishedEventCount"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"kUnfinishedEventUniqueID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

@end