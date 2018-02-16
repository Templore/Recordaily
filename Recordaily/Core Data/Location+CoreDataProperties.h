//
//  Location+CoreDataProperties.h
//  Recordaily
//
//  Created by Anordiper on 2/20/16.
//  Copyright © 2016 Templore. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *locationName;
@property (nullable, nonatomic, retain) NSSet<Record *> *locationRecords;

@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addLocationRecordsObject:(Record *)value;
- (void)removeLocationRecordsObject:(Record *)value;
- (void)addLocationRecords:(NSSet<Record *> *)values;
- (void)removeLocationRecords:(NSSet<Record *> *)values;

@end

NS_ASSUME_NONNULL_END
