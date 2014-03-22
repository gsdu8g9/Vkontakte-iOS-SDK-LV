//
//  ASAAppDelegate.m
//  Project
//
//  Created by AndrewShmig on 6/28/13.
//  Copyright (c) 2013 AndrewShmig. All rights reserved.
//

#import "ASAAppDelegate.h"
#import "ASAViewController.h"


static NSString *const kVKAppID = @"4249589";
static NSString *const kVKPermissionsArray = @"photos,friends,wall,audio,video,docs,notes,pages,status,groups,messages";


@implementation ASAAppDelegate

- (BOOL)          application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc]
                             initWithFrame:[[UIScreen mainScreen] bounds]];

    self.webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen]
                                                               bounds]];
    self.webView.hidden = NO;

    [[VKConnector sharedInstance] startWithAppID:kVKAppID
                                      permissons:[kVKPermissionsArray componentsSeparatedByString:@","]
                                         webView:self.webView
                                        delegate:self];

    // Override point for customization after application launch.
    self.viewController = [[ASAViewController alloc]
                                              initWithNibName:@"ASAViewController"
                                                       bundle:nil];
    [self.viewController.view addSubview:self.webView];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)VKConnector:(VKConnector *)connector
    willHideWebView:(UIWebView *)webView
{
    NSLog(@"%s", __FUNCTION__);
    self.webView.hidden = YES;
}

- (void)VKConnector:(VKConnector *)connector
    willShowWebView:(UIWebView *)webView
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)     VKConnector:(VKConnector *)connector
accessTokenRenewalFailed:(VKAccessToken *)accessToken
{
    NSLog(@"%s", __FUNCTION__);
}

- (void) VKConnector:(VKConnector *)connector
webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"URL: %@", [webView.request.URL absoluteString]);
}

- (void)VKConnector:(VKConnector *)connector
webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)        VKConnector:(VKConnector *)connector
accessTokenRenewalSucceeded:(VKAccessToken *)accessToken
{
    NSLog(@"%s", __FUNCTION__);

    NSLog(@"Access token: %@", accessToken);

    VKRequestManager *rm = [[VKRequestManager alloc]
                                              initWithDelegate:self
                                                          user:[VKUser currentUser]];

    [rm info];
}

- (void)   VKConnector:(VKConnector *)connector
connectionErrorOccured:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"CONNECTION error: %@", error);
}

- (void)VKRequest:(VKRequest *)request
         response:(id)response
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"request: %@", request);
    NSLog(@"response: %@", response);
}

- (void)   VKRequest:(VKRequest *)request
responseErrorOccured:(id)error
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"error: %@", error);
}

- (void)    VKRequest:(VKRequest *)request
validationRedirectURI:(NSString *)redirectURI
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"redirectURI: %@", redirectURI);

    self.webView.hidden = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:redirectURI]]];
}

- (void)VKRequest:(VKRequest *)request
       captchaSid:(NSString *)captchaSid
     captchaImage:(NSString *)captchaImage
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"captchaSid: %@", captchaSid);
    NSLog(@"captchaImage: %@", captchaImage);

    [request appendCaptchaSid:@"439824420775"
                   captchaKey:@"spnuod"];

    [request start];
}

- (void)  VKRequest:(VKRequest *)request
parsingErrorOccured:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", error);
}

- (void)  VKConnector:(VKConnector *)connector
applicationWasDeleted:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"Error: %@", error);
}

@end
