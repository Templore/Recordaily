//
//  Color+CoreDataProperties.h
//  Recordaily
//
//  Created by Anordiper on 2/22/16.
//  Copyright © 2016 Templore. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Color.h"

NS_ASSUME_NONNULL_BEGIN

@interface Color (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *colorName;
@property (nullable, nonatomic, retain) NSNumber *colorRed;
@property (nullable, nonatomic, retain) NSNumber *colorGreen;
@property (nullable, nonatomic, retain) NSNumber *colorBlue;
@property (nullable, nonatomic, retain) NSNumber *colorAlpha;
@property (nullable, nonatomic, retain) NSSet<Organization *> *colorOrganizations;

@end

@interface Color (CoreDataGeneratedAccessors)

- (void)addColorOrganizationsObject:(Organization *)value;
- (void)removeColorOrganizationsObject:(Organization *)value;
- (void)addColorOrganizations:(NSSet<Organization *> *)values;
- (void)removeColorOrganizations:(NSSet<Organization *> *)values;

@end

NS_ASSUME_NONNULL_END
