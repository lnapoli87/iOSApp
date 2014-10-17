#import "ProjectDetailsViewController.h"
#import "office365-base-sdk/OAuthentication.h"
#import "ProjectClient.h"
#import "ReferencesTableViewCell.h"
#import "ReferenceDetailsViewController.h"
#import "CreateReferenceViewController.h"
#import "EditProjectViewController.h"

@implementation ProjectDetailsViewController

//ViewController actions
#pragma mark -
#pragma mark Default Methods
-(void)viewDidLoad{
    self.projectName.text = @"aProject";
    self.navigationItem.title = @"aProject";
    self.navigationItem.rightBarButtonItem.title = @"Done";
    self.selectedReference = false;
    self.projectNameField.hidden = true;
    
    [self loadData];
}



#pragma mark -
#pragma mark Loading References
-(void)loadData{
}

-(void)getReferences:(UIActivityIndicatorView *) spinner{
}

-(void)createReferencesList:(UIActivityIndicatorView *) spinner{
}


#pragma mark -
#pragma mark Forward Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"createReference"]){
        CreateReferenceViewController *controller = (CreateReferenceViewController *)segue.destinationViewController;
        
        controller.token = self.token;
        //controller.project = self.project;        set the current project
        
    }else if([segue.identifier isEqualToString:@"referenceDetail"]){
        ReferenceDetailsViewController *controller = (ReferenceDetailsViewController *)segue.destinationViewController;
        
        controller.token = self.token;
        //controller.selectedReference = self.selectedReference;        set the current reference
        
    }else if([segue.identifier isEqualToString:@"editProject"]){
        EditProjectViewController *controller = (EditProjectViewController *)segue.destinationViewController;

        controller.token = self.token;
        //controller.project = self.project;        set the current project
        
    }
    self.selectedReference = false;
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return ([identifier isEqualToString:@"referenceDetail"] && self.selectedReference) || [identifier isEqualToString:@"createReference"] || [identifier isEqualToString:@"editProject"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}



#pragma mark -
#pragma mark Table actions
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = @"referencesListCell";
    ReferencesTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier: identifier ];
    
    cell.titleField.text = @"Description";
    cell.urlField.text = @"Url";
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"referenceDetail" sender:self];
}

@end