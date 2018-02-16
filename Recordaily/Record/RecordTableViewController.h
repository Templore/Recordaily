
#import <UIKit/UIKit.h>

@class Record, Organization, Location;

@interface RecordTableViewController : UITableViewController

@property (nonatomic, strong) Record        *record;
@property (nonatomic, strong) NSString      *unsavedRecordSubject;
@property (nonatomic, strong) Organization  *unsavedRecordOrganization;
@property (nonatomic, strong) Location      *unsavedRecordLocation;

@end