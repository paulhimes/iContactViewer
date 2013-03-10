//
//  EditContactViewController.m
//  iContactViewer
//
//  Created by Paul Himes on 3/8/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "EditContactViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface EditContactViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

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
    self.phoneAreaCodeTextField.text = [self.contact.phoneAreaCode stringValue];
    self.phonePrefixTextField.text = [self.contact.phonePrefix stringValue];
    self.phoneLineNumberTextField.text = [self.contact.phoneLineNumber stringValue];
    self.emailTextField.text = self.contact.email;
    self.twitterTextField.text = self.contact.twitterId;
    if (self.contact.photo) {
        [self.photoButton setImage:[UIImage imageWithData:self.contact.photo] forState:UIControlStateNormal];
    } else {
        [self.photoButton setImage:[UIImage imageNamed:@"firefly.jpg"] forState:UIControlStateNormal];
    }
    
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
    self.photoButton.layer.cornerRadius = 5;
    self.photoButton.clipsToBounds = YES;
    
    self.firstNameLabel.textColor = [Theme bodyTextHeaderColor];
    self.lastNameLabel.textColor = [Theme bodyTextHeaderColor];
    self.titleLabel.textColor = [Theme bodyTextHeaderColor];
    self.phoneLabel.textColor = [Theme bodyTextHeaderColor];
    self.emailLabel.textColor = [Theme bodyTextHeaderColor];
    self.twitterLabel.textColor = [Theme bodyTextHeaderColor];
    self.photoLabel.textColor = [Theme bodyTextHeaderColor];
    self.leftParenLabel.textColor = [Theme bodyTextHeaderColor];
    self.rightParenLabel.textColor = [Theme bodyTextHeaderColor];
    self.dashLabel.textColor = [Theme bodyTextHeaderColor];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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

- (IBAction)cancel:(id)sender {
    [self hide];
}

- (IBAction)save:(id)sender {
    [self updateContact];
    [self hide];
}

- (IBAction)changePhoto:(id)sender {
    NSLog(@"Change Photo");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)deleteContact:(id)sender {
    NSLog(@"Delete contact");
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    switch (buttonIndex) {
        case 0:
            // Camera
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:^{}];
            }
            break;
        case 1:
            // Library
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:^{}];
            break;
        case 2:
            // Cancel
            
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        [self.photoButton setImage:[self scaleAndCropImage:image toSize:CGSizeMake(320, 240)] forState:UIControlStateNormal];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];
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
    self.contact.phoneAreaCode = @([self.phoneAreaCodeTextField.text integerValue]);
    self.contact.phonePrefix = @([self.phonePrefixTextField.text integerValue]);
    self.contact.phoneLineNumber = @([self.phoneLineNumberTextField.text integerValue]);
    self.contact.email = self.emailTextField.text;
    self.contact.twitterId = self.twitterTextField.text;
    self.contact.photo = UIImageJPEGRepresentation([self.photoButton imageForState:UIControlStateNormal], 1);
    [self.contact.managedObjectContext save:NULL];
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
}

@end
