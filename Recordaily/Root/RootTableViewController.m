
#import "RootTableViewController.h"
#import "RootModelController.h"
#import "GlobalNavigationController.h"
#import "RecordTableViewController.h"
#import "RecordTableViewCell.h"
#import "AppDelegate.h"
#import "Utilities.h"
#import "Constants.h"

@interface RootTableViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak, readonly) AppDelegate *appDelegate;
@property (nonatomic, strong) RootModelController *rootModelController;
@property (nonatomic, strong) NSDictionary *refreshControlTitleAttributes;
@property (nonatomic, strong) UITapGestureRecognizer *navigationBarTapGestureRecognizer;
@property (nonatomic, strong) NSDate *today;

@end

@implementation RootTableViewController
@synthesize appDelegate = _appDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.rootModelController.fetchedResultsController setDelegate:self];
    [self constructView];
    [self setToday:[NSDate date]];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self reconstructView];
    // [self.appDelegate.coreDataController autoTerminateUnfinishedRecord];
    [self refetchDataIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar removeGestureRecognizer:self.navigationBarTapGestureRecognizer];
}


#pragma mark ~ ACTION ~

- (IBAction)configureRefreshControlValueChangedAction:(UIRefreshControl *)sender {
    
    NSInteger unfinishedEventCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"kUnfinishedEventCount"];
    
    if (sender.refreshing) {
        
        [sender endRefreshing];
        
        if (unfinishedEventCount == 0) {
            
            [self performSegueWithIdentifier:@"SBSIDPresentRecord" sender:nil];
        }
    }
}

- (void)configureOneFingerTapAction:(UITapGestureRecognizer *)recognizer {
    
    [self performSegueWithIdentifier:@"SBSIDShowRecords" sender:nil];
}


#pragma mark ~ PRIVATE METHOD ~

- (void)constructView {
    
    [self resetSeparatorInset:self.tableView];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:77];
    // [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]]; // Remove blank cells When the style of table view is plain
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 6.49f)]];
    [self.refreshControl setTintColor:[UIColor clearColor]]; // Make indicator of refresh control invisible
}

- (void)reconstructView {
    
    [self setTitle:[Utilities alwaysEnglishStringFromDate:[NSDate date]]];
    
    NSInteger unfinishedEventCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"kUnfinishedEventCount"];
    NSInteger numberOfObjects = [self.appDelegate.coreDataController fetchRecordsWithDate:[NSDate date]].count;
    
    if (numberOfObjects > 0) {
        
        self.tableView.backgroundView = nil;
        
        if (unfinishedEventCount == 0) {
            
            NSString *title = @"Swipe down to create a new event";
            self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:title
                                                                                  attributes:self.refreshControlTitleAttributes];
            
        } else if (unfinishedEventCount == 1) {
            
            NSString *title = @"Please finish the previous event first";
            self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:title
                                                                                  attributes:self.refreshControlTitleAttributes];
        }
        
    } else {
        
        UIViewController *backgroundViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RootBackgroundViewController"];
        self.tableView.backgroundView = backgroundViewController.view;
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"" attributes:nil];
    }
    
    
    /* Add tap gesture for navigation bar */
    // if ([self.navigationController.navigationBar.gestureRecognizers indexOfObject:self.navigationBarTapGestureRecognizer] == NSNotFound)
    // There is no need to 'if'.
    [self.navigationController.navigationBar addGestureRecognizer:self.navigationBarTapGestureRecognizer];
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
    
    Record *record = [self.rootModelController.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell configureCellWithRecord:record option:0];
}

- (void)refetchDataIfNeeded {
    
    /* If date has updated, should refetch data and reload table view */
    if (![[NSCalendar currentCalendar] isDateInToday:self.today]) {
        
        [self.rootModelController setFetchedResultsController:nil];
        [self setRootModelController:nil];
        [self.rootModelController.fetchedResultsController setDelegate:self];
        [self.rootModelController performFetchRequest];
        [self.tableView reloadData];
        
    } else {
        
        [self.rootModelController performFetchRequest];
    }
}


#pragma mark ~ NAVIGATION ~

- (IBAction)unwindToRootTableViewController:(UIStoryboardSegue *)segue {
    
    //
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        
        NSIndexPath *indexPath = sender;
        Record *record = [self.rootModelController.fetchedResultsController objectAtIndexPath:indexPath];
        
        GlobalNavigationController *recordNavigationController = segue.destinationViewController;
        RecordTableViewController *recordTableViewController = recordNavigationController.viewControllers.firstObject;
        recordTableViewController.record = record;
    }
}


#pragma mark ~ UITableViewDataSource, UITableViewDelegate ~

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.rootModelController.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = self.rootModelController.fetchedResultsController.sections[section];
    
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

- (RootModelController *)rootModelController {
    
    if (_rootModelController) return _rootModelController;
    
    _rootModelController = [[RootModelController alloc] init];
    
    return _rootModelController;
}

- (NSDictionary *)refreshControlTitleAttributes {
    
    if (_refreshControlTitleAttributes) return _refreshControlTitleAttributes;
    
    _refreshControlTitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kRefreshControlTitleFont, NSFontAttributeName,
                                      kRefreshControlTitleColor, NSForegroundColorAttributeName, nil];
    
    return _refreshControlTitleAttributes;
}

- (UITapGestureRecognizer *)navigationBarTapGestureRecognizer {
    
    if (_navigationBarTapGestureRecognizer) return _navigationBarTapGestureRecognizer;
    
    _navigationBarTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(configureOneFingerTapAction:)];
    
    return _navigationBarTapGestureRecognizer;
}

@end
