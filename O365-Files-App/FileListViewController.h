//
//  FileListViewController.h
//  O365-Files-App
//
//  Created by Lucas Damian Napoli on 24/10/14.
//  Copyright (c) 2014 MS Open Tech. All rights reserved.
//

#import "ViewController.h"

@interface FileListViewController : ViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSString *token;
@property NSMutableArray *files;
@end
