
#import "RecordTableViewCell.h"
#import "RecordDateLabel.h"
#import "RecordOrganizationLabel.h"
#import "RecordSubjectLabel.h"
#import "RecordLocationLabel.h"
#import "Record.h"
#import "Location.h"
#import "Organization.h"
//#import "Color.h"
#import "Utilities.h"
#import "Constants.h"
#import "UIImage+RTTint.h"
#import "AppDelegate.h"

@implementation RecordTableViewCell

- (void)awakeFromNib {
    
    [self setBackgroundColor:kGlobalBackgroundColor];
    //[self.statusView setBackgroundColor:kRecordCellStatusViewBackgroundColor];
}

- (void)configureCellWithRecord:(Record *)aRecord option:(NSInteger)option {
    
    NSDateFormatter *dateFormatter = [Utilities dateFormatterWithFormat:@"yyyy-MM-dd"];
    NSDateFormatter *timeFormatter = [Utilities dateFormatterWithFormat:@"HH:mm:ss"];
    
    if (aRecord.recordDueDate == nil) {
        
        // self.statusImageView.image = [UIImage imageNamed:@"Clock.png"];
        // [self.statusImageView.image rt_tintedImageWithColor:kRecordCellStatusImageViewImageColor];
        // UIImage+RTTint: The above code does not work, use the below code instead
        UIImage *image  = [UIImage imageNamed:@"Clock.png"];
        UIImage *tinted = [image rt_tintedImageWithColor:kRecordCellStatusImageViewImageColor];
        self.statusImageView.image = tinted;
        
        self.dateLabel.text = [timeFormatter stringFromDate:aRecord.recordDate];
        
    } else {
        
        // self.statusImageView.image = [UIImage imageNamed:@"Check.png"];
        // [self.statusImageView.image rt_tintedImageWithColor:kRecordCellStatusImageViewImageColor];
        // UIImage+RTTint: The above code does not work, use the below code instead
        UIImage *image  = [UIImage imageNamed:@"Check.png"];
        UIImage *tinted = [image rt_tintedImageWithColor:kRecordCellStatusImageViewImageColor];
        self.statusImageView.image = tinted;
        
        NSString *startTime = [timeFormatter stringFromDate:aRecord.recordDate];
        NSString *endTime   = [timeFormatter stringFromDate:aRecord.recordDueDate];
        self.dateLabel.text = [NSString stringWithFormat:@"%@ ~ %@", startTime, endTime];
    }
    
    
    if (option == 0) {
        
        self.organizationLabel.text = aRecord.recordOrganization.organizationName;
        self.locationLabel.text = aRecord.recordLocation.locationName;
        
    } else if (option == 1) {
        
        self.organizationLabel.text = [dateFormatter stringFromDate:aRecord.recordDate];
        self.locationLabel.text = aRecord.recordLocation.locationName;
        
    } else {
        
        self.organizationLabel.text = aRecord.recordOrganization.organizationName;
        self.locationLabel.text = [dateFormatter stringFromDate:aRecord.recordDate];
    }
    
    self.subjectLabel.text  = aRecord.recordSubject;
    
    // CGFloat red   = aRecord.recordOrganization.organizationColor.colorRed.floatValue;
    // CGFloat green = aRecord.recordOrganization.organizationColor.colorGreen.floatValue;
    // CGFloat blue  = aRecord.recordOrganization.organizationColor.colorBlue.floatValue;
    // CGFloat alpha = aRecord.recordOrganization.organizationColor.colorAlpha.floatValue;
    
    // Organization view has been removed, replaced by organization label
    // self.organizationView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end