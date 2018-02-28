//
//  WelcomeViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 11.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "WelcomeViewController.h"
#import "WelcomeTutorialView.h"
#import "WelcomeView.h"
#import "Utilities.h"
#import "LoginViewController.h"
#import "Constants.h"
@interface WelcomeViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *backgroundScrollView;
@property (weak, nonatomic) IBOutlet UIImageView  *page1BackgroundImageView;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;


@property (strong,nonatomic) NSArray* tutorialViews;
@property (strong,nonatomic) NSArray* tutorialBackgroundViews;

-(UIImageView*)prepareBackgroundImageViewWithImageName:(NSString*)imageName;

-(void)loginNotification:(NSNotification*)notification;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.loginButton setTitle:NSLocalizedString(@"WELCOME_BTN1_TXT", @"") forState:UIControlStateNormal];
    
    [self.createAccountButton setTitle:NSLocalizedString(@"WELCOME_BTN2_TXT", @"") forState:UIControlStateNormal];
    
    self.tutorialViews = @[
                           [[NSBundle mainBundle] loadNibNamed:@"WelcomeView" owner:nil options:nil][0],
                           [WelcomeTutorialView tutorialViewWithLogoImage:[UIImage imageNamed:@"WelcomeTutorialGlobe"]
                                                                    title:NSLocalizedString(@"WELCOME_TUT1_TXT1", @"")
                                                                 subtitle:NSLocalizedString(@"WELCOME_TUT1_TXT2", @"")],
                           [WelcomeTutorialView tutorialViewWithLogoImage:[UIImage imageNamed:@"WelcomeTutorialTime"]
                                                                    title:NSLocalizedString(@"WELCOME_TUT2_TXT1", @"")
                                                                 subtitle:NSLocalizedString(@"WELCOME_TUT2_TXT2", @"")],
                           [WelcomeTutorialView tutorialViewWithLogoImage:[UIImage imageNamed:@"WelcomeTutorialApps"]
                                                                    title:NSLocalizedString(@"WELCOME_TUT3_TXT1", @"")
                                                                 subtitle:NSLocalizedString(@"WELCOME_TUT3_TXT2", @"")]
                           ];
    
    self.tutorialBackgroundViews = @[
                                     [self prepareBackgroundImageViewWithImageName:@"WelcomeBackground1"],
                                     [self prepareBackgroundImageViewWithImageName:@"WelcomeBackground2"],
                                     [self prepareBackgroundImageViewWithImageName:@"WelcomeBackground3"],
                                     [self prepareBackgroundImageViewWithImageName:@"WelcomeBackground1"]];

    for(int i=0;i<self.tutorialViews.count;i++)
    {
        [self.scrollView addSubview:self.tutorialViews[i]];
        [self.backgroundScrollView addSubview:self.tutorialBackgroundViews[i]];

        
        [self.backgroundScrollView layoutIfNeeded];
    }
    
    self.pageControl.numberOfPages = self.tutorialViews.count;
    self.pageControl.currentPage = 0;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginNotification:) name:kLoginNotificationName object:nil];
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.tutorialViews.count, self.scrollView.frame.size.height);
    self.backgroundScrollView.contentSize = self.scrollView.contentSize;
    
    
    for(int i=0;i<self.tutorialViews.count;i++)
    {
        UIView* view  = self.tutorialViews[i];
        
        CGFloat yOffset = 0.f;
        
        if(!IS_WIDESCREEN)
        {
            yOffset -= 30.f;
        }
        
        view.frame = (CGRect){i* self.scrollView.frame.size.width,yOffset,self.scrollView.frame.size};
        
        UIView* backgoundView = self.tutorialBackgroundViews[i];
        backgoundView.frame = (CGRect){i* self.scrollView.frame.size.width, 0, self.scrollView.frame.size};
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations
{
    if(IS_IPHONE)
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    else
    {
        return UIInterfaceOrientationMaskAll;
    }
}

#pragma mark - IBActions -
- (IBAction)loginAction:(id)sender
{
    UIViewController* authenticateViewController = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil]instantiateInitialViewController];
   
    
    if(IS_IPAD)
    {
        [authenticateViewController setModalPresentationStyle:UIModalPresentationFormSheet];
        [authenticateViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        //UIPopoverController* popober = [[UIPopoverController alloc]initWithContentViewController:authenticateViewController];
        //[self presentViewController:popober animated:YES completion:nil];
    }
   
    [self presentViewController:authenticateViewController animated:YES completion:nil];
    
    
   
}
- (IBAction)createAccountAction:(id)sender
{
    UIViewController* createUserViewController = [[UIStoryboard storyboardWithName:@"Register" bundle:nil]instantiateInitialViewController];
    
    if(IS_IPAD)
    {
        [createUserViewController setModalPresentationStyle:UIModalPresentationFormSheet];
        [createUserViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    }
    
    [self presentViewController:createUserViewController animated:YES completion:nil];
}

- (IBAction)pageControlValueChanged:(id)sender
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * self.pageControl.currentPage , 0) animated:YES];
}

#pragma mark - Private - 

-(void)loginNotification:(NSNotification *)notification
{
    void (^loginBlock)() = ^()
    {
         UINavigationController* authenticateViewController = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil]instantiateInitialViewController];
        
        if([authenticateViewController isKindOfClass:[UINavigationController class]] &&
            [authenticateViewController.viewControllers[0] isKindOfClass:[LoginViewController class]])
        {
            LoginViewController* lvc = authenticateViewController.viewControllers[0];
            
            lvc.preLoadedLogin = notification.userInfo[kLoginNotificationLoginParameter];
            lvc.preLoadedPassword = notification.userInfo[kLoginNotificationPasswordParameter];
            
            if(IS_IPAD)
            {
                [authenticateViewController setModalPresentationStyle:UIModalPresentationFormSheet];
                [authenticateViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            }
            
            [self presentViewController:authenticateViewController animated:YES completion:nil];
        }
        else
        {
            [self loginAction:nil];
        }
    };
    
    
    if(self.presentedViewController)
    {
        [self dismissViewControllerAnimated:true completion:loginBlock];
    }
    else
    {
        loginBlock();
    }
    
    /*
     
     NSString* const kLoginNotificationName = @"LoginNotificationName";
     NSString* const kLoginNotificationLoginParameter = @"LoginNotificationLoginParameter";
     NSString* const kLoginNotificationPasswordParameter = @"LoginNotificationPasswordParameter";
     */
}

#pragma mark - UIScrollViewDelegate -

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x >=0 && (scrollView.contentOffset.x + scrollView.frame.size.width) <= scrollView.contentSize.width)
    {
        CGPoint offset = scrollView.contentOffset;
        self.backgroundScrollView.contentOffset = offset;
    }
    
}

-(UIImageView*)prepareBackgroundImageViewWithImageName:(NSString*)imageName
{
    UIImageView* imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.clipsToBounds = YES;
    return imgV;
}

@end
