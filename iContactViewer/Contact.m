//
//  Contact.m
//  iContactViewer
//
//  Created by Paul Himes on 3/8/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "Contact.h"


@implementation Contact

- (NSString*)fullName
{
    NSString *fullName = @"No Name";
    
    if (self.firstName && self.lastName) {
        fullName = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    } else if (self.firstName) {
        fullName = self.firstName;
    } else if (self.lastName) {
        fullName = self.lastName;
    }
    
    return fullName;
}

- (NSString*)fullPhone
{
    NSString *fullPhone = @"";

    if (self.phoneAreaCode || self.phonePrefix || self.phoneLineNumber) {
        NSMutableString *phoneString = [NSMutableString stringWithString:@""];
        
        if ([self.phoneAreaCode length] > 0) {
            [phoneString appendFormat:@"(%@) ", self.phoneAreaCode];
        }
        
        if ([self.phonePrefix length] > 0 && [self.phoneLineNumber length] > 0) {
            [phoneString appendFormat:@"%@-%@", self.phonePrefix, self.phoneLineNumber];
        } else if ([self.phonePrefix length] > 0) {
            [phoneString appendFormat:@"%@", self.phonePrefix];
        } else if ([self.phoneLineNumber length] > 0) {
            [phoneString appendFormat:@"%@", self.phoneLineNumber];
        }
        
        fullPhone = phoneString;
    }
    
    return fullPhone;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Contact[id=%@, name=%@, title=%@, phone=%@, email=%@, twitterId=%@]", self.uniqueId, [self fullName], self.title, [self fullPhone], self.email, self.twitterId];
}

@end
