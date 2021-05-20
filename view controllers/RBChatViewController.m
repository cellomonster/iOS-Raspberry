//
//  RBChatViewController.m
//  raspberry
//
//  Created by trevir on 10/18/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "RBChatViewController.h"
#import "RBNotificationEvent.h"
#import "UIBubbleTableView.h"
#import "NSBubbleData.h"
#import "DCMessage.h"
#import "RBClient.h"
#import "FTWCache.h"
#import "RBMessageItem.h"
#import "DCMessageAttachment.h"
#import "TRMalleableFrameView.h"
#import "DCUser.h"
#import "RBContactViewController.h"

@interface RBChatViewController ()

@property (weak, nonatomic) IBOutlet UIBubbleTableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *chatToolbar;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property DCChannel *subscribedChannel;
@property UIPopoverController *imageUploadSelectionPopover;

@property UIImagePickerController *imagePickerController;
@property id <RBMessageItem> selectedMessageItem;

@end

@implementation RBChatViewController

-(void)viewDidLoad{
    self.chatTableView.showAvatars = YES;
    self.chatTableView.watchingInRealTime = YES;
    
    self.imagePickerController = UIImagePickerController.new;
	self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.chatTableView
                                             selector:@selector(reloadData)
                                                 name:RBNotificationEventFocusedChannelUpdated
                                               object:nil];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        self.navigationItem.hidesBackButton = YES;
}

-(void)subscribeToChannelEvents:(DCChannel*)channel loadNumberOfMessages:(int)numMessages{
    if(self.subscribedChannel){
        @throw [[NSException alloc] initWithName:@"u fukd up!" reason:@"chat view was already subscribed to a channel!" userInfo:nil];
    }
    
    self.subscribedChannel = channel;
    channel.isCurrentlyFocused = true;
    [channel retrieveNumberOfMessages:50];
    [channel markAsReadWithMessage:[self.subscribedChannel getLastAddedMessage]];
    [self scrollChatToBottom];
}

-(void)unsubscribeFromSubscribedChannelEvents {
    self.subscribedChannel.isCurrentlyFocused = false;
    [self.subscribedChannel markAsReadWithMessage:[self.subscribedChannel getLastAddedMessage]];
    [self.subscribedChannel releaseMessages];
    self.subscribedChannel = nil;
}

- (void) willMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    
    if (parent == nil && self.parentViewController == nil) return;
    if (parent != nil && self.parentViewController == parent) return;
    
    [self unsubscribeFromSubscribedChannelEvents];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	
	//thx to Pierre Legrain
	//http://pyl.io/2015/08/17/animating-in-sync-with-ios-keyboard/
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    int keyboardHeight;
    if(interfaceOrientation > 2){
        keyboardHeight = keyboardRect.size.width;
    }else{
        keyboardHeight = keyboardRect.size.height;
    }
    
	float keyboardAnimationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
	int keyboardAnimationCurve = [[notification.userInfo objectForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:keyboardAnimationDuration];
	[UIView setAnimationCurve:keyboardAnimationCurve];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[self.chatTableView setHeight:self.view.height - keyboardHeight - self.chatToolbar.height];
	[self.chatToolbar setY:self.view.height - keyboardHeight - self.chatToolbar.height];
	[UIView commitAnimations];
    
    if(self.chatTableView.watchingInRealTime){
        [self.chatTableView scrollBubbleViewToBottomAnimated:true];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
	
	float keyboardAnimationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
	int keyboardAnimationCurve = [[notification.userInfo objectForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:keyboardAnimationDuration];
	[UIView setAnimationCurve:keyboardAnimationCurve];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[self.chatTableView setHeight:self.view.height - self.chatToolbar.height];
	[self.chatToolbar setY:self.view.height - self.chatToolbar.height];
	[UIView commitAnimations];
}

- (IBAction)sendButtonWasPressed:(id)sender {
    [self.subscribedChannel sendMessage:self.messageField.text];
    self.messageField.text = @"";
}

#pragma mark uibubbletableview data source

-(NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView{
    return self.subscribedChannel.messagesAndAttachments.count;
}

-(NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row{
    
    NSBubbleData *bubbleData;
    
    id <RBMessageItem> item = [self.subscribedChannel.messagesAndAttachments objectAtIndex:row];
    
    if([item isKindOfClass:[DCMessage class]]) {
        DCMessage* message = (DCMessage*)item;
        NSString* bubbleText = [NSString stringWithFormat:@"%@:\n%@", message.author.username, message.content];
        bubbleData = [NSBubbleData dataWithText:bubbleText date:message.timestamp type:!message.writtenByUser];
    }
    
    if([item isKindOfClass:[DCMessageAttachment class]]) {
        DCMessageAttachment* attachment = (DCMessageAttachment*)item;
        if(attachment.attachmentType == DCMessageAttachmentTypeImage)
            bubbleData = [NSBubbleData dataWithImage:attachment.image date:attachment.timestamp type:!attachment.writtenByUser];
        else
            bubbleData = [NSBubbleData dataWithText:@"<UNSUPPORTED ATTACHMENT>" date:attachment.timestamp type:!attachment.writtenByUser];
    }
    
    if(item.author.avatarImage) {
        bubbleData.avatar = item.author.avatarImage;
    }
    
    bubbleData.index = row;
    
    return bubbleData;
}

- (IBAction)imageUploadButtonWasPressed:(UIBarButtonItem *)sender {
    [self.messageField resignFirstResponder];
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
        [popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.imageUploadSelectionPopover = popover;
    } else {
        [self presentModalViewController:self.imagePickerController animated:YES];
    }
}

#pragma mark uibubble	tableviewdelegate

- (void)bubbleTableView:(UIBubbleTableView *)bubbleTableView didSelectRow:(int) row{
    self.selectedMessageItem = [self.subscribedChannel.messagesAndAttachments objectAtIndex:row];
    [self performSegueWithIdentifier:@"chat to contact" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController class] == [RBContactViewController class]){
        [((RBContactViewController*)segue.destinationViewController) setSelectedUser:self.selectedMessageItem.author];
    }
}

#pragma mark rbmessagedelegate

-(void)scrollChatToBottom{
    [self.chatTableView scrollBubbleViewToBottomAnimated:false];
}

#pragma mark uiimagepickercontrollerdelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	[picker dismissModalViewControllerAnimated:YES];
	
	UIImage* originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
	
	if(originalImage==nil)
		originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	
	if(originalImage==nil)
		originalImage = [info objectForKey:UIImagePickerControllerCropRect];
	
	[self.subscribedChannel sendImage:originalImage];
}


@end
