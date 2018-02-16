
#import "LocationsTableViewController.h"
#import "LocationModelController.h"
#import "LocationTableViewController.h"
#import "RecordTableViewController.h"
#import "GlobalNavigationController.h"
#import "GlobalTableViewCell.h"
#import "GlobalBarButtonItem.h"
#import "AppDelegate.h"

@interface LocationsTableViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak, readonly) AppDelegate *appDelegate;
@property (nonatomic, strong, readonly) LocationModelController *locationModelController;

@end

@implementation LocationsTableViewController
@synthesize appDelegate = _appDelegate;
@synthesize locationModelController = _locationModelController;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.locationModelController.fetchedResultsController setDelegate:self];
    
    if ([self.whoPerformSegue isEqualToString:@"SettingTableViewController"]) {
        
        [self setTitle:@"All Locations"];
        [self.tableView setEditing:YES];
        [self.tableView setAllowsSelectionDuringEditing:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.locationModelController performFetchRequest];
}


#pragma mark ~ ACTION ~

- (IBAction)configureCreateBarButtonItemAction:(GlobalBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"SBSIDPresentLocation" sender:nil];
}


#pragma mark ~ PRIVATE METHOD ~

- (void)configureCell:(GlobalTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.whoPerformSegue isEqualToString:@"SettingTableViewController"]) {
        
        if (indexPath.section == 0 && indexPath.row == [self.tableView numberOfRowsInSection:0] - 1) {
            
            cell.textLabel.enabled = NO;
            cell.textLabel.text = @"New location";
            
        } else {
            
            Location *location = [self.locationModelController.fetchedResultsController objectAtIndexPath:indexPath];
            
            cell.textLabel.text = location.locationName;
        }
        
    } else {
        
        Location *location = [self.locationModelController.fetchedResultsController objectAtIndexPath:indexPath];
        
        if (self.recordTableViewController.unsavedRecordLocation == location) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.textLabel.text = location.locationName;
    }
}


#pragma mark ~ UITableViewDataSource, UITableViewDelegate ~

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.locationModelController.fetchedResultsController.sections.count == 0 &&
        [self.whoPerformSegue isEqualToString:@"SettingTableViewController"]) {
        
        return 1;
        
    } else {
        
        return self.locationModelController.fetchedResultsController.sections.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.whoPerformSegue isEqualToString:@"SettingTableViewController"]) {
        
        if (self.locationModelController.fetchedResultsController.sections.count == 0) {
            
            return 1;
            
        } else {
            
            id <NSFetchedResultsSectionInfo> sectionInfo = self.locationModelController.fetchedResultsController.sections[section];
            
            return [sectionInfo numberOfObjects] + 1;
        }
        
    } else {
        
        id <NSFetchedResultsSectionInfo> sectionInfo = self.locationModelController.fetchedResultsController.sections[section];
        
        return [sectionInfo numberOfObjects];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GlobalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[GlobalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.whoPerformSegue isEqualToString:@"SettingTableViewController"]) {
        
        if (indexPath.section == 0 && indexPath.row == [self.tableView numberOfRowsInSection:0] - 1) {
            
            [self performSegueWithIdentifier:@"SBSIDPresentLocation" sender:nil];
            
        } else {
            
            [self performSegueWithIdentifier:@"SBSIDPresentLocation" sender:indexPath];
        }
        
    } else {
        
        Location *location = [self.locationModelController.fetchedResultsController objectAtIndexPath:indexPath];
        
        self.recordTableViewController.unsavedRecordLocation = location;
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.whoPerformSegue isEqualToString:@"SettingTableViewController"]) {
        
        return YES;
        
    } else {
        
        return NO;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.whoPerformSegue isEqualToString:@"SettingTableViewController"]) {
        
        if (indexPath.section == 0 && indexPath.row == [self.tableView numberOfRowsInSection:0] - 1) {
            
            return UITableViewCellEditingStyleInsert;
            
        } else {
            
            return UITableViewCellEditingStyleDelete;
        }
        
    } else {
        
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.whoPerformSegue isEqualToString:@"SettingTableViewController"]) {
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            Location *location = [self.locationModelController.fetchedResultsController objectAtIndexPath:indexPath];
            
            NSString *alertTitle = @"Pay attention!";
            NSString *alertMessage = @"This operation cannot be undone. \nAnd all events associated with the category will also be deleted.";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     
                                                                     [self.appDelegate.coreDataController removeLocation:location];
                                                                     
                                                                 }];
            [alertController addAction:cancelAction];
            [alertController addAction:deleteAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
            
            [self performSegueWithIdentifier:@"SBSIDPresentLocation" sender:nil];
        }
    }
}


#pragma mark ~ NSFetchedResultsControllerDelegate ~

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    /* The fetch controller is about to start sending change notifications, so prepare the table view for updates */
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    UITableViewRowAnimation rowAnimation = UITableViewRowAnimationAutomatic;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert: [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:rowAnimation]; break;
        case NSFetchedResultsChangeDelete: [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation]; break;
        case NSFetchedResultsChangeUpdate: [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath]; break;
        case NSFetchedResultsChangeMove:
        {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:rowAnimation];
        }
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    UITableView *tableView = self.tableView;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
    UITableViewRowAnimation rowAnimation = UITableViewRowAnimationAutomatic;
    
    switch (type)
    {
        case NSFetchedResultsChangeInsert: [tableView insertSections:indexSet withRowAnimation:rowAnimation]; break;
        case NSFetchedResultsChangeDelete: [tableView deleteSections:indexSet withRowAnimation:rowAnimation]; break;
        case NSFetchedResultsChangeUpdate:break;
        case NSFetchedResultsChangeMove:break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    /* The fetch controller has sent all current change notifications, so tell the table view to process all updates */
    [self.tableView endUpdates];
}


#pragma mark ~ NAVIGATION ~

- (IBAction)unwindToLocationsTableViewController:(UIStoryboardSegue *)segue {
    
    //
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        
        NSIndexPath *indexPath = sender;
        
        Location *location = [self.locationModelController.fetchedResultsController objectAtIndexPath:indexPath];
        
        GlobalNavigationController *locationNavigationController = segue.destinationViewController;
        LocationTableViewController *locationTableViewController = locationNavigationController.viewControllers.firstObject;
        locationTableViewController.location = location;
    }
}


#pragma mark ~ GETTER ~

- (AppDelegate *)appDelegate {
    
    if (_appDelegate) return _appDelegate;
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    return _appDelegate;
}

- (LocationModelController *)locationModelController {
    
    if (_locationModelController) return _locationModelController;
    
    _locationModelController = [[LocationModelController alloc] init];
    
    return _locationModelController;
}

@end