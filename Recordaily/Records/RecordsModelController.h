
#import <Foundation/Foundation.h>

@class NSFetchedResultsController;

@interface RecordsModelController : NSObject

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (instancetype)initWithSegmentIndex:(NSInteger)index;

- (void)performFetchRequest;

@end