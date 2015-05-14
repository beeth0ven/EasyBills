//
//  ChartDate.m
//  我的账本
//
//  Created by 罗 杰 on 9/21/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "ChartDate.h"
#import "PubicVariable+FetchRequest.h"
#import "NSDate+Extension.h"
#import "DefaultStyleController.h"
#import "UIFont+Extension.h"

@interface ChartDate ()

@property (strong, nonatomic) NSArray *xLabels;
@property (strong, nonatomic) NSArray *incomeDataArray;
@property (strong, nonatomic) NSArray *expenseDataArray;
@property (nonatomic) BOOL shouldRefreshData;


@end


@implementation ChartDate

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [self init];
    if (self) {
        _managedObjectContext = context;
    }
    return self;
}


-(NSArray *)xLabels
{
    NSInteger dateMode = [PubicVariable dateMode];
    switch (dateMode) {
        case week:
            _xLabels = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
            break;
        case month:
        {
//            NSInteger weekCountOfMonth = [self weekCountOfMonthf];
//            NSArray *array = @[@"第一周",@"第二周",@"第三周",@"第四周",@"第五周",@"第六周"];
//            NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
//            for (NSInteger i = 0; i < weekCountOfMonth; i++) {
//                [mutableArray addObject:array[i]];
//            }
//            _xLabels = [mutableArray copy];
        }
            break;
        default:
        {
            NSArray *array = @[@"十二月",@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月"];
            NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
            NSInteger month = [self thisMonth];
            for (NSInteger i = month - 5; i <= month; i++) {
                NSInteger index = i < 0 ? i + 12 : i ;
                //           i refer to  -4 -3 -2 -1 | 0 1 2 3 4 5 6 7 8 9 10 11 | 12
                //       index refer to   8  9 10 11 | 0 1 2 3 4 5 6 7 8 9 10 11 | 12
                //  index % 12 refer to   8  9 10 11 | 0 1 2 3 4 5 6 7 8 9 10 11 | 0
                [mutableArray addObject:array[index % 12]];
            }
            _xLabels = [mutableArray copy];
        }
            break;
    }
    return _xLabels;
}

- (void)refreshData {
    self.shouldRefreshData = YES;
    [self incomeDataArray];
    [self expenseDataArray];
    self.shouldRefreshData = NO;
}

//- (void)goPrevious {
//}
//
//- (void)goNext {
//
//}

-(NSArray *)incomeDataArray
{
    if (!_incomeDataArray || self.shouldRefreshData) {
        NSInteger dateMode = [PubicVariable dateMode];
        switch (dateMode) {
            case week:
                _incomeDataArray = [self weekModeDataArryIsincomeMode:isIncomeYes];
                break;
            case month:
                
                _incomeDataArray = [self monthModeDataArryIsincomeMode:isIncomeYes];
                break;
            default:
                _incomeDataArray = [self allModeDataArryIsincomeMode:isIncomeYes];
                break;
        }
        
    }
    return _incomeDataArray;
}


-(NSArray *)expenseDataArray
{
    if (!_expenseDataArray || self.shouldRefreshData) {
        NSInteger dateMode = [PubicVariable dateMode];
        switch (dateMode) {
            case week:
                _expenseDataArray = [self weekModeDataArryIsincomeMode:isIncomeNo];
                break;
            case month:
                _expenseDataArray = [self monthModeDataArryIsincomeMode:isIncomeNo];
                break;
            default:
                _expenseDataArray = [self allModeDataArryIsincomeMode:isIncomeNo];
                break;
        }
        
    }
    return _expenseDataArray;
}

- (void)setTitle:(NSString *)title
       highlight:(BOOL)highlight {
    
    UIColor *color = highlight ? EBBlue : EBBackGround;
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : color,
                                 NSFontAttributeName : [UIFont systemFontOfSize:20]
                                 };
    
    self.attributedTitle =  [[NSAttributedString alloc]
                             initWithString: title
                             attributes:attributes];
    
}

- (void)setSubTitle:(NSString *)subTitle {
    
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : EBBackGround,
                                 NSFontAttributeName : [UIFont systemFontOfSize:10]
                                 };
    
    self.attributedSubTitle =  [[NSAttributedString alloc]
                                initWithString: subTitle
                                attributes:attributes];
    
}


-(NSArray *)weekModeDataArryIsincomeMode:(NSInteger)isIncomeMode
{
    NSDate *referenceDate = self.referenceDate;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSMutableArray *mutableArray =[[NSMutableArray alloc]init];
    NSDateComponents *components = [gregorian components: NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear
                                                fromDate:referenceDate];
    
    NSInteger weekOfYear = [components weekOfYear];
    
    NSString *title = [NSString stringWithFormat:@"%li周",(long)weekOfYear];
    BOOL highlight = (self.pageIndex == 0);
    [self setTitle:title highlight:highlight];
    
    NSDate *fromDate;
    NSDate *toDate;
    NSInteger weekday = [components weekday];
    for (NSInteger day = -weekday+1; day <= -weekday + 7; day++) {
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:day];
        NSDate *date = [gregorian dateByAddingComponents:comps toDate:referenceDate  options:0];
        if (day == -weekday+1) {
            fromDate = [date copy];
        } else if (day == -weekday + 7){
            toDate = [date copy];
        }
        float  money = [PubicVariable sumMoneyWithIncomeMode:isIncomeMode
                                                   withStyle:predicateDayStyle
                                                    withDate:date
                                      inManagedObjectContext:self.managedObjectContext];
        [mutableArray addObject:[NSNumber numberWithFloat:fabs(money)]];
        
    }
       [self setSubTitle:[self stringFromDate:fromDate toDate:toDate]];

    return [mutableArray copy];
    
}


-(NSArray *)monthModeDataArryIsincomeMode:(NSInteger)isIncomeMode
{
    NSDate *referenceDate = self.referenceDate;

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekOfMonth | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitWeekday
                                                fromDate:referenceDate];
    
    NSInteger month = [components month];
    NSInteger weekday = [components weekday];
//    NSLog(@"weekday:%i",weekday);

//    NSLog(@"year:%i month:%i day:%i",
//          [components year],
//          [components month],
//          [components day]
//          );
    NSDate *fromDate = [self.referenceDate firstDayOfMonth];
    NSDate *toDate = [self.referenceDate lastDayOfMonth];
    [self setSubTitle:[self stringFromDate:fromDate toDate:toDate]];

    NSString *title = [NSString stringWithFormat:@"%li月",(long)month];
    BOOL highlight = (self.pageIndex == 0);
    [self setTitle:title highlight:highlight];
    
    NSInteger weekCountOfMonth = [self weekCountOfMonthForDate:referenceDate];
    NSInteger weekOfMonth = [components weekOfMonth];
    
    NSMutableArray *mutableArray =[[NSMutableArray alloc]init];
    for (NSInteger week = -weekOfMonth+1; week <= -weekOfMonth + weekCountOfMonth; week++) {
        NSInteger offsetDay = 0;
        
        if (week == -weekOfMonth+1) {
            //Bug fix 3-31 to 4-3,first week get final week day
           offsetDay = 7 - weekday;
        } else if (week == -weekOfMonth + weekCountOfMonth){
            //Bug fix 4-2 to 3-30, last week get first week day
            offsetDay = - weekday + 1;
        }
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:(week*7 + offsetDay)];
        NSDate *date = [gregorian dateByAddingComponents:comps toDate:referenceDate  options:0];
        [date showDetail];
        
        float  money = [PubicVariable sumMoneyWithIncomeMode:isIncomeMode
                                                   withStyle:predicateWeekInMonthStyle
                                                    withDate:date
                                      inManagedObjectContext:self.managedObjectContext];
        
//         NSLog(@"dateWeekID = %@",[NSDate weekIDWithDate:date]);
//         NSLog(@"isIncomeMode = %li",(long)isIncomeMode);
//         NSLog(@"money = %.2f",money);
        
        [mutableArray addObject:[NSNumber numberWithFloat:fabs(money)]];
        
    }
    return [mutableArray copy];
    
}

-(NSArray *)allModeDataArryIsincomeMode:(NSInteger)isIncomeMode
{
    
    NSDate *referenceDate = self.referenceDate;

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSMutableArray *mutableArray =[[NSMutableArray alloc]init];
    NSDateComponents *components = [gregorian components: NSCalendarUnitMonth | NSCalendarUnitYear
                                                fromDate:referenceDate];
    
    NSInteger year = [components year];
    
    NSString *title = [NSString stringWithFormat:@"%li年",(long)year];
    BOOL highlight = (self.pageIndex == 0);
    [self setTitle:title highlight:highlight];
    
    NSDate *fromDate = [self.referenceDate firstDayOfYear];
    NSDate *toDate = [self.referenceDate lastDayOfYear];
    [self setSubTitle:[self stringFromDate:fromDate toDate:toDate]];
    
    NSInteger thisMonth = [components month];
    for (NSInteger month = -thisMonth+1; month <= -thisMonth+12 ; month++) {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setMonth:month];
        NSDate *date = [gregorian dateByAddingComponents:comps toDate:referenceDate  options:0];
        float  money = [PubicVariable sumMoneyWithIncomeMode:isIncomeMode
                                                   withStyle:predicateMonthStyle
                                                    withDate:date
                                      inManagedObjectContext:self.managedObjectContext];
        [mutableArray addObject:[NSNumber numberWithFloat:fabs(money)]];
        
    }
    return [mutableArray copy];
    
}

-(NSInteger)weekCountOfMonthForDate:(NSDate *)aDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:aDate  options:0];
    
    NSDateComponents *components = [gregorian components: NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    
    //NSLog(@"year: %i",year);
    //NSLog(@"month: %i",month);
    
    NSDateComponents *firstDaycomps = [[NSDateComponents alloc] init];
    firstDaycomps.day = 1;
    firstDaycomps.month = month;
    firstDaycomps.year = year;
    
    
    NSDate *firstDate = [gregorian dateFromComponents:firstDaycomps];
    
    //NSLog(@"firstDate: %@",[PubicVariable stringFromDate:firstDate]);
    
    NSDateComponents *lastcomps = [[NSDateComponents alloc] init];
    lastcomps.day = -1;
    NSDate *lastDate = [gregorian dateByAddingComponents:lastcomps toDate:firstDate  options:0];
    
    NSDateComponents *resultComponents = [gregorian components: NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth
                                                      fromDate:lastDate];
    
    NSInteger result = [resultComponents weekOfMonth];
    /*
     NSInteger iyear = [resultComponents year];
     NSInteger imonth = [resultComponents month];
     NSInteger iday = [resultComponents day];
     
     
     
     NSLog(@"year: %i",iyear);
     NSLog(@"month: %i",imonth);
     NSLog(@"day: %i",iday);
     NSLog(@"weekCountOfMonth: %li",(long)result);
     */
    
    return result;
    
    
    
    
}

-(NSInteger)thisMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitMonth
                                                fromDate:[NSDate date]];
    NSInteger month = [components month];
    return month;
}

- (NSDate *)referenceDate {
    NSDate *result;
    NSInteger dateMode = [PubicVariable dateMode];
    switch (dateMode) {
        case week:
            result = [NSDate dateSinceNowByWeeks:self.pageIndex];;
            break;
        case month:
            result = [NSDate dateSinceNowByMonths:self.pageIndex];
            break;
        default:
            result = [NSDate dateSinceNowByYears:self.pageIndex];
            break;
    }
    return result;
}
- (NSString *)stringFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSDateIntervalFormatter *formatter = [[NSDateIntervalFormatter alloc] init];
    formatter.dateStyle = NSDateIntervalFormatterShortStyle;
    formatter.timeStyle = NSDateIntervalFormatterNoStyle;
    return [formatter stringFromDate:fromDate toDate:toDate];
    
}


@end
