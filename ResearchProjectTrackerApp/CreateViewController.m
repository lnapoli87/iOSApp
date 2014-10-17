#import "CreateViewController.h"

#import "office365-base-sdk/OAuthentication.h"
#import "ProjectClient.h"

@implementation CreateViewController

-(void)viewDidLoad{
    [super viewDidLoad];
}

- (IBAction)createProject:(id)sender {
    [self createProject];
}

-(void)createProject{
    [self.navigationController popViewControllerAnimated:TRUE ];
}

@end