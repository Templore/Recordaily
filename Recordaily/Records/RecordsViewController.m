
#import "RecordsViewController.h"
#import "GlobalNavigationController.h"
#import "GlobalSegmentedControl.h"
#import "RecordsModelController.h"
#import "RecordTableViewController.h"
#import "RecordTableViewCell.h"
#import "SectionHeaderLabel.h"
#import "AppDelegate.h"
#import "Utilities.h"
#import "Constants.h"

@interface RecordsViewController () <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet GlobalSegmentedControl *segmentedControl;
@property (weak, nonatomic, readonly) AppDelegate *appDelegate;
@property (nonatomic, strong) RecordsModelController *recordsModelController;

@end

@implementation RecordsViewController
@synthesize appDelegate = _appDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.recordsModelController.fetchedResultsController setDelegate:self];
    [self constructView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //[self.appDelegate.coreDataController autoTerminateUnfinishedRecord];
    [self.recordsModelController performFetchRequest];
}


#pragma mark ~ ACTION ~

- (IBAction)configureSegmentedControlValueChangedAction:(GlobalSegmentedControl *)sender {
    
    [self.recordsModelController setFetchedResultsController:nil];
    [self setRecordsModelController:nil];
    
    [self.recordsModelController.fetchedResultsController setDelegate:self];
    [self.recordsModelController performFetchRequest];
    
    [self.tableView reloadData];
    
    if ([self.appDelegate.coreDataController numberOfRecordsInTotal] > 0) {
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (IBAction)configureSettingBarButtonItemAction:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"SBSIDPresentSetting" sender:nil];
}


#pragma mark ~ PRIVATE METHOD ~

- (void)constructView {
    
    [self resetSeparatorInset:self.tableView];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:77];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:kRecordCellSeparatorColor];
}

- (void)resetSeparatorInset:(id)obj {
    
    if ([obj respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [obj setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([obj respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [obj setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)configureCell:(RecordTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Record *record = [self.recordsModelController.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell configureCellWithRecord:record option:self.segmentedControl.selectedSegmentIndex];
}


#pragma mark ~ NAVIGATION ~

- (IBAction)unwindToRecordsViewController:(UIStoryboardSegue *)segue {
    
    //
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        
        NSIndexPath *indexPath = sender;
        Record *record = [self.recordsModelController.fetchedResultsController objectAtIndexPath:indexPath];
        
        GlobalNavigationController *recordNavigationController = segue.destinationViewController;
        RecordTableViewController *recordTableViewController = recordNavigationController.viewControllers.firstObject;
        recordTableViewController.record = record;
    }
}


#pragma mark ~ UITableViewDelegate, UITableViewDataSource ~

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.recordsModelController.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = self.recordsModelController.fetchedResultsController.sections[section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecordTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RecordCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordTableViewCell" owner:nil options:nil] firstObject];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self resetSeparatorInset:cell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"SBSIDPresentRecord" sender:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = self.recordsModelController.fetchedResultsController.sections[section];
    NSDateFormatter *dateFormatter = [Utilities dateFormatterWithFormat:@"yyyyMMdd"];
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    UIView *viewForHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 20)];
    viewForHeader.backgroundColor = [UIColor clearColor];
    
    CGFloat headerLabelWidth  = viewForHeader.bounds.size.width - 16;
    CGFloat headerLabelHeight = viewForHeader.bounds.size.height;
    SectionHeaderLabel *headerLabel = [[SectionHeaderLabel alloc] initWithFrame:CGRectMake(8, 0, headerLabelWidth, headerLabelHeight)];
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        
        headerLabel.text = [Utilities alwaysEnglishStringFromDate:[dateFormatter dateFromString:[sectionInfo name]]];
        
    } else {
        
        headerLabel.text = [sectionInfo name];
    }
    
    [viewForHeader addSubview:headerLabel];
    
    return viewForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 44;
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


#pragma mark ~ GETTER ~

- (AppDelegate *)appDelegate {
    
    if (_appDelegate) return _appDelegate;
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    return _appDelegate;
}

- (RecordsModelController *)recordsModelController {
    
    if (_recordsModelController) return _recordsModelController;
    
    _recordsModelController = [[RecordsModelController alloc] initWithSegmentIndex:self.segmentedControl.selectedSegmentIndex];
    
    return _recordsModelController;
}

@end