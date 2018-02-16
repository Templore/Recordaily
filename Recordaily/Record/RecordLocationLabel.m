
#import "RecordLocationLabel.h"
#import "Constants.h"

@implementation RecordLocationLabel

- (void)awakeFromNib {
    
    self.font = kRecordCellLocationLabelTextFont;
    self.textColor = kRecordCellLocationLabelTextColor;
    self.textAlignment = NSTextAlignmentLeft;
    self.numberOfLines = 0;
}

@end