//
//  ContactViewController.m
//  iContactViewer
//
//  Created by Paul Himes on 3/8/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "ContactViewController.h"
#import "EditContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [Theme bodyColor];
    self.nameLabel.textColor = [Theme bodyTextHeaderColor];
    self.titleLabel.textColor = [Theme bodyTextColor];
    self.phoneNumberLabel.textColor = [Theme bodyTextColor];
    self.emailAddressLabel.textColor = [Theme bodyTextColor];
    self.twitterIdLabel.textColor = [Theme bodyTextColor];
    
    self.phoneTitleLabel.textColor = [Theme bodyTextHeaderColor];
    self.emailTitleLabel.textColor = [Theme bodyTextHeaderColor];
    self.twitterTitleLabel.textColor = [Theme bodyTextHeaderColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.contact.uniqueId) {
        [self updateDataFields];
    } else {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Edit"]) {
        EditContactViewController *editContactViewController = (EditContactViewController*)((UINavigationController*)segue.destinationViewController).topViewController;
        editContactViewController.contact = self.contact;
    }
}

#pragma mark - Helper methods

- (void)updateDataFields
{
    self.title = [self.contact fullName];
    self.nameLabel.text = [self.contact fullName];
    self.titleLabel.text = self.contact.title;
    self.phoneNumberLabel.text = [self.contact fullPhone];
    self.emailAddressLabel.text = self.contact.email ;
    self.twitterIdLabel.text = self.contact.twitterId;
    
    // Set the contact photo to one of the hard-coded photos or a generic image based on the full name.
    NSString *fullName = [self.contact fullName];
    UIImage *image = [UIImage imageNamed:@"firefly.jpg"];
    if ([fullName isEqualToString:@"Malcom Reynolds"]) {
        image = [UIImage imageNamed:@"mal.jpg"];
    }
    if ([fullName isEqualToString:@"Zoe Washburne"]) {
        image = [UIImage imageNamed:@"zoe.jpg"];
    }
    if ([fullName isEqualToString:@"Hoban Washburne"]) {
        image = [UIImage imageNamed:@"wash.jpg"];
    }
    if ([fullName isEqualToString:@"Jayne Cobb"]) {
        image = [UIImage imageNamed:@"jayne.jpg"];
    }
    if ([fullName isEqualToString:@"Kaylee Frye"]) {
        image = [UIImage imageNamed:@"kaylee.jpg"];
    }
    if ([fullName isEqualToString:@"Simon Tam"]) {
        image = [UIImage imageNamed:@"simon.jpg"];
    }
    if ([fullName isEqualToString:@"River Tam"]) {
        image = [UIImage imageNamed:@"river.jpg"];
    }
    if ([fullName isEqualToString:@"Shepherd Book"]) {
        image = [UIImage imageNamed:@"shepherd.jpg"];
    }
    
    self.photoImageView.image = image;
}

@end
