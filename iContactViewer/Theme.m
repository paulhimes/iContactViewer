//
//  Theme.m
//  iContactViewer
//
//  Created by Paul Himes on 3/9/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "Theme.h"

@implementation Theme

+ (UIColor*)headerColor
{
    return [UIColor colorWithRed:79/255.0 green:39/255.0 blue:15/255.0 alpha:1.0];
}

+ (UIColor*)bodyColor
{
    UIImage *paperImage = [[UIImage imageNamed:@"paper.jpg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    return [UIColor colorWithPatternImage:paperImage];
}

+ (UIColor*)bodyTextColor
{
    return [UIColor colorWithRed:89/255.0 green:49/255.0 blue:25/255.0 alpha:1.0];
}

+ (UIColor*)bodyTextHeaderColor
{
    return [UIColor colorWithRed:69/255.0 green:29/255.0 blue:5/255.0 alpha:1.0];
}

+ (UIColor*)bodyControlColor
{
    return [UIColor colorWithRed:79/255.0 green:39/255.0 blue:15/255.0 alpha:0.1];
}

+ (UIColor*)bodyControlTextColor
{
    return [Theme bodyTextColor];
}

+ (UIColor*)deleteColor
{
    return [UIColor colorWithRed:0.3 green:0 blue:0 alpha:0.4];
}

+ (UIColor*)deleteTextColor
{
    return [UIColor whiteColor];
}


@end
