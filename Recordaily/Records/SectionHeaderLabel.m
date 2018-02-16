
#import "SectionHeaderLabel.h"
#import "Constants.h"

@implementation SectionHeaderLabel

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.font = kSectionHeaderLabelFont;
        self.textColor = kSectionHeaderLabelTextColor;
    }
    
    return self;
}

@end