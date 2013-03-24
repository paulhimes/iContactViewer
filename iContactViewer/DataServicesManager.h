//
//  DataServicesManager.h
//  iContactViewer
//
//  Created by Paul Himes on 3/23/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

typedef void (^ContactsHandler)(NSArray* contacts);

@interface DataServicesManager : NSObject

- (void)fetchAllContactsWithCompletionHandler:(ContactsHandler)handler;
- (void)updateContact:(Contact*)contact withCompletionHandler:(void(^)())handler;


@end
