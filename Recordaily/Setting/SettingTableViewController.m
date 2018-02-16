
#import "SettingTableViewController.h"
#import "OrganizationsTableViewController.h"
#import "LocationsTableViewController.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark ~ UITableViewDelegate ~

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        [self performSegueWithIdentifier:@"SBSIDShowOrganizations" sender:indexPath];
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        
        [self performSegueWithIdentifier:@"SBSIDShowLocations" sender:indexPath];
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        
        [self performSegueWithIdentifier:@"SBSIDShowAbout" sender:indexPath];
    }
}


#pragma mark ~ NAVIGATION ~

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SBSIDShowOrganizations"]) {
        
        OrganizationsTableViewController *organizationsTableViewController = segue.destinationViewController;
        organizationsTableViewController.whoPerformSegue = @"SettingTableViewController";
        
    } else if ([segue.identifier isEqualToString:@"SBSIDShowLocations"]) {
        
        LocationsTableViewController *locationsTableViewController = segue.destinationViewController;
        locationsTableViewController.whoPerformSegue = @"SettingTableViewController";
        
    } else if ([segue.identifier isEqualToString:@"SBSIDShowAbout"]) {
        
        //
    }
}

@end