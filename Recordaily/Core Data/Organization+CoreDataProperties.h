//
//  Organization+CoreDataProperties.h
//  Recordaily
//
//  Created by Anordiper on 2/22/16.
//  Copyright © 2016 Templore. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Organization.h"

NS_ASSUME_NONNULL_BEGIN

@interface Organization (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *organizationDescription;
@property (nullable, nonatomic, retain) NSString *organizationName;
@property (nullable, nonatomic, retain) NSSet<Record *> *organizationRecords;
@property (nullable, nonatomic, retain) Color *organizationColor;

@end

@interface Organization (CoreDataGeneratedAccessors)

- (void)addOrganizationRecordsObject:(Record *)value;
- (void)removeOrganizationRecordsObject:(Record *)value;
- (void)addOrganizationRecords:(NSSet<Record *> *)values;
- (void)removeOrganizationRecords:(NSSet<Record *> *)values;

@end

NS_ASSUME_NONNULL_END
