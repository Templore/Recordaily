
#import "CoreDataController.h"

@implementation CoreDataController

- (instancetype)init {
    
    self = [super init];
    
    if (self)
    {
        [self initializeCoreDataStack];
    }
    
    return self;
}

#pragma mark ~ CORE DATA STACK ~

- (void)initializeCoreDataStack {
    
    /* URLs */
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *documentURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSURL *storeURL = [documentURL URLByAppendingPathComponent:@"Recordaily.sqlite"];
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Recordaily" withExtension:@"momd"];
    
    
    /* Managed Object Model */
    
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSAssert(mom != nil, @"Error initializing Managed Object Model");
    
    
    /* Persistent Store Coordinator */
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    
    /* Managed Object Context */
    
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    self.managedObjectContext = moc;
    
    self.managedObjectContext.persistentStoreCoordinator = psc;
    
    
    /* Persistent Store */
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSError *error = nil;
        
        NSPersistentStoreCoordinator *psc = self.managedObjectContext.persistentStoreCoordinator;
        
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        
        NSAssert(store != nil, @"Error initializing Persistent Store Coordinator");
        
    });
}

#pragma mark ~ CORE DATA SAVING SUPPORT ~

- (void)saveContext {
    
    NSError *error = nil;
    
    if ([self.managedObjectContext hasChanges] && [self.managedObjectContext save:&error] == NO) {
        
        NSLog(@"Error saving context");
    }
}

#pragma mark ~ METHOD ~

- (NSString *)uniqueIDWithManagedObject:(NSManagedObject *)managedObject {
    
    NSString *uniqueIDString = nil;
    
    uniqueIDString = [[[managedObject objectID] URIRepresentation] absoluteString];
    
    return uniqueIDString;
}

- (NSNumber *)dateNumberFromDate:(NSDate *)aDate {
    
    NSUInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:unitFlags fromDate:aDate];
    
    return [NSNumber numberWithInteger:(dateComponents.year * 10000 + dateComponents.month * 100 + dateComponents.day)];
}

@end