//
//  EditContactViewController.m
//  iContactViewer
//
//  Created by Paul Himes on 3/8/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "EditContactViewController.h"
#import "DataServicesManager.h"
#import "AlertHelper.h"

@interface EditContactViewController () <UINavigationControllerDelegate>

@end

@implementation EditContactViewController

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

    self.firstNameTextField.text = self.contact.firstName;
    self.lastNameTextField.text = self.contact.lastName;
    self.titleTextField.text = self.contact.title;
    if (self.contact.phoneAreaCode) {
        self.phoneAreaCodeTextField.text = self.contact.phoneAreaCode;
    }
    if (self.contact.phonePrefix) {
        self.phonePrefixTextField.text = self.contact.phonePrefix;
    }
    if (self.contact.phoneLineNumber) {
        self.phoneLineNumberTextField.text = self.contact.phoneLineNumber;
    }
    self.emailTextField.text = self.contact.email;
    self.twitterTextField.text = self.contact.twitterId;
    
    [self styleTextField:self.firstNameTextField];
    [self styleTextField:self.lastNameTextField];
    [self styleTextField:self.titleTextField];
    [self styleTextField:self.phoneAreaCodeTextField];
    [self styleTextField:self.phonePrefixTextField];
    [self styleTextField:self.phoneLineNumberTextField];
    [self styleTextField:self.emailTextField];
    [self styleTextField:self.twitterTextField];
    self.deleteButton.backgroundColor = [Theme deleteColor];
    [self.deleteButton setTitleColor:[Theme deleteTextColor] forState:UIControlStateNormal];
    self.deleteButton.layer.cornerRadius = 5;
    self.deleteButton.layer.borderColor = [Theme deleteBorderColor].CGColor;
    self.deleteButton.layer.borderWidth = 2;
    
    self.firstNameLabel.textColor = [Theme bodyTextHeaderColor];
    self.lastNameLabel.textColor = [Theme bodyTextHeaderColor];
    self.titleLabel.textColor = [Theme bodyTextHeaderColor];
    self.phoneLabel.textColor = [Theme bodyTextHeaderColor];
    self.emailLabel.textColor = [Theme bodyTextHeaderColor];
    self.twitterLabel.textColor = [Theme bodyTextHeaderColor];
    self.leftParenLabel.textColor = [Theme bodyTextHeaderColor];
    self.rightParenLabel.textColor = [Theme bodyTextHeaderColor];
    self.dashLabel.textColor = [Theme bodyTextHeaderColor];

}

- (IBAction)cancel:(id)sender {
    [self hide];
}

- (IBAction)save:(id)sender {
    [self updateContact];
}

- (IBAction)deleteContact:(id)sender {
    
    UIAlertView *alertView = [AlertHelper showAlertWithTitle:[NSString stringWithFormat:@"Deleting %@", [self.contact fullName]]];
    
    [DataServicesManager deleteContact:self.contact
                 withCompletionHandler:^(BOOL success) {
                     
                     if (success) {
                         self.contact.uniqueId = nil;
                     }
                     
                     dispatch_sync(dispatch_get_main_queue(), ^{
                         [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
                         [AlertHelper hideAlertView:alertView];
                     });
                 }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.firstNameTextField) {
        [self.lastNameTextField becomeFirstResponder];
    } else if (textField == self.lastNameTextField) {
        [self.titleTextField becomeFirstResponder];
    } else if (textField == self.titleTextField) {
        [self.phoneAreaCodeTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        [self.twitterTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL result = YES;
    NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.phoneAreaCodeTextField) {
        if ([changedString length] > 3) {
            result = NO;
        }
    } else if (textField == self.phonePrefixTextField) {
        if ([changedString length] > 3) {
            result = NO;
        }
    } else if (textField == self.phoneLineNumberTextField) {
        if ([changedString length] > 4) {
            result = NO;
        }
    }
    
    return result;
}

#pragma mark - Helper methods

- (void)hide
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)updateContact
{
    self.contact.firstName = self.firstNameTextField.text;
    self.contact.lastName = self.lastNameTextField.text;
    self.contact.title = self.titleTextField.text;
    self.contact.phoneAreaCode = self.phoneAreaCodeTextField.text;
    self.contact.phonePrefix = self.phonePrefixTextField.text;
    self.contact.phoneLineNumber = self.phoneLineNumberTextField.text;
    self.contact.email = self.emailTextField.text;
    self.contact.twitterId = self.twitterTextField.text;
    
    if (self.contact.uniqueId) {
        // update
        UIAlertView *alertView = [AlertHelper showAlertWithTitle:[NSString stringWithFormat:@"Updating %@", [self.contact fullName]]];

        [DataServicesManager updateContact:self.contact
                     withCompletionHandler:^(Contact *contact) {                         
                         dispatch_sync(dispatch_get_main_queue(), ^{
                             [self hide];
                             [AlertHelper hideAlertView:alertView];
                         });
                     }];
    } else {
        // save new contact
        UIAlertView *alertView = [AlertHelper showAlertWithTitle:[NSString stringWithFormat:@"Saving %@", [self.contact fullName]]];
        
        [DataServicesManager saveNewContact:self.contact
                      withCompletionHandler:^(Contact *contact) {
                          dispatch_sync(dispatch_get_main_queue(), ^{
                              [self hide];
                              [AlertHelper hideAlertView:alertView];
                          });
                      }];
    }
}

- (UIImage*)scaleAndCropImage:(UIImage*)image toSize:(CGSize)size
{
    double imageWidthHeightRatio = image.size.width / image.size.height;
    CGSize destinationSize = size;
    
    // Try scaling to equal widths.
    if (size.width / imageWidthHeightRatio >= size.height) {
        // This will work.
        destinationSize = CGSizeMake(size.width, size.width / imageWidthHeightRatio);
    }
    
    // Try scaling to equal heights.
    if (size.height * imageWidthHeightRatio >= size.width) {
        // This will work.
        destinationSize = CGSizeMake(size.height * imageWidthHeightRatio, size.height);
    }
    
    // Scale and crop the image.
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [image drawInRect:CGRectMake((size.width - destinationSize.width) / 2.0, (size.height - destinationSize.height) / 2.0, destinationSize.width, destinationSize.height)];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return croppedImage;
}

- (void)styleTextField:(UITextField*)textField
{
    textField.backgroundColor = [Theme bodyControlColor];
    textField.layer.cornerRadius = 5;
    textField.textColor = [Theme bodyControlTextColor];
    textField.layer.borderColor = [Theme bodyTextColor].CGColor;
    textField.layer.borderWidth = 0.5;
}

- (IBAction)textFieldValueChanged:(UITextField *)sender {
    if (sender == self.phoneAreaCodeTextField) {
        if ([sender.text length] == 3) {
            [self.phonePrefixTextField becomeFirstResponder];
        }
    } else if (sender == self.phonePrefixTextField) {
        if ([sender.text length] == 3) {
            [self.phoneLineNumberTextField becomeFirstResponder];
        }
    } else if (sender == self.phoneLineNumberTextField) {
        if ([sender.text length] == 4) {
            [self.emailTextField becomeFirstResponder];
        }
    }
  
}

- (void)hideCancelButton
{
    [self.navigationItem setLeftBarButtonItem:nil];
}
@end
