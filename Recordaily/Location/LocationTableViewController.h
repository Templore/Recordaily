
#import <UIKit/UIKit.h>

@class Location;

@interface LocationTableViewController : UITableViewController

@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) NSString *unsavedLocationName;

@end