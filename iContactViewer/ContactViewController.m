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
    if (self.contact.photo) {
        self.photoImageView.image = [UIImage imageWithData:self.contact.photo];
    }
}

@end
