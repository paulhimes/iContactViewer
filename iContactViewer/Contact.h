//
//  Contact.h
//  iContactViewer
//
//  Created by Paul Himes on 3/8/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

static NSString* const kContactEntityName = @"Contact";

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * phoneAreaCode;
@property (nonatomic, retain) NSNumber * phoneLineNumber;
@property (nonatomic, retain) NSNumber * phonePrefix;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * twitterId;

- (NSString*)fullName;
- (NSString*)fullPhone;

@end
