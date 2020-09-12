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
#import "DCMessageAttatchment.h"
#import "TRMalleableFrameView.h"
#import "DCUser.h"

@interface RBChatViewController ()

@property (weak, nonatomic) IBOutlet UIBubbleTableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *chatToolbar;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property DCChannel *subscribedToChannel;

@end

@implementation RBChatViewController

-(void)viewDidLoad{
    self.chatTableView.showAvatars = YES;
    self.chatTableView.watchingInRealTime = YES;
    
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
    if(self.subscribedToChannel){
        @throw [[NSException alloc] initWithName:@"u fukd up!" reason:@"chat view was already subscribed to a channel!" userInfo:nil];
    }
    
    self.subscribedToChannel = channel;
    channel.isCurrentlyFocused = true;
    [channel retrieveNumberOfMessages:50];
    [channel markAsReadWithMessage:self.subscribedToChannel.messages.lastObject];
    [self scrollChatToBottom];
}

-(void)unsubscribeFromSubscribedChannelEvents {
    self.subscribedToChannel.isCurrentlyFocused = false;
    [self.subscribedToChannel markAsReadWithMessage:self.subscribedToChannel.messages.lastObject];
    [self.subscribedToChannel releaseMessages];
    self.subscribedToChannel = nil;
}

-(void) viewWillDisappear:(BOOL)animated {
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
    [self.subscribedToChannel sendMessage:self.messageField.text];
    self.messageField.text = @"";
}

#pragma mark uibubbletableview data source

-(NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView{
    return self.subscribedToChannel.messages.count;
}

-(NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row{
    
    NSBubbleData *bubbleData;
    
    id <RBMessageItem> item = [self.subscribedToChannel.messages objectAtIndex:row];
    
    if([item isKindOfClass:[DCMessage class]]) {
        DCMessage* message = (DCMessage*)item;
        NSString* bubbleText = [NSString stringWithFormat:@"%@:\n%@", message.author.username, message.content];
        bubbleData = [NSBubbleData dataWithText:bubbleText date:[NSDate date] type:!message.writtenByUser];
    }
    
    if([item isKindOfClass:[DCMessageAttatchment class]]) {
        DCMessageAttatchment* attachment = ((DCMessageAttatchment*)item);
        
        bubbleData = [NSBubbleData dataWithImage:attachment.image date:[NSDate date] type:!attachment.writtenByUser];
    }
    
    if(item.author.avatarImage) {
        bubbleData.avatar = item.author.avatarImage;
    }
    
    return bubbleData;
}

#pragma mark rbmessagedelegate

-(void)scrollChatToBottom{
    [self.chatTableView scrollBubbleViewToBottomAnimated:false];
}

@end
