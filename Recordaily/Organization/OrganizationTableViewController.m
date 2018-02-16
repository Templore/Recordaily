
#import "OrganizationTableViewController.h"
#import "GlobalBarButtonItem.h"
#import "GlobalTextField.h"
#import "AppDelegate.h"
#import "Utilities.h"

@interface OrganizationTableViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet GlobalBarButtonItem *saveBarButtonItem;
@property (weak, nonatomic) IBOutlet GlobalBarButtonItem *deleteBarButtonItem;
@property (weak, nonatomic) IBOutlet GlobalTextField *nameTextField;
@property (nonatomic, weak, readonly) AppDelegate *appDelegate;

@end

@implementation OrganizationTableViewController
@synthesize appDelegate = _appDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeData];
    [self constructView];
    [self updateSaveBarButtonItemStatus];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.nameTextField resignFirstResponder];
}


#pragma mark ~ PRIVATE METHOD ~

- (void)initializeData {
    
    self.unsavedOrganizationName = (self.organization != nil) ? (self.organization.organizationName) : (nil);
}

- (void)constructView {
    
    if (self.organization != nil) {
        
        self.title = @"Edit";
        self.nameTextField.text = self.organization.organizationName;
        
    } else {
        
        self.title = @"New";
        self.deleteBarButtonItem.enabled = NO;
    }
}

- (void)updateSaveBarButtonItemStatus {
    
    if (self.unsavedOrganizationName != nil) {
        
        [self.saveBarButtonItem setEnabled:YES];
        
    } else {
        
        [self.saveBarButtonItem setEnabled:NO];
    }
}

#pragma mark ~ ACTION ~

- (IBAction)configureDeleteBarButtonItemAction:(GlobalBarButtonItem *)sender {
    
    NSString *alertTitle = @"Pay attention!";
    NSString *alertMessage = @"This operation cannot be undone. \nAnd all events associated with the category will also be deleted.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             [self.appDelegate.coreDataController removeOrganization:self.organization];
                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                             
                                                         }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)configureSaveBarButtonItemAction:(GlobalBarButtonItem *)sender {
    
    NSMutableDictionary *propertiesInfo = [NSMutableDictionary dictionary];
    
    if (self.unsavedOrganizationName != nil) {
        
        [propertiesInfo setObject:self.unsavedOrganizationName forKey:kOrganizationNameKey];
        Organization *organization = [self.appDelegate.coreDataController organizationWithName:self.unsavedOrganizationName];
        [self.appDelegate.coreDataController configureOrganization:organization withPropertiesInfo:propertiesInfo];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark ~ UITextFieldDelegate ~

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self setUnsavedOrganizationName:nil];
    [self updateSaveBarButtonItemStatus];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (![Utilities isBlankString:textField.text]) {
        
        [self setUnsavedOrganizationName:[Utilities removeWhitespaceAroundString:textField.text]];
        
    } else {
        
        [self setUnsavedOrganizationName:nil];
        [textField setText:nil];
    }
    
    [self updateSaveBarButtonItemStatus];
}


#pragma mark ~ GETTER ~

- (AppDelegate *)appDelegate {
    
    if (_appDelegate) return _appDelegate;
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    return _appDelegate;
}

@end