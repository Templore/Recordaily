
#import "OnePixelViewLayoutConstraint.h"

@implementation OnePixelViewLayoutConstraint

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (self.constant == 1)
    {
        self.constant = 1.0f / [UIScreen mainScreen].scale;
    }
}

@end