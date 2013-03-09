//
//  EditContactViewController.h
//  iContactViewer
//
//  Created by Paul Himes on 3/8/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface EditContactViewController : UITableViewController

@property (nonatomic, strong) Contact *contact;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneAreaCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *phonePrefixTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneLineNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *twitterTextField;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)changePhoto:(id)sender;
- (IBAction)deleteContact:(id)sender;

@end
