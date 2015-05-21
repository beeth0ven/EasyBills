//
//  PubicVariable.m
//  我的账本
//
//  Created by 罗 杰 on 9/11/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "PubicVariable.h"
#import "Kind+Create.h"
#import "NSDate+Extension.h"
#import "AppDelegate.h"


@implementation PubicVariable

+ (PubicVariable *)pubicVariable
{
    static dispatch_once_t pred = 0;
    __strong static PubicVariable *pubicVariable = nil;
    dispatch_once(&pred, ^{
        pubicVariable = [[self alloc] init];
    });
    return pubicVariable;
    
}

- (void)dealloc {
    NSLog(@"PubicVariable removeObserver");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


+(NSString *)stringFromDate:(NSDate *)date
{
//    NSString *dateString;
    if (!date) {
        return @"";
    }
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    unsigned int unitFlags =
    NSCalendarUnitDay |
    NSCalendarUnitMonth |
    NSCalendarUnitYear |
    NSCalendarUnitWeekOfYear |
    NSCalendarUnitWeekday |
    NSCalendarUnitWeekdayOrdinal ;
    
    
    NSDateComponents *dateComponents = [gregorianCalendar components:unitFlags fromDate:date];
    NSDateComponents *todayComponents = [gregorianCalendar components:unitFlags fromDate:[NSDate date]];

//    NSDateComponents *components = [gregorianCalendar
//                                    components:unitFlags
//                                    fromDate:date
//                                    toDate:[NSDate date]
//                                    options:0];
//    
////
//    NSLog(@" ");
//    NSLog(@"date: %@",  date);
//    NSLog(@"today: %@",  [NSDate date]);
//    NSLog(@"day: %i",  [components day]);
//    NSLog(@"weekday: %i",  [components weekday]);
//    NSLog(@"weekOfYear: %i",  [components weekOfYear]);
//    NSLog(@"month: %i",  [components month]);
    
    
//    NSInteger numberOfDays = [components day];
//    NSInteger numberOfWeeks = [components weekOfYear];
//    NSInteger numberOfMonths = [components month];
//    NSInteger numberOfYears = [components year];
    
    NSInteger yearOfDate = [dateComponents year];
    NSInteger weekOfYearOfDate = [dateComponents weekOfYear];
    NSInteger weekdayOfDate = [dateComponents weekday];
    
    NSInteger yearOfToday = [todayComponents year];
    NSInteger weekOfYearOfToday = [todayComponents weekOfYear];
//    NSInteger weekdayOfToday = [todayComponents weekday];
    
    if ([NSDate isSameDay:date andDate:[NSDate date]]) {
        return NSLocalizedString(@"Today", "") ;

    }else if([NSDate isSameDay:date andDate:[NSDate yesterday]]){
        return NSLocalizedString(@"Yesterday", "") ;

    }else if([NSDate isSameDay:date andDate:[NSDate dayBeforeYesterday]]){
        return NSLocalizedString(@"The day before yesterday", "") ;

    }
//    
//    if (numberOfYears == 0 &&
//        numberOfMonths == 0 &&
//        numberOfWeeks == 0) {
//        switch (numberOfDays) {
//                // Case day
//            case 0:{
//                return @"今天";
//                break;
//            }
//            case 1:{
//                return @"昨天";
//                break;
//            }
//            case 2:{
//                return @"前天";
//                break;
//            }
//            default:{
//                break;
//            }
//                
//        }
//        
//    }
    
    if (yearOfDate == yearOfToday &&
        weekOfYearOfDate == weekOfYearOfToday) {
        NSString *formatLocalizedString = NSLocalizedString(@"This %@", "This week/month/year");
        return [NSString stringWithFormat:formatLocalizedString, [self weekDayStrings] [weekdayOfDate]];
    }else if (yearOfDate == yearOfToday &&
              weekOfYearOfDate == weekOfYearOfToday - 1){
        NSString *formatLocalizedString = NSLocalizedString(@"Last %@", "Last week/month/year");
        return [NSString stringWithFormat:formatLocalizedString,[self weekDayStrings] [weekdayOfDate]];
    }
    
    NSDateFormatter *dateFormtter=[[NSDateFormatter alloc] init];
    [dateFormtter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormtter setTimeStyle:NSDateFormatterNoStyle];
//    if (yearOfDate == yearOfToday) {
//        [dateFormtter setDateFormat:@"M月d日"];
//    }else {
//        [dateFormtter setDateFormat:@"Y年M月d日"];
//
//    }
    return [dateFormtter stringFromDate:date];
}

+ (NSArray *)weekDayStrings {
    return @[@"?",
              NSLocalizedString(@"Sunday", ""),
              NSLocalizedString(@"Monday", ""),
              NSLocalizedString(@"Tuesday", ""),
              NSLocalizedString(@"Wednesday", ""),
              NSLocalizedString(@"Thursday", ""),
              NSLocalizedString(@"Friday", ""),
              NSLocalizedString(@"Saturday", ""),
             ];
}








#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - NSUser Defaults KVC

#define DATEMODE @"DateMode"
#define KINDISINCOME @"kindIsIncome"

+ (void)setDateMode:(NSInteger)dateMode
{
    NSNumber *number = [NSNumber numberWithInteger:dateMode];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:DATEMODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)dateMode
{
    NSNumber *number =[[NSUserDefaults standardUserDefaults] objectForKey:DATEMODE];
    return  number.intValue;
}

+(void)setKindIsIncome:(BOOL)isIncome
{
    NSNumber *number = [NSNumber numberWithBool:isIncome];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:KINDISINCOME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)kindIsIncome
{
    NSNumber *number =[[NSUserDefaults standardUserDefaults] objectForKey:KINDISINCOME];
    return  number.boolValue;
}



#define NEXTASSIGNINCOMECOLORINDEX @"nextAssignIncomeColorIndex"
#define NEXTASSIGNEXPENSECOLORINDEX @"nextAssignExpenseColorIndex"



+ (void)setNextAssignIncomeColorIndex:(NSInteger)nextAssignIncomeColorIndex
{
    NSNumber *number = [NSNumber numberWithInteger:nextAssignIncomeColorIndex];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:NEXTASSIGNINCOMECOLORINDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)nextAssignIncomeColorIndex
{
    NSNumber *number =[[NSUserDefaults standardUserDefaults] objectForKey:NEXTASSIGNINCOMECOLORINDEX];
    if (!number) {
        NSLog( @"%@", NSStringFromSelector(_cmd));
    }
    return  number.integerValue;
}

+ (void)setNextAssignExpenseColorIndex:(NSInteger)nextAssignExpenseColorIndex
{
    NSNumber *number = [NSNumber numberWithInteger:nextAssignExpenseColorIndex];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:NEXTASSIGNEXPENSECOLORINDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)nextAssignExpenseColorIndex
{
    NSNumber *number =[[NSUserDefaults standardUserDefaults] objectForKey:NEXTASSIGNEXPENSECOLORINDEX];
    if (!number) {
        NSLog( @"%@", NSStringFromSelector(_cmd));
    }
    return  number.integerValue;
}

+ (NSString *)kDeletBillActionSheetTitle {
    return NSLocalizedString(@"Are you sure you want to delete this bill?", "");
    
}
+ (NSString *)kDeletBillImageActionSheetTitle {
    return  NSLocalizedString(@"Are you sure you want to delete this photo?", "");
    
}

+ (NSString *)kCLAuthorizationStatusDeniedTitle {
    return   NSLocalizedString( @"You need to turn on Location Services", "");
    
}
+ (NSString *)kCLAuthorizationStatusDeniedMessage {
    return   NSLocalizedString( @"You can go to < Setting -> Privacy -> Location Services > to turn it on!", "");
    
}

+ (NSString *)kCLAuthorizationStatusRestrictedTitle {
    return   NSLocalizedString( @"You need to turn on Location Services", "");
    
}
+ (NSString *)kCLAuthorizationStatusRestrictedMessage {
    return   NSLocalizedString( @"You can go to < Setting -> Privacy -> Location Services > to turn it on!", "");
    
}

+ (NSString *)kPromptTitle {
    return   NSLocalizedString( @"Alert", "");
    
}
+ (NSString *)kMailNotConfiguredMessage {
    return   NSLocalizedString( @"E-mail has not been configured.", "");
    
}







@end
