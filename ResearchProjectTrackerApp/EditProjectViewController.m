#import "EditProjectViewController.h"

#import "office365-base-sdk/OAuthentication.h"
#import "ProjectClient.h"
#import "ProjectTableViewController.h"

@implementation EditProjectViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.ProjectNameTxt.text = @"aProject";
    self.navigationController.title = @"Edit Project";
}


#pragma mark Edit and Delete actions
- (IBAction)editProject:(id)sender {
    [self updateProject];
}
-(void)updateProject{
}
-(IBAction)deleteProject:(id)sender {
    [self deleteProject];
}
-(void)deleteProject{
}

@end