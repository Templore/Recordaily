
#import "GlobalTableViewCell.h"

@implementation GlobalTableViewCell

- (void)awakeFromNib {
    
    self.textLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
    
    self.textLabel.textColor = [UIColor colorWithRed:.4f green:.4f blue:.4f alpha:1];
    
    self.detailTextLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
    
    self.detailTextLabel.textColor = [UIColor colorWithRed:.4f green:.4f blue:.4f alpha:1];
    
    // self.tintColor =
}

@end