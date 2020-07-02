//
//  RBGuildMenuViewController.m
//  raspberry
//
//  Created by trev on 8/13/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "RBGuildMenuViewController.h"
#import "RBClient.h"
#import "DCChannel.h"
#import "RBChatViewController.h"
#import "RBGuildStore.h"
#import "DCGuild.h"

@interface RBGuildMenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *guildTableView;
@property (weak, nonatomic) IBOutlet UITableView *channelTableView;
@property DCGuild *focusedGuild;
@property DCChannel *selectedChannel;

@end

@implementation RBGuildMenuViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(tableView == self.guildTableView){
		self.focusedGuild = [RBClient.sharedInstance.guildStore guildAtIndex:(int)indexPath.row];
		[self.channelTableView reloadData];
	}
    
    if(tableView == self.channelTableView){
        self.selectedChannel = (DCChannel*)[self.focusedGuild.sortedChannels objectAtIndex:indexPath.row];
        
        [self performSegueWithIdentifier:@"guilds to chat" sender:self];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if(tableView == self.guildTableView)
		return [RBClient.sharedInstance.guildStore count];
	
    if(tableView == self.channelTableView)
        return self.focusedGuild.channels.count;
    
    return 0;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController class] == [RBChatViewController class]){
        ((RBChatViewController*)segue.destinationViewController).activeChannel = self.selectedChannel;
        ((RBChatViewController*)segue.destinationViewController).title = self.selectedChannel.name;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell;
	
	if(tableView == self.guildTableView){
		cell = [tableView dequeueReusableCellWithIdentifier:@"guild" forIndexPath:indexPath];
		cell.textLabel.text = [RBClient.sharedInstance.guildStore guildAtIndex:(int)indexPath.row].name;
	}
	
	if(tableView == self.channelTableView){
		cell = [tableView dequeueReusableCellWithIdentifier:@"channel" forIndexPath:indexPath];
		cell.textLabel.text = ((DCChannel*)[self.focusedGuild.sortedChannels objectAtIndex:indexPath.row]).name;
	}
  
	return cell;
}

@end
