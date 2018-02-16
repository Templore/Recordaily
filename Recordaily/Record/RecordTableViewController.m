
#import "RecordTableViewController.h"
#import "OrganizationsTableViewController.h"
#import "LocationsTableViewController.h"
#import "GlobalTableViewCell.h"
#import "GlobalTextField.h"
#import "AppDelegate.h"
#import "Utilities.h"

@interface RecordTableViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet GlobalTextField     *recordSubjectTextField;
@property (weak, nonatomic) IBOutlet GlobalTableViewCell *recordCategoryCell;
@property (weak, nonatomic) IBOutlet GlobalTableViewCell *recordLocationCell;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *finishBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButtonItem;

@property (weak, nonatomic, readonly) AppDelegate *appDelegate;

@end

@implementation RecordTableViewController
@synthesize appDelegate = _appDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeData];
    [self constructView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reconstructView];
    [self updateSaveBarButtonItemStatus];
    //[self.appDelegate.coreDataController autoTerminateUnfinishedRecord];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.recordSubjectTextField resignFirstResponder];
}


#pragma mark ~ ACTION ~

- (IBAction)configureCancelBarButtonItemAction:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)configureSaveBarButtonItemAction:(UIBarButtonItem *)sender {
    
    NSMutableDictionary *propertiesInfo = [NSMutableDictionary dictionary];
    
    if (self.unsavedRecordSubject != nil && self.unsavedRecordLocation != nil && self.unsavedRecordOrganization != nil) {
        
        [propertiesInfo setObject:self.unsavedRecordSubject forKey:kRecordSubjectKey];
        [propertiesInfo setObject:self.unsavedRecordOrganization.organizationName forKey:kOrganizationNameKey];
        [propertiesInfo setObject:self.unsavedRecordLocation.locationName forKey:kLocationNameKey];
        
        if (self.record == nil) {
            
            [propertiesInfo setObject:[NSDate date] forKey:kRecordDateKey];
            Record *record = [self.appDelegate.coreDataController insertRecordWithPropertiesInfo:propertiesInfo];
            
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"kUnfinishedEventCount"];
            [[NSUserDefaults standardUserDefaults] setObject:record.recordUniqueID forKey:@"kUnfinishedEventUniqueID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        } else {
            
            [propertiesInfo setObject:self.record.recordDate forKey:kRecordDateKey]; // Holding the start date is not changed
            
            if (self.record.recordDueDate != nil) {
                
                [propertiesInfo setObject:self.record.recordDueDate forKey:kRecordDueDateKey]; // Holding the due date is not changed
                
            }
            
            [self.appDelegate.coreDataController updateRecordWithUniqueID:self.record.recordUniqueID propertiesInfo:propertiesInfo];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)configureDeleteBarButtonItemAction:(UIBarButtonItem *)sender {
    
    NSString *title = @"Pay attention!";
    NSString *message = @"This operation cannot be undone.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
        
        if (self.record.recordDueDate == nil) {
            
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"kUnfinishedEventCount"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"kUnfinishedEventUniqueID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [self.appDelegate.coreDataController removeRecordWithUniqueID:self.record.recordUniqueID];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)configureFinishBarButtonItemAction:(UIBarButtonItem *)sender {
    
    NSString *title = @"Pay attention!";
    NSString *message = @"This operation cannot be undone.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *finishAction = [UIAlertAction actionWithTitle:@"Finish" style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableDictionary *propertiesInfo = [NSMutableDictionary dictionary];
        
        if (self.unsavedRecordSubject != nil && self.unsavedRecordLocation != nil && self.unsavedRecordOrganization != nil) {
            
            [propertiesInfo setObject:self.unsavedRecordSubject forKey:kRecordSubjectKey];
            [propertiesInfo setObject:self.unsavedRecordOrganization.organizationName forKey:kOrganizationNameKey];
            [propertiesInfo setObject:self.unsavedRecordLocation.locationName forKey:kLocationNameKey];
            
            if (self.record != nil) {
                
                [propertiesInfo setObject:self.record.recordDate forKey:kRecordDateKey]; // Holding the start date is not changed
                
                if ([[NSCalendar currentCalendar] isDateInToday:self.record.recordDate]) {
                    
                    [propertiesInfo setObject:[NSDate date] forKey:kRecordDueDateKey];
                    
                } else {
                    
                    NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:self.record.recordDate];
                    NSDate *endOfDay = [NSDate dateWithTimeInterval:(24 * 60 * 60 - 1) sinceDate:startOfDay];
                    [propertiesInfo setObject:endOfDay forKey:kRecordDueDateKey];
                }
                
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"kUnfinishedEventCount"];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"kUnfinishedEventUniqueID"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.appDelegate.coreDataController updateRecordWithUniqueID:self.record.recordUniqueID propertiesInfo:propertiesInfo];
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:finishAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark ~ PRIVATE METHOD ~

- (void)initializeData {
    
    self.unsavedRecordSubject = (self.record != nil) ? (self.record.recordSubject) : (nil);
    self.unsavedRecordOrganization = (self.record != nil) ? (self.record.recordOrganization) : (nil);
    self.unsavedRecordLocation = (self.record != nil) ? (self.record.recordLocation) : (nil);
}

- (void)constructView {
    
    if (self.record != nil) {
        
        self.title = @"Edit";
        
        if (self.record.recordDueDate != nil) {
            
            self.finishBarButtonItem.enabled = NO;
        }
        
    } else {
        
        self.title = @"New";
        
        self.deleteBarButtonItem.enabled = NO;
        self.finishBarButtonItem.enabled = NO;
    }
}

- (void)reconstructView {
    
    if (self.unsavedRecordSubject != nil)
        self.recordSubjectTextField.text = self.unsavedRecordSubject;
    
    if (self.unsavedRecordOrganization != nil)
        self.recordCategoryCell.detailTextLabel.text = self.unsavedRecordOrganization.organizationName;
    
    if (self.unsavedRecordLocation != nil)
        self.recordLocationCell.detailTextLabel.text = self.unsavedRecordLocation.locationName;
}

- (void)updateSaveBarButtonItemStatus {
    
    if (self.unsavedRecordSubject != nil &&
        self.unsavedRecordOrganization != nil &&
        self.unsavedRecordLocation != nil) {
        
        [self.saveBarButtonItem setEnabled:YES];
        
    } else {
        
        [self.saveBarButtonItem setEnabled:NO];
    }
}


#pragma mark ~ UITableViewDelegate ~

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.recordSubjectTextField resignFirstResponder];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        [self performSegueWithIdentifier:@"SBSIDShowOrganizations" sender:indexPath];
        
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        
        [self performSegueWithIdentifier:@"SBSIDShowLocations" sender:indexPath];
    }
}


#pragma mark ~ UITextFieldDelegate ~

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self setUnsavedRecordSubject:nil];
    [self updateSaveBarButtonItemStatus];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (![Utilities isBlankString:textField.text]) {
        
        [self setUnsavedRecordSubject:[Utilities removeWhitespaceAroundString:textField.text]];
        
    } else {
        
        [self setUnsavedRecordSubject:nil];
        [textField setText:nil];
    }
    
    [self updateSaveBarButtonItemStatus];
}


#pragma mark ~ NAVIGATION ~

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SBSIDShowOrganizations"]) {
        
        OrganizationsTableViewController *organizationsTableViewController = segue.destinationViewController;
        organizationsTableViewController.recordTableViewController = self;
        organizationsTableViewController.whoPerformSegue = @"RecordTableViewController";
        
    } else if ([segue.identifier isEqualToString:@"SBSIDShowLocations"]) {
        
        LocationsTableViewController *locationsTableViewController = segue.destinationViewController;
        locationsTableViewController.recordTableViewController = self;
        locationsTableViewController.whoPerformSegue = @"RecordTableViewController";
    }
}


#pragma mark ~ GETTER ~

- (AppDelegate *)appDelegate {
    
    if (_appDelegate) return _appDelegate;
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    return _appDelegate;
}

@end