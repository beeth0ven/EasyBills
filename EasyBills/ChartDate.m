//
//  ChartDate.m
//  我的账本
//
//  Created by 罗 杰 on 9/21/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "ChartDate.h"
#import "PubicVariable+FetchRequest.h"


@interface ChartDate ()

@property (strong, nonatomic) NSArray *xLabels;
@property (strong, nonatomic) NSArray *incomeDataArray;
@property (strong, nonatomic) NSArray *expenseDataArray;


@end
@implementation ChartDate

-(NSArray *)xLabels
{
    NSInteger dateMode = [PubicVariable dateMode];
    switch (dateMode) {
        case week:
            _xLabels = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
            break;
        case month:
        {
            NSInteger weekCountOfMonth = [self weekCountOfMonth];
            NSArray *array = @[@"第一周",@"第二周",@"第三周",@"第四周",@"第五周",@"第六周"];
            NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < weekCountOfMonth; i++) {
                [mutableArray addObject:array[i]];
            }
            _xLabels = [mutableArray copy];
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


-(NSArray *)incomeDataArray
{


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
    return _incomeDataArray;
}


-(NSArray *)expenseDataArray
{
    
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
    return _expenseDataArray;
}


-(NSArray *)weekModeDataArryIsincomeMode:(NSInteger)isIncomeMode
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSMutableArray *mutableArray =[[NSMutableArray alloc]init];
    NSDateComponents *components = [gregorian components: NSCalendarUnitWeekday
                                                fromDate:[NSDate date]];
    NSInteger weekday = [components weekday];
    for (NSInteger day = -weekday+1; day <= -weekday + 7; day++) {
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:day];
        NSDate *date = [gregorian dateByAddingComponents:comps toDate:[NSDate date]  options:0];
        float  money = [PubicVariable sumMoneyWithIncomeMode:isIncomeMode withStyle:predicateDayStyle withDate:date];
        [mutableArray addObject:[NSNumber numberWithFloat:fabs(money)]];
        
    }
    return [mutableArray copy];

}

-(NSArray *)monthModeDataArryIsincomeMode:(NSInteger)isIncomeMode
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSMutableArray *mutableArray =[[NSMutableArray alloc]init];
    NSDateComponents *components = [gregorian components:   NSCalendarUnitWeekOfMonth
                                                fromDate:[NSDate date]];
    
    NSInteger weekCountOfMonth = [self weekCountOfMonth];
    NSInteger weekOfMonth = [components weekOfMonth];
    
    for (NSInteger week = -weekOfMonth+1; week <= -weekOfMonth + weekCountOfMonth; week++) {
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:week*7];
        NSDate *date = [gregorian dateByAddingComponents:comps toDate:[NSDate date]  options:0];
        float  money = [PubicVariable sumMoneyWithIncomeMode:isIncomeMode withStyle:predicateWeekInMonthStyle withDate:date];
        /*
        NSLog(@"dateWeekID = %@",[PubicVariable weekIDWithDate:date]);
        NSLog(@"isIncomeMode = %li",(long)isIncomeMode);
        NSLog(@"money = %.2f",money);
         */
        [mutableArray addObject:[NSNumber numberWithFloat:fabs(money)]];
        
    }
    return [mutableArray copy];
    
}

-(NSArray *)allModeDataArryIsincomeMode:(NSInteger)isIncomeMode
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSMutableArray *mutableArray =[[NSMutableArray alloc]init];

    
    for (NSInteger month = -5; month <= 0 ; month++) {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setMonth:month];
        NSDate *date = [gregorian dateByAddingComponents:comps toDate:[NSDate date]  options:0];
        float  money = [PubicVariable sumMoneyWithIncomeMode:isIncomeMode withStyle:predicateMonthStyle withDate:date];
        [mutableArray addObject:[NSNumber numberWithFloat:fabs(money)]];
        
    }
    return [mutableArray copy];
    
}

-(NSInteger)weekCountOfMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:[NSDate date]  options:0];

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

@end
