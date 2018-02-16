
#import <Foundation/Foundation.h>

@class NSFetchedResultsController;

@interface RootModelController : NSObject

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)performFetchRequest;

@end