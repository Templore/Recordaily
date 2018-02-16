
#import <Foundation/Foundation.h>

@class NSFetchedResultsController;

@interface OrganizationModelController : NSObject

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)performFetchRequest;

@end