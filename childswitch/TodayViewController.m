//
//  TodayViewController.m
//  childswitch
//
//  Created by Jakub Dlugosz on 08.03.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "Constants.h"
#import "TodayChildTableCell.h"
@interface TodayViewController () <NCWidgetProviding,UITableViewDataSource,TodayChildTableCellDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSDictionary* dataSource;
@property (strong,nonatomic) NSDictionary* avatarDataSource;

@end

@implementation TodayViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {

    NSUserDefaults* userDefaults = [[NSUserDefaults alloc]initWithSuiteName:kUserDefaultsSharedId];
    
    self.dataSource = [userDefaults objectForKey:kChildrenKey];
    self.avatarDataSource = [userDefaults objectForKey:kChildrenAvatarKey];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    self.heightConstraint.constant = 44.f * self.dataSource.count;
    [self.view layoutIfNeeded];
    
    completionHandler(NCUpdateResultNewData);
}

#pragma mark - UITableView -

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayChildTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.delegate = self;
   NSArray* sortedKeys = [self.dataSource.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString* name1 = obj1;
        NSString* name2 = obj2;
        
        return [name1 compare:name2];
    }];
    
    cell.childNameLabel.text = self.dataSource[sortedKeys[indexPath.row]];
    
    NSString* string = self.avatarDataSource[sortedKeys[indexPath.row]];
    
    cell.childAvatarImageView.image = nil;
    if(string.class != [NSNull class])
    {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
                       UIImage* image = [UIImage imageWithData:imageData];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
        
        cell.childAvatarImageView.image = image;

                       });
                  });
    }
    

//    [self.childIconImageView setImageWithURL:[NSURL URLWithString:child.avatarUrl?child.avatarUrl:nil] placeholderImage:[UIImage imageNamed:@"icon-child"]];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

#pragma mark - TodayChildTableCellDelegate -

-(void)cellDidPickChild:(TodayChildTableCell *)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    NSArray* sortedKeys = [self.dataSource.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString* name1 = obj1;
        NSString* name2 = obj2;
        
        return [name1 compare:name2];
    }];
    
    NSString* uuid = sortedKeys[indexPath.row];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:kURLFormat,uuid,self.dataSource[uuid]]];
    [self.extensionContext openURL:url completionHandler:nil];
}

@end
