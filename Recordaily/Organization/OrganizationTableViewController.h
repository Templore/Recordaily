
#import <UIKit/UIKit.h>

@class Organization;

@interface OrganizationTableViewController : UITableViewController

@property (nonatomic, strong) Organization *organization;
@property (nonatomic, strong) NSString *unsavedOrganizationName;

@end