
#import <Foundation/Foundation.h>

@class NSFetchedResultsController;

@interface LocationModelController : NSObject

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)performFetchRequest;

@end