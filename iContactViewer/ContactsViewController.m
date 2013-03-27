//
//  ContactsViewController.m
//  iContactViewer
//
//  Created by Paul Himes on 3/7/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "ContactsViewController.h"
#import "Contact.h"
#import "ContactViewController.h"
#import "EditContactViewController.h"
#import "DataServicesManager.h"

@interface ContactsViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *contacts;

@end

@implementation ContactsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad]; 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Detail"]) {
        ContactViewController *contactViewController = segue.destinationViewController;
        contactViewController.contact = self.contacts[[self.tableView indexPathForSelectedRow].row];
    } else if ([segue.identifier isEqualToString:@"Add"]) {
        
        // Create a new contact.
        Contact *contact = [[Contact alloc] init];
        
        EditContactViewController *editContactViewController = (EditContactViewController*)((UINavigationController*)segue.destinationViewController).topViewController;
        editContactViewController.contact = contact;
        [editContactViewController hideCancelButton];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Contact *contact = self.contacts[indexPath.row];
    
    cell.textLabel.text = [contact fullName];
    cell.detailTextLabel.text = contact.title;
    cell.textLabel.textColor = [Theme bodyTextHeaderColor];
    cell.detailTextLabel.textColor = [Theme bodyTextColor];
    
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[Theme bodyTextColor]];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Contact *contact = self.contacts[indexPath.row];
        
        [DataServicesManager deleteContact:contact
                     withCompletionHandler:^(BOOL success) {
                         if (success) {
                             dispatch_sync(dispatch_get_main_queue(), ^{
                                 [self.contacts removeObject:contact];
                                 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                             });
                         }
                     }];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            // Dismiss
            break;
        case 1:
            // Reset
            [self resetHardcodedContacts];
            break;
        default:
            break;
    }
}

#pragma mark - Helper Methods

- (void)resetHardcodedContacts
{
    NSLog(@"About to reset contacts");
    // Fetch all existing contacts.
    [DataServicesManager fetchAllContactsWithCompletionHandler:^(NSArray *contacts) {
        __block NSInteger outstandingContacts = [contacts count];
        dispatch_queue_t syncQueue = dispatch_queue_create("syncQueue", DISPATCH_QUEUE_SERIAL);
        
        // Delete each contact.
        for (Contact* contact in contacts) {
            [DataServicesManager deleteContact:contact withCompletionHandler:^(BOOL success) {
                // Sequentialize access to the outstandingContacts counter.
                dispatch_sync(syncQueue, ^{
                    // Decrement the outstandingContacts counter.
                    outstandingContacts--;
                    NSLog(@"outstanding set to %d", outstandingContacts);
                });
            }];
        }
        
        while (outstandingContacts > 0) {
            // Waiting for one or more outstanding deletes to complete.
        }
        
        // All preexisting contacts have been deleted (or at least attempted to).
        NSLog(@"done!");
        NSMutableArray *newContacts = [NSMutableArray array];
        
        Contact *contact = [[Contact alloc] init];
        contact.firstName = @"Malcom";
        contact.lastName = @"Reynolds";
        contact.email = @"mal@serenity.com";
        contact.title = @"Captain";
        contact.twitterId = @"malcomreynolds";
        contact.phoneAreaCode = @"612";
        contact.phonePrefix = @"555";
        contact.phoneLineNumber = @"1234";
        [newContacts addObject:contact];
        
        contact = [[Contact alloc] init];
        contact.firstName = @"Zoe";
        contact.lastName = @"Washburne";
        contact.email = @"zoe@serenity.com";
        contact.title = @"First Mate";
        contact.twitterId = @"zoewashburne";
        contact.phoneAreaCode = @"612";
        contact.phonePrefix = @"555";
        contact.phoneLineNumber = @"5678";
        [newContacts addObject:contact];
        
        contact = [[Contact alloc] init];
        contact.firstName = @"Hoban";
        contact.lastName = @"Washburne";
        contact.email = @"wash@serenity.com";
        contact.title = @"Pilot";
        contact.twitterId = @"wash";
        contact.phoneAreaCode = @"612";
        contact.phonePrefix = @"555";
        contact.phoneLineNumber = @"9012";
        [newContacts addObject:contact];
        
        contact = [[Contact alloc] init];
        contact.firstName = @"Jayne";
        contact.lastName = @"Cobb";
        contact.email = @"jayne@serenity.com";
        contact.title = @"Muscle";
        contact.twitterId = @"heroofcanton";
        contact.phoneAreaCode = @"612";
        contact.phonePrefix = @"555";
        contact.phoneLineNumber = @"3456";
        [newContacts addObject:contact];
        
        contact = [[Contact alloc] init];
        contact.firstName = @"Kaylee";
        contact.lastName = @"Frye";
        contact.email = @"kaylee@serenity.com";
        contact.title = @"Engineer";
        contact.twitterId = @"kaylee";
        contact.phoneAreaCode = @"612";
        contact.phonePrefix = @"555";
        contact.phoneLineNumber = @"7890";
        [newContacts addObject:contact];
        
        contact = [[Contact alloc] init];
        contact.firstName = @"Simon";
        contact.lastName = @"Tam";
        contact.email = @"simon@serenity.com";
        contact.title = @"Doctor";
        contact.twitterId = @"simontam";
        contact.phoneAreaCode = @"612";
        contact.phonePrefix = @"555";
        contact.phoneLineNumber = @"4321";
        [newContacts addObject:contact];
        
        contact = [[Contact alloc] init];
        contact.firstName = @"River";
        contact.lastName = @"Tam";
        contact.email = @"river@serenity.com";
        contact.title = @"Doctor's Sister";
        contact.twitterId = @"miranda";
        contact.phoneAreaCode = @"612";
        contact.phonePrefix = @"555";
        contact.phoneLineNumber = @"8765";
        [newContacts addObject:contact];
        
        contact = [[Contact alloc] init];
        contact.firstName = @"Shepherd";
        contact.lastName = @"Book";
        contact.email = @"shepherd@serenity.com";
        contact.title = @"Shepherd";
        contact.twitterId = @"shepherdbook";
        contact.phoneAreaCode = @"612";
        contact.phonePrefix = @"555";
        contact.phoneLineNumber = @"2109";
        [newContacts addObject:contact];
        
        // Setup the outstanding count again.
        outstandingContacts = [newContacts count];
        
        // Save each new contacts.
        for (Contact *contact in newContacts) {
            [DataServicesManager saveNewContact:contact withCompletionHandler:^(Contact *contact) {
                // Sequentialize access to the outstandingContacts counter.
                dispatch_sync(syncQueue, ^{
                    // Decrement the outstandingContacts counter.
                    outstandingContacts--;
                    NSLog(@"outstanding set to %d", outstandingContacts);
                });
            }];
        }
        
        while (outstandingContacts > 0) {
            // Waiting for one or more outstanding saves to complete.
        }
        
        // All new contacts have been saved (or at least attempted to).
        NSLog(@"done!");
        
        [self refreshTable];
    }];
}

- (IBAction)showInfo:(id)sender {
    NSString *message = @"iContactViewer w/REST was developed by Let It Be.\n\nSENG 5199-1  Spring 2013\n\n- Paul Himes\n- Eranda Kotalawala\n- Chad Linke\n- Michael Pillsbury";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Credits" message:message delegate:self cancelButtonTitle:@"Shiny" otherButtonTitles:@"Reset Data", nil];
    [alertView show];
}

- (void)refreshTable
{
    [DataServicesManager fetchAllContactsWithCompletionHandler:^(NSArray *contacts) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.contacts = [contacts mutableCopy];
            [self.tableView reloadData];
        });
    }];
}

@end
