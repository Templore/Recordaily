
#import "Utilities.h"

@implementation Utilities

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)aDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |
    NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:aDate];
    
    return dateComponents;
}

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = format;
    
    return dateFormatter;
}

+ (NSDate *)dateFromYear:(NSInteger)yyyy month:(NSInteger)MM day:(NSInteger)dd
                    hour:(NSInteger)hh minute:(NSInteger)mm second:(NSInteger)ss {
    
    NSDateFormatter *dateFormatter = [Utilities dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // Pay attention!
    // dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSString *dateString = [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d:%02d", yyyy, MM, dd, hh, mm, ss];
    
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)removeWhitespaceAroundString:(NSString *)aString {
    
    NSCharacterSet *whitespaceAndNewlineCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [aString stringByTrimmingCharactersInSet:whitespaceAndNewlineCharacterSet];
}

+ (BOOL)isBlankString:(NSString *)aString {
    
    if (aString == nil) return YES;
    
    if ([Utilities removeWhitespaceAroundString:aString].length == 0) return YES;
    
    return false;
}

+ (NSString *)alwaysEnglishStringFromDate:(NSDate *)aDate {
    
    NSString *dateString = nil;
    NSString *yearString = nil;
    NSString *monthString = nil;
    NSString *dayString = nil;
    NSString *weekdayString = nil;
    
    NSCalendar *gregorianCalender = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitWeekday;
    NSDateComponents *dateComponents = [gregorianCalender components:unitFlags fromDate:aDate];
    
    yearString = [NSString stringWithFormat:@"%ld", (long)dateComponents.year];
    dayString  = [NSString stringWithFormat:@"%02ld", (long)dateComponents.day];
    
    switch (dateComponents.month)
    {
        case 1:  monthString = @"January";   break;
        case 2:  monthString = @"February";  break;
        case 3:  monthString = @"March";     break;
        case 4:  monthString = @"April";     break;
        case 5:  monthString = @"May";       break;
        case 6:  monthString = @"June";      break;
        case 7:  monthString = @"July";      break;
        case 8:  monthString = @"August";    break;
        case 9:  monthString = @"September"; break;
        case 10: monthString = @"October";   break;
        case 11: monthString = @"November";  break;
        case 12: monthString = @"December";  break;
    }
    
    switch (dateComponents.weekday)
    {
        case 1: weekdayString = @"Sunday";      break;
        case 2: weekdayString = @"Monday";      break;
        case 3: weekdayString = @"Tuesday";     break;
        case 4: weekdayString = @"Wednesday";   break;
        case 5: weekdayString = @"Thursday";    break;
        case 6: weekdayString = @"Friday";      break;
        case 7: weekdayString = @"Saturday";    break;
    }
    
    dateString = [NSString stringWithFormat:@"%@, %@ %@, %@", weekdayString, monthString, dayString, yearString];
    
    return dateString;
}

@end