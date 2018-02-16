
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setCoreDataController:[[CoreDataController alloc] init]];
    
    [self initializeUserDefaults];
    
    // [self.coreDataController autoTerminateUnfinishedRecord];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // [self.coreDataController autoTerminateUnfinishedRecord];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // [self.coreDataController autoTerminateUnfinishedRecord];
}

- (void)initializeUserDefaults {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSUInteger appRunCount = [userDefaults integerForKey:@"appRunCount"];
    
    [userDefaults setInteger:++appRunCount forKey:@"appRunCount"];
    
    if (appRunCount == 1)
    {
        [self.coreDataController seedInitialColorData];
        [self.coreDataController seedInitialOrganizationData];
        [self.coreDataController seedInitialLocationData];
    }
    
    [userDefaults synchronize];
}

@end