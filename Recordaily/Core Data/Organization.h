
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Color, Record;

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kOrganizationKey;
extern NSString * const kOrganizationNameKey;
extern NSString * const kOrganizationDescriptionKey;

@interface Organization : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Organization+CoreDataProperties.h"