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

@interface RBChatViewController ()

@property IBOutlet UIBubbleTableView *chatTableView;

@property NSMutableArray *messages;
@property NSOperationQueue* imageQueue;

@end

@implementation RBChatViewController

-(void)viewDidLoad{
    [RBClient.sharedInstance setMessageDelegate:self];
    self.chatTableView.showAvatars = YES;
    self.imageQueue = [NSOperationQueue new];
    self.imageQueue.maxConcurrentOperationCount = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    if(self.activeChannel){
        self.messages = (NSMutableArray*)[self.activeChannel getLastNumMessages:50];
    }
    [self.chatTableView reloadData];
    [self.chatTableView scrollBubbleViewToBottomAnimated:true];
}

-(void) viewWillDisappear:(BOOL)animated {
    [self.imageQueue cancelAllOperations];
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
        
        if(!attachment.image){
            ((DCMessageAttatchment*)item).image = [UIImage imageNamed:@"default"];
            
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
        item.author.avatarImage = [UIImage imageNamed:@"default"];
        
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
  
    NSLog(@"%p == %p", message.parentChannel, self.activeChannel);
    
    if(message.parentChannel == self.activeChannel){
        [self.messages addObject:message];
        [self.chatTableView reloadData];
        [self.chatTableView scrollBubbleViewToBottomAnimated:true];
    }
}

@end
