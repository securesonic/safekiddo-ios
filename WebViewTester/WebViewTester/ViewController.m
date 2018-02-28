//
//  ViewController.m
//  WebViewTester
//
//  Created by Jakub Dlugosz on 27.01.2015.
//  Copyright (c) 2015 Jakub Dlugosz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest* url = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://interia.pl"]];
    
    [self.webView loadRequest:url];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Start load: %@ %@",request,request.mainDocumentURL);
    return  YES;
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Loaded: %@ %@",webView.request,webView.request.mainDocumentURL);
}

@end
