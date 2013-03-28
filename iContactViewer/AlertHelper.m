//
//  AlertHelper.m
//  iContactViewer
//
//  Created by Paul Himes on 3/27/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "AlertHelper.h"

@implementation AlertHelper

+ (UIAlertView*)showAlertWithTitle:(NSString*)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:@"\n"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(139.5, 75.5); // .5 so it doesn't blur
    [alertView addSubview:spinner];
    [spinner startAnimating];
    [alertView show];
    
    return alertView;
}

+ (void)hideAlertView:(UIAlertView*)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

@end
