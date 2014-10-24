//
//  ViewController.m
//  AD-Auth-iOS-App
//
//  Created by Lucas Damian Napoli on 10/10/14.
//  Copyright (c) 2014 MS Open Tech. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FileListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

ADAuthenticationContext* authContext;
NSString* authority;
NSString* redirectUriString;
NSString* resourceId;
NSString* clientId;
NSString* token;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    authority = [NSString alloc];
    resourceId = [NSString alloc];
    clientId = [NSString alloc];
    redirectUriString = [NSString alloc];
    authority = @"https://login.windows.net/common";
    redirectUriString = @"http://android/complete";
    resourceId = @"https://foxintergen.sharepoint.com";
    clientId = @"13b04d26-95fc-4fb4-a67e-c850e07822a8";
    token = [NSString alloc];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) getToken : (BOOL) clearCache completionHandler:(void (^) (NSString*))completionBlock;
{
    ADAuthenticationError *error;
    authContext = [ADAuthenticationContext authenticationContextWithAuthority:authority
                                                                        error:&error];
    
    NSURL *redirectUri = [NSURL URLWithString:redirectUriString];
    
    if(clearCache){
        [authContext.tokenCacheStore removeAllWithError:nil];
    }
    
    [authContext acquireTokenWithResource:resourceId
                                 clientId:clientId
                              redirectUri:redirectUri
                          completionBlock:^(ADAuthenticationResult *result) {
                              if (AD_SUCCEEDED != result.status){
                                  // display error on the screen
                                  [self showError:result.error.errorDetails];
                              }
                              else{
                                  completionBlock(result.accessToken);
                              }
                          }];
}

-(void) showError:(NSString *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *errorMessage = [@"Login failed. Reason: " stringByAppendingString: error];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
        [alert show];
    });
}

- (IBAction)loginAction:(id)sender {
    [self getToken:FALSE completionHandler:^(NSString *t){
        dispatch_async(dispatch_get_main_queue(), ^{
            token = t;
            
            FileListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"fileList"];
            controller.token = t;
            
            [self.navigationController pushViewController:controller animated:YES];
        });
    }];
}
- (IBAction)clearAction:(id)sender {
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



@end
