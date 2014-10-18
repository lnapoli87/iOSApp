#import "ViewController.h"
#import "ProjectTableViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()
            

@end

@implementation ViewController
            
ADAuthenticationContext* authContext;
NSString* authority;
NSString* redirectUriString;
NSString* resourceId;
NSString* clientId;
NSString* token;

//ViewController actions
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    
    //AzureAD account details
    authority = [NSString alloc];
    resourceId = [NSString alloc];
    clientId = [NSString alloc];
    redirectUriString = [NSString alloc];
    
    authority = @"https://login.windows.net/common";
    resourceId = @"https://foxintergen.sharepoint.com";
    clientId = @"13b04d26-95fc-4fb4-a67e-c850e07822a8";
    redirectUriString = @"http://android/complete";
    
    token = [NSString alloc];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)Login:(id)sender {
    [self performLogin:FALSE];
}

- (void) performLogin : (BOOL) clearCache{
    [self getToken:NO completionHandler:^(NSString *t, NSError *e) {
        if(e == nil)
        {
            token = t;
            
            ProjectTableViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"filesvc"];
            controller.token = t;
            
            [self.navigationController pushViewController:controller animated:YES];
        }
        else
        {
            NSString *errorMessage = [@"Login failed. Reason: " stringByAppendingString: e.description];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
            [alert show];
        }
    }];
}

-(void) getToken : (BOOL) clearCache completionHandler:(void (^) (NSString*, NSError *e))completionBlock;
{
    ADAuthenticationError *error;
    authContext = [ADAuthenticationContext authenticationContextWithAuthority:authority
                                                                        error:&error];
    
    NSURL *redirectUri = [NSURL URLWithString:redirectUriString];
    
    if(clearCache){
        [authContext.tokenCacheStore removeAllWithError: &error];
    }
    
    [authContext acquireTokenWithResource:resourceId
                                 clientId:clientId
                              redirectUri:redirectUri
                          completionBlock:^(ADAuthenticationResult *result) {
                              if (AD_SUCCEEDED != result.status){
                                  completionBlock(nil, result.error);
                              }
                              else{
                                  completionBlock(result.accessToken, nil);
                              }
                          }];
}

- (IBAction)Clear:(id)sender {
    ADAuthenticationError* error;
    id<ADTokenCacheStoring> cache = [ADAuthenticationSettings sharedInstance].defaultTokenCacheStore;
    NSArray* allItems = [cache allItemsWithError:&error];
    
    if (allItems.count > 0)
    {
        [cache removeAllWithError:&error];
    }
    
    if (error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *errorMessage = [@"Clear caché failed. Reason: " stringByAppendingString: error.errorDetails];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        });
        return;
    }
    
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* cookies = cookieStorage.cookies;
    if (cookies.count)
    {
        for(NSHTTPCookie* cookie in cookies)
        {
            [cookieStorage deleteCookie:cookie];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Cookies Cleared" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    });
}

-(void) showOkOnlyAlert : (NSString*) message : (NSString*) title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
}

@end