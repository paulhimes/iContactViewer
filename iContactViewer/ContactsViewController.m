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

@interface ContactsViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchController;

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

    // Set hardcoded contacts on the first launch.
    NSString *hasSetKey = @"HasLoadedHardcodedContacts";
    if (![[NSUserDefaults standardUserDefaults] boolForKey:hasSetKey]) {
        [self resetHardcodedContacts];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:hasSetKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kContactEntityName];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]];
    
    self.fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.fetchController performFetch:NULL];
    [self.tableView reloadData];
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
        contactViewController.contact = [self.fetchController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        contactViewController.context = self.context;
    } else if ([segue.identifier isEqualToString:@"Add"]) {
        
        // Create a new contact.
        Contact *contact = [NSEntityDescription insertNewObjectForEntityForName:kContactEntityName inManagedObjectContext:self.context];
        [self.context save:NULL];
        
        EditContactViewController *editContactViewController = (EditContactViewController*)((UINavigationController*)segue.destinationViewController).topViewController;
        editContactViewController.contact = contact;
        editContactViewController.context = self.context;
        [editContactViewController hideCancelButton];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.fetchController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    
    // Configure the cell...
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchController.sections[indexPath.section];
    Contact *contact = (Contact*)sectionInfo.objects[indexPath.row];
    
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
        Contact *contact = [self.fetchController objectAtIndexPath:indexPath];
        [self.context deleteObject:contact];
        [self.context save:NULL];
        [self.fetchController performFetch:NULL];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
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
            [self.fetchController performFetch:NULL];
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}

#pragma mark - Helper Methods

- (void)resetHardcodedContacts
{
    NSArray *allContacts = [self.context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:kContactEntityName] error:NULL];
    for (Contact *contact in allContacts) {
        [self.context deleteObject:contact];
    }

    Contact *contact = [NSEntityDescription insertNewObjectForEntityForName:kContactEntityName inManagedObjectContext:self.context];
    contact.firstName = @"Malcom";
    contact.lastName = @"Reynolds";
    contact.email = @"mal@serenity.com";
    contact.title = @"Captain";
    contact.twitterId = @"malcomreynolds";
    contact.phoneAreaCode = @"612";
    contact.phonePrefix = @"555";
    contact.phoneLineNumber = @"1234";
    contact.photo = UIImageJPEGRepresentation([UIImage imageNamed:@"mal.jpg"], 1);
    
    contact = [NSEntityDescription insertNewObjectForEntityForName:kContactEntityName inManagedObjectContext:self.context];
    contact.firstName = @"Zoe";
    contact.lastName = @"Washburne";
    contact.email = @"zoe@serenity.com";
    contact.title = @"First Mate";
    contact.twitterId = @"zoewashburne";
    contact.phoneAreaCode = @"612";
    contact.phonePrefix = @"555";
    contact.phoneLineNumber = @"5678";
    contact.photo = UIImageJPEGRepresentation([UIImage imageNamed:@"zoe.jpg"], 1);
    
    contact = [NSEntityDescription insertNewObjectForEntityForName:kContactEntityName inManagedObjectContext:self.context];
    contact.firstName = @"Hoban";
    contact.lastName = @"Washburne";
    contact.email = @"wash@serenity.com";
    contact.title = @"Pilot";
    contact.twitterId = @"wash";
    contact.phoneAreaCode = @"612";
    contact.phonePrefix = @"555";
    contact.phoneLineNumber = @"9012";
    contact.photo = UIImageJPEGRepresentation([UIImage imageNamed:@"wash.jpg"], 1);
    
    contact = [NSEntityDescription insertNewObjectForEntityForName:kContactEntityName inManagedObjectContext:self.context];
    contact.firstName = @"Jayne";
    contact.lastName = @"Cobb";
    contact.email = @"jayne@serenity.com";
    contact.title = @"Muscle";
    contact.twitterId = @"heroofcanton";
    contact.phoneAreaCode = @"612";
    contact.phonePrefix = @"555";
    contact.phoneLineNumber = @"3456";
    contact.photo = UIImageJPEGRepresentation([UIImage imageNamed:@"jayne.jpg"], 1);

    contact = [NSEntityDescription insertNewObjectForEntityForName:kContactEntityName inManagedObjectContext:self.context];
    contact.firstName = @"Kaylee";
    contact.lastName = @"Frye";
    contact.email = @"kaylee@serenity.com";
    contact.title = @"Engineer";
    contact.twitterId = @"kaylee";
    contact.phoneAreaCode = @"612";
    contact.phonePrefix = @"555";
    contact.phoneLineNumber = @"7890";
    contact.photo = UIImageJPEGRepresentation([UIImage imageNamed:@"kaylee.jpg"], 1);

    contact = [NSEntityDescription insertNewObjectForEntityForName:kContactEntityName inManagedObjectContext:self.context];
    contact.firstName = @"Simon";
    contact.lastName = @"Tam";
    contact.email = @"simon@serenity.com";
    contact.title = @"Doctor";
    contact.twitterId = @"simontam";
    contact.phoneAreaCode = @"612";
    contact.phonePrefix = @"555";
    contact.phoneLineNumber = @"4321";
    contact.photo = UIImageJPEGRepresentation([UIImage imageNamed:@"simon.jpg"], 1);

    contact = [NSEntityDescription insertNewObjectForEntityForName:kContactEntityName inManagedObjectContext:self.context];
    contact.firstName = @"River";
    contact.lastName = @"Tam";
    contact.email = @"river@serenity.com";
    contact.title = @"Doctor's Sister";
    contact.twitterId = @"miranda";
    contact.phoneAreaCode = @"612";
    contact.phonePrefix = @"555";
    contact.phoneLineNumber = @"8765";
    contact.photo = UIImageJPEGRepresentation([UIImage imageNamed:@"river.jpg"], 1);

    contact = [NSEntityDescription insertNewObjectForEntityForName:kContactEntityName inManagedObjectContext:self.context];
    contact.firstName = @"Shepherd";
    contact.lastName = @"Book";
    contact.email = @"shepherd@serenity.com";
    contact.title = @"Shepherd";
    contact.twitterId = @"shepherdbook";
    contact.phoneAreaCode = @"612";
    contact.phonePrefix = @"555";
    contact.phoneLineNumber = @"2109";
    contact.photo = UIImageJPEGRepresentation([UIImage imageNamed:@"shepherd.jpg"], 1);

    [self.context save:NULL];
}

- (IBAction)showInfo:(id)sender {
    NSString *message = @"iContactViewer was developed by Let It Be.\n\nSENG 5199-1  Spring 2013\n\n- Paul Himes\n- Eranda Kotalawala\n- Chad Linke\n- Michael Pillsbury";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Credits" message:message delegate:self cancelButtonTitle:@"Shiny" otherButtonTitles:@"Reset Data", nil];
    [alertView show];
}

@end
