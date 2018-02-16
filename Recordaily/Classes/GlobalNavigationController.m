
#import "GlobalNavigationController.h"
#import "Constants.h"

@interface GlobalNavigationController ()

@property (nonatomic, strong) NSDictionary *navigationBarTitleTextAttributes;

@end

@implementation GlobalNavigationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self constructNavigationBar];
    [self constructToolbar];
}


#pragma mark ~ PRIVATE METHOD ~

- (void)constructNavigationBar {
    
    /* Set navigation bar color and negative translucent */
    [self.navigationBar setBarTintColor:kGlobalBackgroundColor];
    [self.navigationBar setTranslucent:NO];
    
    /* Make navigation bar and it's shadow line transparent */
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self.navigationBar setTitleTextAttributes:self.navigationBarTitleTextAttributes];
    [self.navigationBar setTintColor:kNavBarTintColor];
}

- (void)constructToolbar {
    
    /* Set tool bar color and negative translucent */
    [self.toolbar setBarTintColor:kToolbarBackgroundColor];
    [self.toolbar setTranslucent:NO];
    
    /* Make tool bar transparent */
    [self.toolbar setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    // [self.toolbar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIBarPositionAny];
}


#pragma mark ~ GETTER ~

- (NSDictionary *)navigationBarTitleTextAttributes {
    
    if (_navigationBarTitleTextAttributes) return _navigationBarTitleTextAttributes;
    
    _navigationBarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kNavBarTitleFont, NSFontAttributeName,
                                         kNavBarTintColor, NSForegroundColorAttributeName, nil];
    
    return _navigationBarTitleTextAttributes;
}

@end