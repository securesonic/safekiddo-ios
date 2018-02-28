//
//  WebBrowserViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 17.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "WebBrowserViewController.h"
#import "NetworkManager+Authentication.h"
#import "NetworkManager+WebPages.h"
#import "NetworkManager+ParentalControl.h"
#import "NetworkManager+Children.h"
#import "Utilities.h"
#import "SafeURLProtocol.h"
#import "WebViewHandler.h"
#import "NSURL+Format.h"
#import "HistoryController.h"
#import "SuggestionViewController.h"
#import "HistoryController.h"
#import "CoreData.h"
#import "SegmentViewController.h"
#import "BookmarkWebpageViewController.h"
#import "BookmarkFolder.h"
#import "SettingsViewController.h"
#import "SettingsSection.h"
#import "SettingsEnum.h"
#import "SettingsRow.h"
#import "BookmarkViewController.h"
#import "HistoryViewController.h"
#import "Settings+SafeSearch.h"
#import "NetworkManager+Hearbeat.h"
#import "Constants.h"
#import "WebBrowserSwipeHistoryHandler.h"
#import "Child.h"
#import "Constants.h"
#import "CoreDataManager+SafeKiddo.h"
#import "DelayedTextField.h"

@interface WebBrowserViewController()<UIWebViewDelegate,WebViewHandlerDelegate,UITextFieldDelegate,SuggestionViewControllerDelegate,BookmarkWebpageViewControllerDelegate, HistoryViewControllerDelegate, BookmarkViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet DelayedTextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;


@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong,nonatomic) WebViewHandler* webViewHandler;

@property (strong,nonatomic) SuggestionViewController* suggestionViewController;
@property (strong,nonatomic) NSArray* suggestionViewAutloayouts;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

-(void)presentSuggestionViewController;
-(void)dismissSuggestionsViewController;
-(void)setSuggestionsViewControllerVisibllityWithSuggestions:(NSArray*)suggestions;

-(void)openSettings;
-(void)settingsWithParentMode:(BOOL)openParentMode;

@property(strong,nonatomic)NSTimer* heartbeatTimer;
-(void)heartbeatTimerAction:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewLeadingSpaceConstraint;
@property(strong,nonatomic) WebBrowserSwipeHistoryHandler* swipeHistoryHandler;

@end

@implementation WebBrowserViewController

+(void)initialize
{
    [super initialize];
}

-(void)viewDidLoad
{
    UIImage* backImage = [[UIImage imageNamed:@"icon_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.backButton setImage:backImage forState:UIControlStateNormal];
    [self.backButton setTitle:@"" forState:UIControlStateNormal];
    self.backButton.tintColor = [UIColor whiteColor];
    
    UIImage* forwardImage = [[UIImage imageNamed:@"icon_forward"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.forwardButton setImage:forwardImage forState:UIControlStateNormal];
    [self.forwardButton setTitle:@"" forState:UIControlStateNormal];
    self.forwardButton.tintColor = [UIColor whiteColor];

    UIImage* cancelIcon = [[UIImage imageNamed:@"icon_cancel"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.refreshButton setImage:cancelIcon forState:UIControlStateNormal];
    [self.refreshButton setTitle:@"" forState:UIControlStateNormal];
    self.refreshButton.tintColor = [UIColor whiteColor];
    
    
    [super viewDidLoad];
    
    self.progressView.alpha=0.f;
    self.webViewHandler = [[WebViewHandler alloc]initWithWebView:self.webView delegate:self];
    self.urlTextField.placeholder = NSLocalizedString(@"BROWSER_ADR_TXT", @"");

    self.urlTextField.externalDelegate = self;
    
    if(self.initialURL)
    {
       
        [self.webViewHandler openURL:self.initialURL];
    }
    else
    {
        [NetworkManager homePageWithSuccessBlock:^(NSString *html)
         {
             [self.webView loadHTMLString:html baseURL:nil];
         } failureBlock:^(NSError *error) {
#warning TODO: co mam zrobić, gdy strona z błędem się nie załaduje?
         }];
    }
    
    self.swipeHistoryHandler = [[WebBrowserSwipeHistoryHandler alloc]initWithWebView:self.webView leadingLayoutConstraint:self.webViewLeadingSpaceConstraint];
    
}

//ios 7
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(IS_IPHONE)
    {
        if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        {
             self.topConstraint.constant = -20.f;
        }
        else
        {
             self.topConstraint.constant = 0.f;
        }
    }
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if(IS_IPHONE)
    {
        if(size.width > size.height)
        {
            self.topConstraint.constant = -20.f;
        }
        else
        {
            self.topConstraint.constant = 0;
        }
    }
}

-(void)dealloc
{
    [self.heartbeatTimer invalidate];
}
#pragma mark - WebViewHandlerDelegate -

-(void)webViewHandlerDidStartProgress:(WebViewHandler *)handler
{
    
    [self.refreshButton  setImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
    
    
    [self.progressView setProgress:0];
    [UIView animateWithDuration:0.3 animations:^{
        self.progressView.alpha = 1.f;
    }];
}

-(void)webViewHandlerDidEndProgress:(WebViewHandler *)handler
{
    [self.refreshButton  setImage:[UIImage imageNamed:@"icon-refresh"] forState:UIControlStateNormal];
    [self.progressView setProgress:1 animated:YES];
    [UIView animateWithDuration:0.3 delay:0.3 options:0 animations:^{
        self.progressView.alpha = 0.f;
    } completion:nil];
    
    
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
}

-(void)webViewHandler:(WebViewHandler *)handler loadedURL:(NSURL*)url title:(NSString*)title
{
    if( [[url absoluteString] rangeOfString:@"applewebdata://"].location != NSNotFound)
    {
        NSString* pageTitle = title;
        self.urlTextField.text = pageTitle;
        
        // ignore url's that should not be shown, or stored...
    }
    else
    {
        NSString* pageTitle = title;
        self.urlTextField.text = [url displayString];
        [[HistoryController sharedHistoryController] webViewDidFinishLoadURL:url inWebView:handler.webView withTitle:pageTitle];
    }
    [self.swipeHistoryHandler webviewLoaded];
}

-(void)webViewHandler:(WebViewHandler *)handler progressChanged:(CGFloat)progress
{
    [self.progressView setProgress:progress animated:YES];
}

-(void)webViewHandler:(WebViewHandler *)handler userRequestedURL:(NSURL *)url
{
    self.urlTextField.text = [url displayString];
    
    [[HistoryController sharedHistoryController] userNavigatedToURL:url];
    [self.swipeHistoryHandler webviewWillNavigateNew];
}

#pragma mark - UITextFieldDelegate -

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSURL* url = [NSURL URLFromDisplayString:textField.text];
    if(url)
    {
        [self.webViewHandler openURL:url];
    }
    else
    {
        NSString* searchFormat = SearchFormatFromSettingsEngine([Settings sharedSettings].searchEngine);

        NSString* urlSearchString = [NSString stringWithFormat:searchFormat,[textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.webViewHandler openURL:[NSURL URLWithString:urlSearchString]];
    }
    [textField resignFirstResponder];
    [self dismissSuggestionsViewController];
    return NO;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* textAfterChange = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray* suggetsions =  [[HistoryController sharedHistoryController] arrayOfSuggestedWebPagesForString:textAfterChange];
    [self setSuggestionsViewControllerVisibllityWithSuggestions:suggetsions];
    
    [self.suggestionViewController updateSuggestions:suggetsions];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self presentSuggestionViewController];
    
    NSArray* suggetsions =  [[HistoryController sharedHistoryController] arrayOfSuggestedWebPagesForString:textField.text];
    [self setSuggestionsViewControllerVisibllityWithSuggestions:suggetsions];
    
    [self.suggestionViewController updateSuggestions:suggetsions];
    
    
}

#pragma mark - IBActions -
- (IBAction)backAction:(id)sender
{
    if([self.webView canGoBack])
    {
        [self.swipeHistoryHandler webviewWillNavigateBack];
        [self.webView goBack];
    }
}
- (IBAction)forwardAction:(id)sender
{
    if([self.webView canGoForward])
    {
        [self.swipeHistoryHandler webviewWillNavigateForward];
        [self.webView goForward];
    }
}
- (IBAction)refreshAction:(id)sender
{
    if(self.webView.isLoading)
    {
        [self.webView stopLoading];
    }
    else
    {
        [self.webView reload];
    }
}

- (IBAction)shareAction:(id)sender
{
    
    UIActivityViewController* activityViewController = [[UIActivityViewController alloc]initWithActivityItems:@[self.webViewHandler.currentTitle,self.webViewHandler.currentURL] applicationActivities:nil];
    
    if(IS_IPAD)
    {
        if([activityViewController respondsToSelector:@selector(popoverPresentationController)])
        {
            activityViewController.popoverPresentationController.barButtonItem = sender;
        }
    }
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}
- (IBAction)bookmarkAction:(id)sender
{

    BookmarkViewController* vc =[self.storyboard instantiateViewControllerWithIdentifier:[BookmarkViewController description]];
    id rootFolder = [[CoreDataManager sharedInstance]rootFolder];
    vc.folder = rootFolder;
    vc.delegate = self;
    
     UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:vc];
    
    
    if(IS_IPAD)
    {
        [navCon setModalPresentationStyle:UIModalPresentationFormSheet];
        [navCon setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    }
    
    [self presentViewController:navCon animated:YES completion:nil];
}

- (IBAction)historyAction:(id)sender
{

    HistoryViewController* historyViewController = [self.storyboard instantiateViewControllerWithIdentifier:[HistoryViewController description]];
    
    UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:historyViewController];
    historyViewController.delegate = self;
    if(IS_IPAD)
    {
        [navCon setModalPresentationStyle:UIModalPresentationFormSheet];
        [navCon setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    }
    
    [self presentViewController:navCon animated:YES completion:nil];
}

- (IBAction)addBookmarkAction:(id)sender
{
    
    WebpageBookmark* webpage = [[CoreDataManager sharedInstance] createEntity:[WebpageBookmark description]];

    webpage.title = [self.webViewHandler currentTitle];
    webpage.url = [self.webViewHandler currentURL].absoluteString;
    
    id rootFolder = [[CoreDataManager sharedInstance]rootFolder];
    
    webpage.folder = rootFolder;
    [((BookmarkFolder*)rootFolder) addWebpagesObject:webpage];
    
    [[CoreDataManager sharedInstance] saveContext];
    
    
    
    
    BookmarkWebpageViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookmarkWebpageViewController"];
    vc.delegate = self;
    vc.webPage = webpage;
    vc.type = BookmarkWebpageViewControllerAlone;
    
    
    
    
    UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:vc];
    
    if(IS_IPAD)
    {
        [navCon setModalPresentationStyle:UIModalPresentationFormSheet];
        [navCon setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    }
    
    


    
    [self presentViewController:navCon animated:YES completion:nil];
}

- (IBAction)tabAction:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)settingsAction:(id)sender
{
    //SettingsViewController
    [self settingsWithParentMode:NO];
}

#pragma mark - Public - 

-(NSString*)currentTitle
{
    return self.webViewHandler.currentTitle;
}

-(NSURL*)currentURL
{
    return self.webViewHandler.currentURL;
}

-(void)openSettings
{
    if(self.presentedViewController)
    {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
            [self settingsWithParentMode:YES];
        }];
    }
    else
    {
            [self settingsWithParentMode:YES];
    }
}

#pragma mark - Private -

-(void)heartbeatTimerAction:(id)sender
{
    [self.heartbeatTimer invalidate];
    
    NSLog(@"%@",@"Heartbeat start");
    [NetworkManager heartbeatWithDeviceUUID:[Utilities uuid]
                               successBlock:^(HeartbeatResponse *response)
     {
             NSLog(@"%@",@"Heartbeat finished");
         if(response.success.boolValue)
         {
             [Utilities storeHeartBeat:[NSDate dateWithTimeIntervalSinceNow:response.heartbeatInterval.intValue]];
             self.heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:response.heartbeatInterval.intValue target:self selector:@selector(heartbeatTimerAction:) userInfo:nil repeats:NO];
         }
         else
         {
             if(response.blockAccess.boolValue)
             {
                 [Utilities storePassword:nil];
                 [[NSNotificationCenter defaultCenter]postNotificationName:kRestartApplicationNotification object:nil];
             }
         }
         
         
     } failureBlock:^(NSError *error)
     {
         
     }];
}

-(void)settingsWithParentMode:(BOOL)openParentMode
{
    SettingsViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    
    vc.navigationItem.title = NSLocalizedString(@"SETTINGS_TITLE", @"");
    
    vc.dataSource = @[
                      [SettingsSection sectionWithTitle:NSLocalizedString(@"SETTINGS_SECTION_CLEAR", @"") andRows:@[
                                                                                                                    [SettingsRow rowWithType:SettingsCookieClear],
                                                                                                                    [SettingsRow rowWithType:SettingsClearBrowserHistory],
                                                                                                                    [SettingsRow rowWithType:SettingsClearCache]
                                                                                                                    ]],
                      [SettingsSection sectionWithTitle:NSLocalizedString(@"SETTINGS_SECTION_OTHER", @"") andRows:@[
                                                                                                                    [SettingsRow rowWithType:SettingsBrowserIdentity],
                                                                                                                    [SettingsRow rowWithType:SettingsSearchEngine]
                                                                                                                    ]],
                      [SettingsSection sectionWithTitle:NSLocalizedString(@"SETTINGS_SECTION_SAFEKIDDO", @"") andRows:@[
                                                                                                                        [SettingsRow rowWithType:SettingsBrowserParentMode]
                                                                                                                        ]]
                      ];
    
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:vc];
    
    if(IS_IPAD)
    {
        [navigationController setModalPresentationStyle:UIModalPresentationFormSheet];
        [navigationController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    }
    [self presentViewController:navigationController animated:YES completion:^{
        if(openParentMode)
        {
            [vc openOptionAtIndex:[NSIndexPath indexPathForRow:0 inSection:2]];
        }
    }];

}

#pragma mark SuggestionViewController

-(void)presentSuggestionViewController
{
    if(!self.suggestionViewController)
    {
        self.suggestionViewController = [self.storyboard instantiateViewControllerWithIdentifier:[SuggestionViewController description]];
        self.suggestionViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        self.suggestionViewController.delegate = self;
    }
    
    if(![self.view.subviews containsObject:self.suggestionViewController.view])
    {
        [self.view addSubview:self.suggestionViewController.view];
        self.suggestionViewController.view.alpha =0.f;
        
        NSDictionary* viewsDictionary = @{@"suggestionView":self.suggestionViewController.view,
                                          @"navigationView":self.navigationView
                                          };
        
        NSArray* constraints_H      =[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"|-0-[suggestionView]-0-|"
                                      options:0
                                      metrics:nil
                                      views:viewsDictionary];
        
        
        NSArray* constraints_V      =[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:[navigationView]-0-[suggestionView]-0-|"
                                      options:NSLayoutFormatAlignAllCenterX
                                      metrics:nil
                                      views:viewsDictionary];
        
        self.suggestionViewAutloayouts = [constraints_H arrayByAddingObjectsFromArray:constraints_V];
        
        [self.view addConstraints:self.suggestionViewAutloayouts];
    }
}

-(void)dismissSuggestionsViewController
{
    [self.view removeConstraints:self.suggestionViewAutloayouts];
    self.suggestionViewAutloayouts = nil;
    [self.suggestionViewController.view removeFromSuperview];
}

-(void)setSuggestionsViewControllerVisibllityWithSuggestions:(NSArray*)suggestions
{
    [UIView animateWithDuration:0.1 animations:^{
        
        if(suggestions.count>0)
        {
            self.suggestionViewController.view.alpha = 1.f;
        }
        else
        {
            self.suggestionViewController.view.alpha = 0.f;
        }
    }];
}

#pragma mark SuggestionViewControllerDelegate

-(void)suggestionViewControllerDidTapToDismiss:(SuggestionViewController *)suggestionViewController
{
    [self.urlTextField resignFirstResponder];
    [self dismissSuggestionsViewController];
}

-(void)suggestionViewController:(SuggestionViewController *)suggestionViewController didSelectSuggestion:(Webpage *)webpage
{
    [self.webViewHandler openURL:[NSURL URLWithString:webpage.url]];
    [self.urlTextField resignFirstResponder];
    [self dismissSuggestionsViewController];
}

-(void)suggestionViewController:(SuggestionViewController*)suggestionViewController didSelectSuggestionInNewTab:(Webpage*)webpage
{
    [self.delegate webBrowserViewController:self wantToOpenNewTabWitPage:webpage];
}

#pragma mark - HistoryViewControllerDelegate -

-(void)historyViewController:(HistoryViewController *)historyViewController didSelectWebPage:(WebpageHistory *)webpage
{
    [self.webViewHandler openURL:[NSURL URLWithString:webpage.url]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)historyViewController:(HistoryViewController*)historyViewController didSelectWebPageInNewTab:(WebpageHistory*)webpage
{
    [self.delegate webBrowserViewController:self wantToOpenNewTabWitPage:webpage];
}

-(void)historyViewControllerDismiss:(HistoryViewController *)historyViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BookmarkViewControllerDelegate -

-(void)bookmarViewController:(BookmarkViewController *)bookmarkViewController didSelectWebPage:(WebpageBookmark *)webpage
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.webViewHandler openURL:[NSURL URLWithString:webpage.url]];
}

-(void)bookmarViewController:(BookmarkViewController *)bookmarkViewController didSelectWebPageInNewTab:(WebpageBookmark *)webpage
{
    [self.delegate webBrowserViewController:self wantToOpenNewTabWitPage:webpage];
}

-(void)bookmarViewControllerDismiss:(BookmarkViewController *)bookmarkViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BookmarkWebpageViewControllerDelegate -

-(void)bookmarkWebPageViewControllerDidEndEdit:(BookmarkWebpageViewController *)bookmarkViewController shouldSave:(BOOL)shouldSave
{
    if(shouldSave)
    {
        [[CoreDataManager sharedInstance]saveContext];
    }
    else
    {
        [[CoreDataManager sharedInstance] deleteEntity:bookmarkViewController.webPage];
        [[CoreDataManager sharedInstance]saveContext];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
