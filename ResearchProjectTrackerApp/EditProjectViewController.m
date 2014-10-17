#import "EditProjectViewController.h"
#import "ProjectClient.h"
#import "ProjectTableViewController.h"
//#import "office365-base-sdk/OAuthentication.h"

@implementation EditProjectViewController
#pragma mark -
#pragma mark Default Methods
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.ProjectNameTxt.text = @"aProject";
    self.navigationController.title = @"Edit Project";
}

#pragma mark -
#pragma mark Edit actions
- (IBAction)editProject:(id)sender {
    [self updateProject];
}
-(void)updateProject{
}

#pragma mark -
#pragma mark Delete Actions
-(IBAction)deleteProject:(id)sender {
    [self deleteProject];
}
-(void)deleteProject{
}

@end