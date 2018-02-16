
#import "GlobalTableViewController.h"
#import "Constants.h"

@interface GlobalTableViewController ()

@end

@implementation GlobalTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:kGlobalBackgroundColor];
    [self.tableView setSeparatorColor:kRecordCellSeparatorColor];
}

@end