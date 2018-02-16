
#import "LocationModelController.h"
#import "AppDelegate.h"

@interface LocationModelController ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation LocationModelController


- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        self.context = appDelegate.coreDataController.managedObjectContext;
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
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kLocationKey];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kLocationNameKey ascending:YES]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.context
                                                                      sectionNameKeyPath:nil cacheName:nil];
    return _fetchedResultsController;
}

@end