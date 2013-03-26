//
//  EditContactViewController.h
//  iContactViewer
//
//  Created by Paul Himes on 3/8/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface EditContactViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) Contact *contact;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneAreaCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *phonePrefixTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneLineNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *twitterTextField;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftParenLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightParenLabel;
@property (weak, nonatomic) IBOutlet UILabel *dashLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)deleteContact:(id)sender;

- (void)hideCancelButton;

@end
