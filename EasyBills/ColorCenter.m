//
//  ColorCenter.m
//  EasyBills
//
//  Created by Beeth0ven on 3/5/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "ColorCenter.h"
#import "ChameleonFramework/Chameleon.h"

#define cantaloupeColor     [UIColor colorWithRed:255.0 / 255.0 green:204.0 / 255.0 blue:102.0 / 255.0 alpha:1.0f]
#define honeydewColor       [UIColor colorWithRed:204.0 / 255.0 green:255.0 / 255.0 blue:102.0 / 255.0 alpha:1.0f]
#define spindriftColor      [UIColor colorWithRed:102.0 / 255.0 green:255.0 / 255.0 blue:204.0 / 255.0 alpha:1.0f]
#define strawberryColor     [UIColor colorWithRed:255.0 / 255.0 green:  0.0 / 255.0 blue:128.0 / 255.0 alpha:1.0f]
#define lavenderColor       [UIColor colorWithRed:204.0 / 255.0 green:102.0 / 255.0 blue:255.0 / 255.0 alpha:1.0f]
#define carnationColor      [UIColor colorWithRed:255.0 / 255.0 green:111.0 / 255.0 blue:207.0 / 255.0 alpha:1.0f]
#define salmonColor         [UIColor colorWithRed:255.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0f]
#define bananaColor         [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:102.0 / 255.0 alpha:1.0f]
#define tangerineColor      [UIColor colorWithRed:255.0 / 255.0 green:128.0 / 255.0 blue:  0.0 / 255.0 alpha:1.0f]
#define orchidColor         [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:255.0 / 255.0 alpha:1.0f]

#define ironColor           [UIColor colorWithRed: 76.0 / 255.0 green: 76.0 / 255.0 blue: 76.0 / 255.0 alpha:1.0f]
#define magnesiumColor      [UIColor colorWithRed:128.0 / 255.0 green:128.0 / 255.0 blue:128.0 / 255.0 alpha:1.0f]
#define mochaColor          [UIColor colorWithRed:128.0 / 255.0 green: 64.0 / 255.0 blue:  0.0 / 255.0 alpha:1.0f]
#define oceanColor          [UIColor colorWithRed:  0.0 / 255.0 green: 64.0 / 255.0 blue:128.0 / 255.0 alpha:1.0f]
#define eggplantColor       [UIColor colorWithRed: 64.0 / 255.0 green:  0.0 / 255.0 blue:128.0 / 255.0 alpha:1.0f]
#define maroonColor         [UIColor colorWithRed:128.0 / 255.0 green:  0.0 / 255.0 blue: 64.0 / 255.0 alpha:1.0f]
#define asparagusColor      [UIColor colorWithRed:128.0 / 255.0 green:128.0 / 255.0 blue:  0.0 / 255.0 alpha:1.0f]
#define cloverColor         [UIColor colorWithRed:  0.0 / 255.0 green:128.0 / 255.0 blue:  0.0 / 255.0 alpha:1.0f]
#define tealColor           [UIColor colorWithRed:  0.0 / 255.0 green:128.0 / 255.0 blue:128.0 / 255.0 alpha:1.0f]
#define plumColor           [UIColor colorWithRed:128.0 / 255.0 green:  0.0 / 255.0 blue:128.0 / 255.0 alpha:1.0f]

@interface ColorCenter ()

@end




@implementation ColorCenter

+ (NSNumber *)assingColorIDIsIncome:(BOOL) isIncome{
    
    NSInteger colorIDIntergerValue = 0;
    
    
    if (isIncome) {
        //income case,idx to be 0..2..4..6....
        colorIDIntergerValue = [PubicVariable nextAssignIncomeColorIndex];
        NSInteger nextAssignColorIndex  = (colorIDIntergerValue + 2) % [[self colors] count];
        [PubicVariable setNextAssignIncomeColorIndex:nextAssignColorIndex];

    }
    else {
        //expense case,idx to be 1..3..5..7....
        colorIDIntergerValue = [PubicVariable nextAssignExpenseColorIndex];
        if (colorIDIntergerValue == 0)
            colorIDIntergerValue = 1;
        NSInteger nextAssignColorIndex  = (colorIDIntergerValue + 2) % [[self colors] count];
        [PubicVariable setNextAssignExpenseColorIndex:nextAssignColorIndex];

    }
    return [NSNumber numberWithInteger:colorIDIntergerValue] ;
}



+ (UIColor *)colorWithID:(NSNumber *)colorID{
    
    UIColor *color = nil;
    
    if (colorID.integerValue < self.colors.count) {
        color = [self.colors objectAtIndex:colorID.integerValue];
    }
    return color;
}


#pragma Property Method

+ (NSArray *)colors{
    
    //    return [[self incomeColors] arrayByAddingObjectsFromArray:
    //            [self expenseColors]];
    return @[
             FlatRed,
             FlatOrange,
             FlatYellow,
             FlatGreen,
             FlatPink,
             FlatBlue,
             FlatPurple,
             //             FlatBrown, FlatBrownDark,
             FlatCoffee,
             FlatForestGreen,
             FlatGray,
             FlatLime,
             FlatMagenta,
             FlatMaroon,
             FlatMint,
             //             FlatNavyBlue, FlatNavyBlueDark,
             FlatPlum,
             FlatPowderBlue,
             FlatSand,
             FlatSkyBlue,
             FlatTeal,
             FlatWatermelon,
             //             FlatWhite, FlatWhiteDark,
             //             FlatBlack, FlatBlackDark,
             ];
}
//
//+ (NSArray *)colors{
//    
//    //    return [[self incomeColors] arrayByAddingObjectsFromArray:
//    //            [self expenseColors]];
//    return @[
//             FlatRed, FlatRedDark,
//             FlatOrange, FlatOrangeDark,
//             FlatYellow, FlatYellowDark,
//             FlatGreen, FlatGreenDark,
//             FlatPink, FlatPinkDark,
//             FlatBlue, FlatBlueDark,
//             FlatPurple, FlatPurpleDark,
//             
//             //             FlatBrown, FlatBrownDark,
//             FlatCoffee, FlatCoffeeDark,
//             FlatForestGreen, FlatForestGreenDark,
//             FlatGray, FlatGrayDark,
//             FlatLime, FlatLimeDark,
//             FlatMagenta, FlatMagentaDark,
//             FlatMaroon, FlatMaroonDark,
//             FlatMint, FlatMintDark,
//             //             FlatNavyBlue, FlatNavyBlueDark,
//             FlatPlum, FlatPlumDark,
//             FlatPowderBlue, FlatPowderBlueDark,
//             FlatSand, FlatSandDark,
//             FlatSkyBlue, FlatSkyBlueDark,
//             FlatTeal, FlatTealDark,
//             FlatWatermelon, FlatWatermelonDark,
//             //             FlatWhite, FlatWhiteDark,
//             //             FlatBlack, FlatBlackDark,
//             ];
//}


+ (NSArray *)incomeColors{
    NSMutableArray *colors = [@[] mutableCopy];
    [[self colors] enumerateObjectsUsingBlock:^(UIColor *obj, NSUInteger idx, BOOL *stop) {
        if ((idx%2) == 0) {
            [colors insertObject:obj atIndex:0];
            NSLog(@"incomeColors idx: %lu",(unsigned long)idx);
        }
    }];
    return colors;
   //  @[cantaloupeColor,
//             honeydewColor,
//             spindriftColor,
//             strawberryColor,
//             lavenderColor,
//             carnationColor,
//             salmonColor,
//             bananaColor,
//             tangerineColor,
//             orchidColor];

}

+ (NSArray *)expenseColors{
    
    
    NSMutableArray *colors = [@[] mutableCopy];
    [[self colors] enumerateObjectsUsingBlock:^(UIColor *obj, NSUInteger idx, BOOL *stop) {
        if ((idx%2) == 1) {
            [colors insertObject:obj atIndex:0];
            NSLog(@"expenseColors idx: %lu",(unsigned long)idx);
        }
    }];
    return colors;
//    return @[ironColor,
//             magnesiumColor,
//             mochaColor,
//             oceanColor,
//             eggplantColor,
//             maroonColor,
//             asparagusColor,
//             cloverColor,
//             tealColor,
//             plumColor];
}


@end
