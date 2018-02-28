//
//  SettingsWebViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 25.01.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "SettingsWebViewController.h"
#import "SafeURLProtocol.h"
@interface SettingsWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SettingsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:self.loadURL];
    [request setValue:@"true" forHTTPHeaderField:kIgnoreSafeURLProtocolHTTPHeader];
    [self.webView loadRequest:request];
    
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIWebViewDelegate -

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
}

@end
