//
//  Contact.h
//  iContactViewer
//
//  Created by Paul Himes on 3/8/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic, strong) NSString * uniqueId;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, strong) NSString * phoneAreaCode;
@property (nonatomic, strong) NSString * phoneLineNumber;
@property (nonatomic, strong) NSString * phonePrefix;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * twitterId;

- (NSString*)fullName;
- (NSString*)fullPhone;

@end
