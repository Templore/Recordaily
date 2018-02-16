
#import "GlobalTextField.h"

@implementation GlobalTextField

- (void)awakeFromNib {
    
    self.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightLight];
    self.textColor = [UIColor colorWithRed:.4f green:.4f blue:.4f alpha:1];
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.minimumFontSize = 16.0f;
    self.adjustsFontSizeToFitWidth = NO;
    self.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.returnKeyType = UIReturnKeyDone;
}

@end