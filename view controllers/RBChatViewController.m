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

@interface RBChatViewController ()

@property IBOutlet UIBubbleTableView *chatTableView;

@property NSMutableArray *messages;

@end

@implementation RBChatViewController

-(void)viewDidLoad{
    [RBClient.sharedInstance setMessageDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated{
    if(self.activeChannel){
        self.messages = (NSMutableArray*)[self.activeChannel getLastNumMessages:50];
    }
    [self.chatTableView reloadData];
    [self.chatTableView scrollBubbleViewToBottomAnimated:true];
}

#pragma mark uibubbletableview data source

-(NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView{
    return self.messages.count;
}

-(NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row{
    
    NSString *content = ((DCMessage*)[self.messages objectAtIndex:row]).content;
    
    NSBubbleData *data = [[NSBubbleData alloc]initWithText:content date:[NSDate date] type:BubbleTypeSomeoneElse];
    
    return data;
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
