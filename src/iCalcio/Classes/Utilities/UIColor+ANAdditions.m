//
//  UIColor+ANAdditions.m
//  iComune
//
//  Created by Ali Servet Donmez on 5.9.12.
//  Copyright (c) 2012 Apex-net. All rights reserved.
//

#import "UIColor+ANAdditions.h"

@implementation UIColor (ANAdditions)

+ (UIColor *)colorWithArithmeticNotation:(NSString *)notation
{
    static NSRegularExpression *regex;
    if (regex == nil) {
        NSString *zeroToOneRange = @"((?:0+\\.[0-9]+)|(?:0*1\\.0+))"; // from 0.0 to 1.0

        NSError *error;
        regex = [NSRegularExpression regularExpressionWithPattern:zeroToOneRange options:0 error:&error];
        NSAssert(error == nil, @"%@", [error localizedDescription]);
    }

    NSArray *matches = [regex matchesInString:notation options:0 range:NSMakeRange(0, [notation length])];
    NSAssert([matches count] == 4, @"Unrecognized arithmetic notation!");

    static NSNumberFormatter *formatter;
    if (formatter == nil) {
        formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        // (Ref.: "Parsing Date Strings" in "Data Formatting Guide")
        // (Ref.: Technical Q&A QA1480)
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    }

    return [UIColor colorWithRed:[[formatter numberFromString:[notation substringWithRange:[matches[0] range]]] floatValue]
                           green:[[formatter numberFromString:[notation substringWithRange:[matches[1] range]]] floatValue]
                            blue:[[formatter numberFromString:[notation substringWithRange:[matches[2] range]]] floatValue]
                           alpha:[[formatter numberFromString:[notation substringWithRange:[matches[3] range]]] floatValue]];
}

@end
