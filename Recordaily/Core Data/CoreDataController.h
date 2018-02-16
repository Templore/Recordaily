
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface CoreDataController : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (instancetype)init;
- (void)saveContext;

- (NSString *)uniqueIDWithManagedObject:(NSManagedObject *)managedObject;
- (NSNumber *)dateNumberFromDate:(NSDate *)aDate; // e.g. 20160216

@end

#import "CoreDataController+Record.h"
#import "CoreDataController+Organization.h"
#import "CoreDataController+Location.h"
#import "CoreDataController+Color.h"