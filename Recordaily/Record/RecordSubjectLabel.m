
#import "RecordSubjectLabel.h"
#import "Constants.h"

@implementation RecordSubjectLabel

- (void)awakeFromNib {
    
    self.font = kRecordCellSubjectLabelTextFont;
    self.textColor = kRecordCellSubjectLabelTextColor;
    self.textAlignment = NSTextAlignmentLeft;
    self.numberOfLines = 0;
}

@end