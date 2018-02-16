
#import "RecordDateLabel.h"
#import "Constants.h"

@implementation RecordDateLabel

- (void)awakeFromNib {
    
    self.font = kRecordCellDateLabelTextFont;
    self.textColor = kRecordCellDateLabelTextColor;
    self.textAlignment = NSTextAlignmentLeft;
}

@end