//
//  Contact.m
//  iContactViewer
//
//  Created by Paul Himes on 3/8/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "Contact.h"


@implementation Contact

@dynamic email;
@dynamic firstName;
@dynamic lastName;
@dynamic phoneAreaCode;
@dynamic phoneLineNumber;
@dynamic phonePrefix;
@dynamic photo;
@dynamic title;
@dynamic twitterId;

- (NSString*)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (NSString*)fullPhone
{
    return [NSString stringWithFormat:@"(%@) %@-%@", self.phoneAreaCode, self.phonePrefix, self.phoneLineNumber];
}

@end
