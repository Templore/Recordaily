
#import <UIKit/UIKit.h>

@class RecordTableViewController;

@interface OrganizationsTableViewController : UITableViewController

@property (nonatomic, weak) RecordTableViewController *recordTableViewController;

@property (nonatomic, strong) NSString *whoPerformSegue;

@end