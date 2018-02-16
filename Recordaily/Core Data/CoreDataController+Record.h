
#import "CoreDataController.h"
#import "Record.h"

@interface CoreDataController (Record)

- (Record *)insertRecordWithPropertiesInfo:(NSDictionary *)info;
- (void)removeRecordWithUniqueID:(NSString *)uniqueID;
- (void)updateRecordWithUniqueID:(NSString *)uniqueID propertiesInfo:(NSDictionary *)info;

- (NSArray *)fetchRecordsWithDate:(NSDate *)aDate;
- (NSInteger)numberOfRecordsInTotal;
- (void)autoTerminateUnfinishedRecord;

@end