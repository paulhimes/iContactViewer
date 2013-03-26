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

+ (void)fetchAllContactsWithCompletionHandler:(ContactsHandler)handler
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

+ (void)saveNewContact:(Contact*)contact withCompletionHandler:(void(^)(Contact *contact))handler
{
    [DataServicesManager persistContact:contact usingPost:YES withCompletionHandler:handler];
}

+ (void)updateContact:(Contact*)contact withCompletionHandler:(void(^)(Contact *contact))handler
{
    [DataServicesManager persistContact:contact usingPost:NO withCompletionHandler:handler];
}

+ (void)deleteContact:(Contact*)contact withCompletionHandler:(void(^)(BOOL success))handler
{
    if (contact && [contact.uniqueId length] > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // This code will run on a background thread.
            
            NSLog(@"About to delete a contact");
            
            // Setup the request.
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://contacts.tinyapollo.com/contacts/%@?key=letitbe", contact.uniqueId]]];
            [request setHTTPMethod:@"DELETE"];
            
            // Make the request and get the response.
            NSURLResponse *response;
            NSError *error;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            // Convert the response to objective c objects.
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
            
            // Send the new or updated contact back to the caller.
            handler([responseDictionary[@"status"] isEqualToString:@"success"]);
        });
    }
}

#pragma mark - Helper methods

+ (void)persistContact:(Contact*)contact usingPost:(BOOL)usePost withCompletionHandler:(void(^)(Contact *contact))handler
{
    if (contact) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // This code will run on a background thread.
            
            NSLog(@"About to persist a contact");
            
            // Setup the request.
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://contacts.tinyapollo.com/contacts%@?key=letitbe", usePost ? @"" : [NSString stringWithFormat:@"/%@", contact.uniqueId]]]];
            [request setHTTPMethod:usePost ? @"POST" : @"PUT"];
            [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            NSString *bodyData = [self urlEncodedStringFromContact:contact];
            [request setValue:[NSString stringWithFormat:@"%d", [bodyData length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody:[bodyData dataUsingEncoding:NSASCIIStringEncoding]];
            
            // Make the request and get the response.
            NSURLResponse *response;
            NSError *error;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

            // Convert the response to objective c objects.
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
            
            // Get the updated contact (now it has a uniqueId).
            Contact *contact = [self contactFromDictionary:responseDictionary[@"contact"]];
            
            // Send the new or updated contact back to the caller.
            handler(contact);
        });
    }
}

+ (Contact*)contactFromDictionary:(NSDictionary*)dictionary
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

+ (NSString*)urlEncodedStringFromContact:(Contact*)contact
{
    NSMutableString *urlEncodedString = [@"" mutableCopy];
    [urlEncodedString appendFormat:@"name=%@&", [contact fullName]];
    [urlEncodedString appendFormat:@"title=%@&", contact.title];
    [urlEncodedString appendFormat:@"phone=%@-%@-%@&", contact.phoneAreaCode, contact.phonePrefix, contact.phoneLineNumber];
    [urlEncodedString appendFormat:@"email=%@&", contact.email];
    [urlEncodedString appendFormat:@"twitterId=%@", contact.twitterId];
    
    return urlEncodedString;
}

@end
