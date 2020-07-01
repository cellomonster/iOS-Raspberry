//
//  RBChatViewController.m
//  raspberry
//
//  Created by trevir on 10/18/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "RBChatViewController.h"
#import "UIBubbleTableView.h"
#import "NSBubbleData.h"
#import "DCMessage.h"
#import "RBClient.h"
#import "FTWCache.h"
#import "RBMessageItem.h"
#import "DCMessageAttatchment.h"
#import "TRMalleableFrameView.h"

@interface RBChatViewController ()

@property (weak, nonatomic) IBOutlet UIBubbleTableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *chatToolbar;
@property (weak, nonatomic) IBOutlet UITextField *messageField;

@property NSMutableArray *messages;
@property NSOperationQueue* imageQueue;

@end

@implementation RBChatViewController

-(void)viewDidLoad{
    [RBClient.sharedInstance setMessageDelegate:self];
    self.chatTableView.showAvatars = YES;
    self.chatTableView.watchingInRealTime = YES;
    self.imageQueue = [NSOperationQueue new];
    self.imageQueue.maxConcurrentOperationCount = 1;
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    if(self.activeChannel){
        self.messages = (NSMutableArray*)[self.activeChannel retrieveMessages:50];
    }
    [self.chatTableView reloadData];
    [self scrollChatToBottom];
}

-(void) viewWillDisappear:(BOOL)animated {
    [self.imageQueue cancelAllOperations];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	
	//thx to Pierre Legrain
	//http://pyl.io/2015/08/17/animating-in-sync-with-ios-keyboard/
	
	int keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
	float keyboardAnimationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
	int keyboardAnimationCurve = [[notification.userInfo objectForKey: UIKeyboardAnimationCurveUserInfoKey] integerValue];
	
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
	
	
	/*if(self.viewingPresentTime)
		[self.chatTableView setContentOffset:CGPointMake(0, self.chatTableView.contentSize.height - self.chatTableView.frame.size.height) animated:NO];*/
}

- (void)keyboardWillHide:(NSNotification *)notification {
	
	float keyboardAnimationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
	int keyboardAnimationCurve = [[notification.userInfo objectForKey: UIKeyboardAnimationCurveUserInfoKey] integerValue];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:keyboardAnimationDuration];
	[UIView setAnimationCurve:keyboardAnimationCurve];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[self.chatTableView setHeight:self.view.height - self.chatToolbar.height];
	[self.chatToolbar setY:self.view.height - self.chatToolbar.height];
	[UIView commitAnimations];
}

- (IBAction)sendButtonWasPressed:(id)sender {
    [self.activeChannel sendMessage:self.messageField.text];
    self.messageField.text = @"";
}

#pragma mark uibubbletableview data source

-(NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView{
    return self.messages.count;
}

-(NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row{
    
    NSBubbleData *bubbleData;
    
    id <RBMessageItem> item = [self.messages objectAtIndex:row];
    
    if([item isKindOfClass:[DCMessage class]]) {
        bubbleData = [NSBubbleData dataWithText:((DCMessage*)item).content date:[NSDate date] type:BubbleTypeSomeoneElse];
    }
    
    if([item isKindOfClass:[DCMessageAttatchment class]]) {
        
        DCMessageAttatchment* attachment = ((DCMessageAttatchment*)item);
        
        if(attachment.attachmentType == DCMessageAttatchmentTypeImage && !attachment.image){
            
            ((DCMessageAttatchment*)item).image = [UIImage new];
            
            NSBlockOperation* loadImageOperation = [NSBlockOperation blockOperationWithBlock: ^{
                [attachment loadImage];
                
                [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }];
            
            [self.imageQueue addOperation:loadImageOperation];
        }
        
        bubbleData = [NSBubbleData dataWithImage:attachment.image date:[NSDate date] type:BubbleTypeSomeoneElse];
    }
    
    if(item.author.avatarImage != nil) {
        bubbleData.avatar = item.author.avatarImage;
    } else {
        item.author.avatarImage = [UIImage new];
        
        NSBlockOperation* loadImageOperation = [NSBlockOperation blockOperationWithBlock: ^{
            [item.author loadAvatarImage];
            [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }];
            
        [self.imageQueue addOperation:loadImageOperation];
    }
    
    return bubbleData;
}

#pragma mark rbmessagedelegate

-(void)handleMessageCreate:(NSDictionary *)dict{
    DCMessage *message = [[DCMessage alloc] initFromDictionary:dict];
    
    if(message.parentChannel == self.activeChannel){
        [self.messages addObject:message];
        [self.chatTableView reloadData];
    }
}

-(void)scrollChatToBottom{
    [self.chatTableView scrollBubbleViewToBottomAnimated:false];
}

@end
