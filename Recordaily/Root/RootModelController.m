
#import "RootModelController.h"
#import "AppDelegate.h"

@interface RootModelController ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSDate *startOfToday, *endOfToday;

@end

@implementation RootModelController

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        self.context = appDelegate.coreDataController.managedObjectContext;
        self.startOfToday = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];
        self.endOfToday = [NSDate dateWithTimeInterval:24 * 60 * 60 sinceDate:self.startOfToday];
    }
    
    return self;
}

- (void)performFetchRequest {
    
    NSError *error = nil;
    
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Error performing fetch request");
    }
}


#pragma mark ~ GETTER ~

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController) return _fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kRecordKey];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kRecordDateKey ascending:NO]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"recordDate >= %@ AND recordDate < %@", self.startOfToday, self.endOfToday];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context
                                                                      sectionNameKeyPath:nil cacheName:nil];
    return _fetchedResultsController;
}

@end