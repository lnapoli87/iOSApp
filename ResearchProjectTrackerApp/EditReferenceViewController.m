#import "EditReferenceViewController.h"
#import "ProjectClient.h"
#import "office365-base-sdk/OAuthentication.h"
#import "ProjectDetailsViewController.h"

@interface EditReferenceViewController ()

@end

@implementation EditReferenceViewController

//ViewController actions
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.title = @"Edit Reference";
    self.navigationController.view.backgroundColor = nil;
    
    self.referenceUrlTxt.text = @"Url";
    
    self.referenceDescription.text = @"Description";
    self.referenceTitle.text = @"aReference";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Edit and Delete actions
- (IBAction)editReference:(id)sender {
    [self updateReference];
}
-(void)updateReference{
}
- (IBAction)deleteReference:(id)sender {
    [self deleteReference];
}
-(void)deleteReference{
}


@end
