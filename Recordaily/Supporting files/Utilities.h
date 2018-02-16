
#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)aDate;

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format;

+ (NSDate *)dateFromYear:(NSInteger)yyyy month:(NSInteger)MM day:(NSInteger)dd
                    hour:(NSInteger)hh minute:(NSInteger)mm second:(NSInteger)ss;

+ (NSString *)removeWhitespaceAroundString:(NSString *)aString;

+ (BOOL)isBlankString:(NSString *)aString;

+ (NSString *)alwaysEnglishStringFromDate:(NSDate *)aDate;

@end