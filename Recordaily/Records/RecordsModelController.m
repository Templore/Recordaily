
#import "RecordsModelController.h"
#import "AppDelegate.h"

@interface RecordsModelController ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, assign) NSInteger index;

@end

@implementation RecordsModelController

- (instancetype)initWithSegmentIndex:(NSInteger)index {
    
    self = [super init];
    
    if (self) {
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        self.context = appDelegate.coreDataController.managedObjectContext;
        
        self.index = index;
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
    
    NSSortDescriptor *sectionIDSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kRecordSectionIDKey ascending:NO];
    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kRecordDateKey ascending:YES];
    NSSortDescriptor *organizationSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"recordOrganization.organizationName" ascending:YES];
    NSSortDescriptor *locationSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"recordLocation.locationName" ascending:YES];
    
    NSArray  *sortDescriptors = nil;
    NSString *sectionNameKeyPath = nil;
    
    if (self.index == 0) {
        
        sortDescriptors = @[sectionIDSortDescriptor, dateSortDescriptor];
        sectionNameKeyPath = kRecordSectionIDKey;
        
    } else if (self.index == 1) {
        
        sortDescriptors = @[organizationSortDescriptor, sectionIDSortDescriptor, dateSortDescriptor];
        sectionNameKeyPath = @"recordOrganization.organizationName";
        
    } else if (self.index == 2) {
        
        sortDescriptors = @[locationSortDescriptor, sectionIDSortDescriptor, dateSortDescriptor];
        sectionNameKeyPath = @"recordLocation.locationName";
    }
    
    fetchRequest.sortDescriptors = sortDescriptors;
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context
                                                                      sectionNameKeyPath:sectionNameKeyPath cacheName:nil];
    
    return _fetchedResultsController;
}

@end