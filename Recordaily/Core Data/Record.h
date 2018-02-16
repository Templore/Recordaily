
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location, Organization;

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kRecordKey;
extern NSString * const kRecordUniqueIDKey;
extern NSString * const kRecordSubjectKey;
extern NSString * const kRecordDateKey;
extern NSString * const kRecordDueDateKey;
extern NSString * const kRecordSectionIDKey;

@interface Record : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Record+CoreDataProperties.h"