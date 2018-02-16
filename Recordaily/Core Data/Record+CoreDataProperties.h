//
//  Record+CoreDataProperties.h
//  Recordaily
//
//  Created by Anordiper on 2/20/16.
//  Copyright © 2016 Templore. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Record.h"

NS_ASSUME_NONNULL_BEGIN

@interface Record (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *recordDate;
@property (nullable, nonatomic, retain) NSDate *recordDueDate;
@property (nullable, nonatomic, retain) NSNumber *recordSectionID;
@property (nullable, nonatomic, retain) NSString *recordSubject;
@property (nullable, nonatomic, retain) NSString *recordUniqueID;
@property (nullable, nonatomic, retain) Organization *recordOrganization;
@property (nullable, nonatomic, retain) Location *recordLocation;

@end

NS_ASSUME_NONNULL_END
