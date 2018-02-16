
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Record;

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kLocationKey;
extern NSString * const kLocationNameKey;

@interface Location : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Location+CoreDataProperties.h"