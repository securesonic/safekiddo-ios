//
//  SuggestionViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 24.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "SuggestionViewController.h"
#import "SuggestionTableViewCell.h"
@interface SuggestionViewController()<UITableViewDataSource,UITableViewDelegate, SuggestionTableViewCellDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSArray* arrayOfHistoryItems;

@end

@implementation SuggestionViewController

#pragma mark - Public - 

-(void)updateSuggestions:(NSArray*)newSuggestions
{
    self.arrayOfHistoryItems = newSuggestions;
    [self.tableView reloadData];
}

#pragma mark - UITableView -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfHistoryItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SuggestionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    id webPage = self.arrayOfHistoryItems[indexPath.row];
    [cell fillWithWebPage:webPage];
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate suggestionViewController:self didSelectSuggestion:self.arrayOfHistoryItems[indexPath.row]];
}

#pragma mark - IBActions -
- (IBAction)didTapOutside:(id)sender
{
    [self.delegate suggestionViewControllerDidTapToDismiss:self];
}

#pragma mark - SuggestionTableViewCellDelegate -

-(void)suggestionTableViewCellDidLongPress:(id)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    Webpage* page = self.arrayOfHistoryItems[indexPath.row];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:page.url
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"NEW_TAB_CANCEL", @"")
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:NSLocalizedString(@"NEW_TAB_OPEN", @"")
                                                                    ,NSLocalizedString(@"NEW_TAB_OPEN_IN_NEW", @""), nil];
    
    actionSheet.tag = indexPath.row;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate -

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    Webpage* page = self.arrayOfHistoryItems[actionSheet.tag];
    
    if(buttonIndex == 0)
    {
        [self.delegate suggestionViewController:self didSelectSuggestion:page];
    }
    else if(buttonIndex ==1)
    {
        [self.delegate suggestionViewController:self didSelectSuggestionInNewTab:page];
    }
}

@end
