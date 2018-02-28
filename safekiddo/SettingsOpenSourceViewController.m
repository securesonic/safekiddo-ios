//
//  OpenSourceViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 25.01.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "SettingsOpenSourceViewController.h"

@interface SettingsOpenSourceViewController ()

@property (weak, nonatomic) IBOutlet UITextView *openSourceLicenseTextField;

@property (strong,nonatomic) NSArray* openSourceTitles;
@property (strong,nonatomic) NSArray* openSourceCopyright;

@end

@implementation SettingsOpenSourceViewController

- (void)viewDidLoad
{
    self.navigationItem.title = NSLocalizedString(@"SETTINGS_OPENSOURCE", @"");
    
    
    self.openSourceTitles = @[@"AFNetworkActivityLogger v2.0",
                              @"AFNetworking v2.4",
                              @"JSONModel v1.0",
                              @"SSKeychain v1.2"];
/*
 pod 'AFNetworking', '~> 2.4'
 pod 'JSONModel', '~> 1.0'
 pod 'SSKeychain', '~> 1.2'
 pod 'RoutingHTTPServer', '~> 1.0'
 pod 'MBProgressHUD', '~> 0.8'
 pod 'AFNetworkActivityLogger', '~> 2.0'
 pod 'FXBlurView', '~> 1.6'
 pod 'CocoaLumberjack'
 pod 'ReplayRequest'
 pod 'SplunkMint-iOS'
 pod 'HockeySDK', '~> 3.6.2'
 */
    
    self.openSourceCopyright = @[@"Copyright (c) 2013-2015 AFNetworking (http://afnetworking.com/)\
                                 \nhttp://opensource.org/licenses/MIT",
                                 @"Copyright (c) 2013-2015 AFNetworking (http://afnetworking.com/)\
                                 \nhttp://opensource.org/licenses/MIT",
                                 @"Copyright (c) 2012-2014 Marin Todorov, Underplot ltd. \
                                 \nhttp://opensource.org/licenses/MIT",
                                 @"Copyright (c) 2010-2014 Sam Soffes. All rights reserved. \
                                 \nRhttp://opensource.org/licenses/MIT"
                                 ];
    
    
    NSDictionary* headerAttributes =@{NSFontAttributeName:[UIFont systemFontOfSize:17.f],
                                      NSBackgroundColorAttributeName:[UIColor whiteColor]
                                      };
    
    NSDictionary* contentAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f],
                                        NSBackgroundColorAttributeName:[UIColor lightGrayColor],
                                        };
    
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]init];
    for(int i=0;i<self.openSourceCopyright.count;i++)
    {
        [string appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@\n",self.openSourceTitles[i]] attributes:headerAttributes]];
        [string appendAttributedString:[[NSAttributedString alloc]initWithString:self.openSourceCopyright[i] attributes:contentAttributes]];
        
        //[string appendAttributedString:[[NSAttributedString alloc]initWithString:<#(NSString *)#> attributes:<#(NSDictionary *)#>]
        
    }
    
    self.openSourceLicenseTextField.attributedText = string;
    /*
     @property(readwrite) CGFloat lineSpacing;
     @property(readwrite) CGFloat paragraphSpacing;
     @property(readwrite) NSTextAlignment alignment;
     @property(readwrite) CGFloat firstLineHeadIndent;
     @property(readwrite) CGFloat headIndent;
     @property(readwrite) CGFloat tailIndent;
     @property(readwrite) NSLineBreakMode lineBreakMode;
     @property(readwrite) CGFloat minimumLineHeight;
     @property(readwrite) CGFloat maximumLineHeight;
     @property(readwrite) NSWritingDirection baseWritingDirection;
     @property(readwrite) CGFloat lineHeightMultiple;
     @property(readwrite) CGFloat paragraphSpacingBefore;
     @property(readwrite) float hyphenationFactor;
     @property(readwrite,copy,NS_NONATOMIC_IOSONLY) NSArray *tabStops NS_AVAILABLE_IOS(7_0);
     @property(readwrite,NS_NONATOMIC_IOSONLY) CGFloat defaultTabInterval NS_AVAILABLE_IOS(7_0);
     */
    
    
    
    
 
    [super viewDidLoad];
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

@end
