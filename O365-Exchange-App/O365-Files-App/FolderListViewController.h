//
//  FileListViewController.h
//  O365-Files-App
//
//  Created by Lucas Damian Napoli on 24/10/14.
//  Copyright (c) 2014 MS Open Tech. All rights reserved.
//

#import "ViewController.h"
#import <office365_exchange_sdk/office365_exchange_sdk.h>

@interface FolderListViewController : ViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSString *token;
@property (weak, nonatomic) MSOutlookClient *client;
@property (weak, nonatomic) NSArray<MSOutlookFolder> *folders;
@property (weak, nonatomic) MSOutlookFolder* currentFolder;
@end
