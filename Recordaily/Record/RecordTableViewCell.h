
#import <UIKit/UIKit.h>

@class RecordDateLabel, RecordOrganizationLabel, RecordSubjectLabel, RecordLocationLabel, Record;

@interface RecordTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIView *baseView;

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet RecordDateLabel *dateLabel;
@property (weak, nonatomic) IBOutlet RecordSubjectLabel *subjectLabel;
@property (weak, nonatomic) IBOutlet RecordLocationLabel *locationLabel;
@property (weak, nonatomic) IBOutlet RecordOrganizationLabel *organizationLabel;

- (void)configureCellWithRecord:(Record *)aRecord option:(NSInteger)option;

@end