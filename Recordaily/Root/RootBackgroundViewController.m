
#import "RootBackgroundViewController.h"
#import "Constants.h"

@interface RootBackgroundViewController ()

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UILabel *additionalPromptLabel;
@property (weak, nonatomic) IBOutlet UIView *referenceView;

@end

@implementation RootBackgroundViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.referenceView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:kGlobalBackgroundColor];
    
    [self.promptLabel setFont:kNavBarTitleFont];
    [self.promptLabel setTextAlignment:NSTextAlignmentCenter];
    [self.promptLabel setTextColor:kRefreshControlTitleColor];
    
    [self.additionalPromptLabel setFont:kNavBarTitleFont];
    [self.additionalPromptLabel setTextAlignment:NSTextAlignmentCenter];
    [self.additionalPromptLabel setTextColor:kRefreshControlTitleColor];
}

@end