
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Organization;

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kColorKey;
extern NSString * const kColorNameKey;
extern NSString * const kColorRedKey;
extern NSString * const kColorGreenKey;
extern NSString * const kColorBlueKey;
extern NSString * const kColorAlphaKey;

@interface Color : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Color+CoreDataProperties.h"