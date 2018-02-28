//
//  HistoryViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 26.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryController.h"
#import "WebpageHistory.h"
#import "SuggestionTableViewCell.h"
#import "Appearance.h"
#import "NSDate+Util.h"

@interface HistoryViewController ()<UITableViewDataSource,UITableViewDelegate,SuggestionTableViewCellDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray* historyDataSource;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;
@property (strong,nonatomic)WebpageHistory* actionSheetWebpage;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"HISTORY_TITLE", @"");
    [self.closeButton setTitle:NSLocalizedString(@"GENERAL_DISMISS",@"")];
    self.tableView.backgroundColor = [Appearance tintColor];

 
    NSArray* webPageArray = [[HistoryController sharedHistoryController]arrayOfHistoryWebPages];
    
    NSMutableArray* dataSource = [NSMutableArray new];
    
    if(webPageArray.count>0)
    {
        int currentIndex = 0;
        
        NSDate* currentDate =  ((WebpageHistory*)webPageArray[currentIndex]).dateOnly;
        NSMutableArray* currentArray = [NSMutableArray arrayWithObject:webPageArray[currentIndex]];
        currentIndex++;
        
        while (currentIndex<webPageArray.count)
        {
            if([currentDate timeIntervalSinceDate:((WebpageHistory*)webPageArray[currentIndex]).dateOnly] == 0)
            {
                [currentArray addObject:webPageArray[currentIndex]];
            }
            else
            {
                [dataSource addObject:currentArray];
                currentArray = [NSMutableArray arrayWithObject:webPageArray[currentIndex]];
                currentDate = ((WebpageHistory*)webPageArray[currentIndex]).dateOnly;
            }
            currentIndex++;
        }
        
        [dataSource addObject:currentArray];
    }

    self.historyDataSource = dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView -


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.historyDataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* array = self.historyDataSource[section];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* array = self.historyDataSource[indexPath.section];
    
    WebpageHistory* page= array[indexPath.row];
    
    SuggestionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.delegate = self;
    [cell fillWithWebPage:page];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSMutableArray* array = self.historyDataSource[section];

    WebpageHistory* firstOfDay = array[0];
    return [firstOfDay.dateOnly dayString];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSMutableArray* array = self.historyDataSource[indexPath.section];
    WebpageHistory* webPage = array[indexPath.row];
    
    [self.delegate historyViewController:self didSelectWebPage:webPage];
}

#pragma mark - SuggestionTableViewCellDelegate -

-(void)suggestionTableViewCellDidLongPress:(id)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    NSMutableArray* array = self.historyDataSource[indexPath.section];
    WebpageHistory* webPage = array[indexPath.row];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:webPage.url
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"NEW_TAB_CANCEL", @"")
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:NSLocalizedString(@"NEW_TAB_OPEN", @"")
                                  ,NSLocalizedString(@"NEW_TAB_OPEN_IN_NEW", @""), nil];
    
    self.actionSheetWebpage = webPage;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate -

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    WebpageHistory* page = self.actionSheetWebpage;
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if(buttonIndex == 0)
        {
            [self.delegate historyViewController:self didSelectWebPage:page];
        }
        else if(buttonIndex ==1)
        {
            [self.delegate historyViewController:self didSelectWebPageInNewTab:page];
        }
    });
}

#pragma mark - IBActions -

- (IBAction)closeAction:(id)sender {
    [self.delegate historyViewControllerDismiss:self];
}


@end
