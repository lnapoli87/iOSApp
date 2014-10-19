#import "CreateViewController.h"

//#import "office365-base-sdk/OAuthentication.h"

@implementation CreateViewController

#pragma mark -
#pragma mark Default Methods
-(void)viewDidLoad{
    [super viewDidLoad];
}

#pragma mark -
#pragma mark Create Actions
- (IBAction)createProject:(id)sender {
    [self createProject];
}

-(void)createProject{
    [self.navigationController popViewControllerAnimated:TRUE ];
}

@end