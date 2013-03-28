//
//  AlertHelper.h
//  iContactViewer
//
//  Created by Paul Himes on 3/27/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertHelper : NSObject

+ (UIAlertView*)showAlertWithTitle:(NSString*)title;
+ (void)hideAlertView:(UIAlertView*)alertView;

@end
