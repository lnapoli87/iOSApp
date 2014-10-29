//
//  FileListViewController.m
//  O365-Files-App
//
//  Created by Lucas Damian Napoli on 24/10/14.
//  Copyright (c) 2014 MS Open Tech. All rights reserved.
//

#import "FolderListViewController.h"
#import "FileListCellTableViewCell.h"
#import "FolderContentViewController.h"

@interface FolderListViewController ()

@end

@implementation FolderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.tintColor = [UIColor colorWithRed:13.0/255.0 green:92.0/255.0 blue:173.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:13.0/255.0 green:92.0/255.0 blue:173.0/255.0 alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
 
    
    
    self.navigationController.title = @"File List";
}

- (void) viewWillAppear:(BOOL)animated{
    self.currentFolder = nil;
    [self getFolders];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.view.backgroundColor = [UIColor clearColor];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* identifier = @"fileListCell";
    FileListCellTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier: identifier ];
    
    MSOutlookFolder *cellFolder = (MSOutlookFolder*)[self.folders objectAtIndex: indexPath.row];
    cell.title.text = cellFolder.DisplayName;
    
    return cell;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    FolderContentViewController *controller = (FolderContentViewController *)segue.destinationViewController;
    controller.currentFolder = self.currentFolder;
    controller.token = self.token;
    controller.client = self.client;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentFolder= [self.folders objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"detail" sender:self];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return ([identifier isEqualToString:@"detail"] && self.currentFolder) || [identifier isEqualToString:@"newProject"];
}

-(void)getFolders{
    
    NSURLSessionTask* task = [[[self.client getMe] getFolders] execute:^(NSArray<MSOutlookFolder> *folders, NSError *error) {
        if(error == nil){
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               self.folders = folders;
                               [self.tableView reloadData];
                           });
        }
    }];
    
    [task resume];
}

@end
