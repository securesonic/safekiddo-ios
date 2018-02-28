//
//  SettingsViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 16.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsRow.h"
#import "SettingsSection.h"
#import "Utilities.h"
#import "HistoryController.h"
#import "Settings+SafeSearch.h"
#import "PinViewController.h"
#import "SettingsOptionSelectViewController.h"
#import "SelectChildViewController.h"
#import "ProfileInstaller.h"
#import "Appearance.h"
#import "SettingsWebViewController.h"
#import "UnisntallInstructionsViewController.h"
@interface SettingsViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,SettingsOptionSelectViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) BOOL removePinController;

-(void)clearCookies;
-(void)clearCache;
-(void)clearHistory;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [Appearance tintColor];
    self.removePinController = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.navigationController.viewControllers.count > 1)
    {
        self.navigationItem.leftBarButtonItem = nil;
        if(self.removePinController)
        {
            NSMutableArray* array = [self.navigationController.viewControllers mutableCopy];
            
            for(UIViewController*vc in array)
            {
                if([vc class] == [PinViewController class])
                {
                    [array removeObject:vc];
                    break;
                }
            }
            
            
            self.navigationController.viewControllers = array;
            self.removePinController = NO;
        }
    }
    else
    {
        self.backBarButton.title = NSLocalizedString(@"GENERAL_DISMISS", nil);
    }
    
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView -

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SettingsSection* sectionObject = self.dataSource[section];
    return sectionObject.sectionRows.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsSection* sectionObject = self.dataSource[indexPath.section];
    
    SettingsRow* row = sectionObject.sectionRows[indexPath.row];
    UITableViewCell* cell;
    switch (row.type) {
        case SettingsBrowserIdentity:
        {
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SubtitleCell"];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
            }
            
            if([Settings sharedSettings].useMobileUserAgent)
            {
                cell.detailTextLabel.text = NSLocalizedString(@"SETTINGS_BROWSER_IDENTITY_MOBILE", @"");
            }
            else
            {
                cell.detailTextLabel.text = NSLocalizedString(@"SETTINGS_BROWSER_IDENTITY_DESKTOP", @"");
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
            break;
        case SettingsAssingAcount:
        {
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SubtitleCell"];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
            }
            cell.detailTextLabel.text = [Utilities childName];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case SettingsSearchEngine:
        {
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SubtitleCell"];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
            }
            cell.detailTextLabel.text = StringFromSettingsEngine([Settings sharedSettings].searchEngine);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        default:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
    }
    
    cell.textLabel.text = row.title;
    return cell;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SettingsSection* sectionObject = self.dataSource[section];
    return sectionObject.sectionTitle;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SettingsSection* sectionObject = self.dataSource[indexPath.section];
    SettingsRow* row = sectionObject.sectionRows[indexPath.row];
    
    if(row.type == SettingsClearBrowserHistory||
       row.type == SettingsClearCache ||
       row.type == SettingsCookieClear)
    {
        
        NSString* title;
        NSString* question;
        
        if(row.type == SettingsClearBrowserHistory)
        {
            title = NSLocalizedString(@"SETTINGS_HISTORY_CLEAR_ALERT_TITLE", @"");
            question = NSLocalizedString(@"SETTINGS_HISTORY_CLEAR_ALERT_QUESTION", @"");
        }else if(row.type == SettingsClearCache)
        {
            title = NSLocalizedString(@"SETTINGS_CACHE_CLEAR_ALERT_TITLE", @"");
            question = NSLocalizedString(@"SETTINGS_CACHE_CLEAR_ALERT_QUESTION", @"");
        }else
        {
            title = NSLocalizedString(@"SETTINGS_COOKIE_CLEAR_ALERT_TITLE", @"");
            question = NSLocalizedString(@"SETTINGS_COOKIE_CLEAR_ALERT_QUESTION", @"");
        }
        
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:title message:question delegate:self cancelButtonTitle:NSLocalizedString(@"SETTINGS_ALERT_NO", @"") otherButtonTitles:NSLocalizedString(@"SETTINGS_ALERT_YES", @""),nil];
        alertView.tag = row.type;
        [alertView show];
        
    }else if (row.type == SettingsBrowserIdentity)
    {
        SettingsOptionSelectViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsOptionSelectViewController"];
     
        vc.arrayOfKeys = [@[@(YES),@(NO)]mutableCopy];
        vc.arrayOfTitles=  [@[NSLocalizedString(@"SETTINGS_BROWSER_IDENTITY_MOBILE", @""),
                            NSLocalizedString(@"SETTINGS_BROWSER_IDENTITY_DESKTOP", @"")] mutableCopy];
     
        vc.delegate = self;
        vc.currentKey = @([Settings sharedSettings].useMobileUserAgent);
        vc.settingsOption = row.type;
        vc.navigationItem.title = row.title;
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if(row.type == SettingsSearchEngine)
    {
        SettingsOptionSelectViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsOptionSelectViewController"];
        
        vc.arrayOfKeys = [@[@(SearchEngineGoogle),@(SearchEngineBing),@(SearchEngineYahoo)]mutableCopy];
        vc.arrayOfTitles=  [@[StringFromSettingsEngine(SearchEngineGoogle),
                              StringFromSettingsEngine(SearchEngineBing),
                              StringFromSettingsEngine(SearchEngineYahoo)
                              ] mutableCopy];
        
        vc.delegate = self;
        vc.currentKey = @([Settings sharedSettings].searchEngine);
        vc.settingsOption = row.type;
        vc.navigationItem.title = row.title;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (row.type == SettingsBrowserParentMode)
    {
        PinViewController* pinViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PinViewController"];
        [self.navigationController pushViewController:pinViewController animated:YES];
    }else if(row.type == SettingsAssingAcount)
    {
        SelectChildViewController* selectChildAccout = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectChildViewController"];
        selectChildAccout.type = SelectChildViewControllerTypeSettings;
        
        [self.navigationController pushViewController:selectChildAccout animated:YES];
    }else if(row.type == SettingsLogout)
    {
        [self performSegueWithIdentifier:@"showLogout" sender:nil];
    } else if(row.type == SettingsAbout)
    {
        SettingsViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        
        

        vc.dataSource = @[
                          [SettingsSection sectionWithTitle:@"" andRows:@[[SettingsRow rowWithType:SettingsVersion],
                                                                          [SettingsRow rowWithType:SettingsTermsAndConditions],
                                                                          [SettingsRow rowWithType:SettingsPrivacyPolicy],
                                                                          [SettingsRow rowWithType:SettingsCookiesPolicy],
                                                                          [SettingsRow rowWithType:SettingsOpenSource],
                                                                          [SettingsRow rowWithType:SettingsCopyright]]]
                          ];
        vc.navigationItem.title = NSLocalizedString(@"SETTINGS_ABOUT", @"");
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if(row.type == SettingsTermsAndConditions)
    {
        SettingsWebViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsWebViewController"];
        vc.loadURL = [NSURL URLWithString:@"https://www.safekiddo.com/mobile/terms"];
        vc.navigationItem.title = row.title;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(row.type == SettingsPrivacyPolicy)
    {
        SettingsWebViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsWebViewController"];
        vc.loadURL = [NSURL URLWithString:@"https://www.safekiddo.com/mobile/privacy"];
        vc.navigationItem.title = row.title;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(row.type == SettingsCookiesPolicy)
    {
        SettingsWebViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsWebViewController"];
        vc.loadURL = [NSURL URLWithString:@"https://www.safekiddo.com/mobile/cookies"];
        vc.navigationItem.title = row.title;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(row.type == SettingsManageSafeKiddo)
    {
        SettingsWebViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsWebViewController"];
        vc.loadURL = [NSURL URLWithString:@"https://my.safekiddo.com/login"];
        vc.navigationItem.title = row.title;
         [self.navigationController pushViewController:vc animated:YES];
        
    }else if(row.type == SettingsOpenSource)
    {
        [self performSegueWithIdentifier:@"pushOpenSource" sender:self];
    }
}

#pragma mark - UIAlertViewDelegate -

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        switch ((SettingsEnum)alertView.tag)
        {
            case SettingsClearBrowserHistory:
            {
                [self clearHistory];
            }
                break;
            case SettingsClearCache:
            {
                [self clearCache];
            }
                break;
            case SettingsCookieClear:
            {
                [self clearCookies];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - IABctions -

- (IBAction)backAction:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NO];
}

#pragma mark - Public -

-(void)openOptionAtIndex:(NSIndexPath*)indexPath
{
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Private -

-(void)clearCookies
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        if([[cookie name]isEqualToString:@"safekiddo_mobile"])
        {
            //NSLog(@"%@",cookie);
        }
        else
        {
        [storage deleteCookie:cookie];
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)clearCache
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

-(void)clearHistory
{
    [[HistoryController sharedHistoryController]deleteWebPagesHistory];
}

#pragma - gsOptionSelectViewControllerDelegate -

-(void)settingsOptionSelectViewController:(SettingsOptionSelectViewController *)controller didSelectKey:(id)key
{
    if(controller.settingsOption == SettingsBrowserIdentity)
    {
        [Settings sharedSettings].useMobileUserAgent = ((NSNumber*)key).boolValue;
        [self.tableView reloadData];
    }else if(controller.settingsOption == SettingsSearchEngine)
    {
        [Settings sharedSettings].searchEngine = ((NSNumber*)key).intValue;
        [self.tableView reloadData];
    }
}



@end
