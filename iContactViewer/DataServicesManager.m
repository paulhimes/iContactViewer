//
//  DataServicesManager.m
//  iContactViewer
//
//  Created by Paul Himes on 3/23/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "DataServicesManager.h"

@interface DataServicesManager() <NSURLConnectionDelegate>

@end

@implementation DataServicesManager

- (void)fetchAllContactsWithCompletionHandler:(ContactsHandler)handler
{    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // This code will run on a background thread.        
        NSMutableArray *contacts = [NSMutableArray array];
        
        NSLog(@"About to fetch all contacts");
        
        // Setup the request.
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://contacts.tinyapollo.com/contacts?key=letitbe"]];
        
        // Make the request and get the response.
        NSURLResponse *response;
        NSError *error;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

        // Convert the response to objective c objects.
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        
        // Convert the generic objects to Contact model objects.
        NSArray *contactDictionaries = responseDictionary[@"contacts"];
        for (NSDictionary *contactDictionary in contactDictionaries) {
            Contact *contact = [self contactFromDictionary:contactDictionary];
            if (contact) {
                [contacts addObject:contact]; 
            }
        }
        
        // Sort the contacts by last name then first name.
        [contacts sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            Contact *contactOne = (Contact*)obj1;
            Contact *contactTwo = (Contact*)obj2;
            
            NSComparisonResult result = [contactOne.lastName compare:contactTwo.lastName];
            if (result == NSOrderedSame) {
                result = [contactOne.firstName compare:contactTwo.firstName];
            }
            
            return result;
        }];
                
        handler(contacts);
    });
}

- (Contact*)contactFromDictionary:(NSDictionary*)dictionary
{
    Contact *contact;
    
    if (dictionary) {
        contact = [[Contact alloc] init];
        
        // ID
        contact.uniqueId = dictionary[@"_id"];
        
        // Name
        NSString *fullName = dictionary[@"name"];
        NSArray *nameComponents = [fullName componentsSeparatedByString:@" "];
        if ([nameComponents count] > 0) {
            contact.firstName = nameComponents[0];
        }
        if ([nameComponents count] > 1) {
            contact.lastName = nameComponents[1];
        }
        
        // Title
        contact.title = dictionary[@"title"];
        
        // Phone
        NSArray *phoneComponents = [dictionary[@"phone"] componentsSeparatedByString:@"-"];
        if ([phoneComponents count] > 0) {
            contact.phoneAreaCode = phoneComponents[0];
        }
        if ([phoneComponents count] > 1) {
            contact.phonePrefix = phoneComponents[1];
        }
        if ([phoneComponents count] > 2) {
            contact.phoneLineNumber = phoneComponents[2];
        }
        
        // Email
        contact.email = dictionary[@"email"];
        
        // Twitter
        contact.twitterId = dictionary[@"twitterId"];
    }

    return contact;
}

- (void)updateContact:(Contact*)contact withCompletionHandler:(void(^)())handler
{
    
}

@end
