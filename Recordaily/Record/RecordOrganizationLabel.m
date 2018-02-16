
#import "RecordOrganizationLabel.h"
#import "Constants.h"

@implementation RecordOrganizationLabel

- (void)awakeFromNib {
    
    self.font = kRecordCellOrganizationLabelTextFont;
    self.textColor = kRecordCellOrganizationLabelTextColor;
    self.textAlignment = NSTextAlignmentRight;
}

@end