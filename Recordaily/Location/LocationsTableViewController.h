
#import <UIKit/UIKit.h>

@class RecordTableViewController;

@interface LocationsTableViewController : UITableViewController

@property (nonatomic, weak) RecordTableViewController *recordTableViewController;

@property (nonatomic, strong) NSString *whoPerformSegue;

@end