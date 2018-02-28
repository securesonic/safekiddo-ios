//
//  BookmarkFolderListViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 11.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "BookmarkFolderListViewController.h"
#import "BookmarkFolderListTableViewCell.h"
#import "CoreDataManager+SafeKiddo.h"
@interface BookmarkFolderListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray* dataSource;
@property (strong,nonatomic) NSMutableArray* dataSourcesDepth;
-(NSMutableArray*)prepareDataSourceWithDepth:(NSMutableArray**)dataSourceDepth;
-(void)fillDataSource:(NSMutableArray*)array andDepths:(NSMutableArray*)depths withFolder:(BookmarkFolder*)folder andDepth:(int)depth;
@end

@implementation BookmarkFolderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"BOOKMARK_CHOOSE_FOLDER", @"");
    NSMutableArray* depthArray;
    self.dataSource = [self prepareDataSourceWithDepth:&depthArray];
    self.dataSourcesDepth = depthArray;
    
    
    NSInteger index = [self.dataSource indexOfObject:self.folder];
    if(index != NSNotFound)
    {
        [self.dataSource removeObjectAtIndex:index];
        [self.dataSourcesDepth removeObjectAtIndex:index];
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookmarkFolderListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  
    BookmarkFolder* folder = self.dataSource[indexPath.row];
    NSNumber* depth = self.dataSourcesDepth[indexPath.row];
    [cell fillWithTitle:folder.name andDepth:depth.intValue];
    
    if(self.folder.parentFolder == folder ||
       self.webPage.folder == folder)
    {
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"accessory_check"]];
    }
    else
    {
        cell.accessoryView = nil;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookmarkFolder* folder = self.dataSource[indexPath.row];
    
    if(self.webPage)
    {
     //   NSLog(@"%@",self.webPage);
        [self.webPage.folder removeWebpagesObject:self.webPage];
        [folder addWebpagesObject:self.webPage];
    }
    else
    {
        self.folder.parentFolder = folder;
    }
    

    [self.tableView reloadData];
}

#pragma mark - Private -

-(NSMutableArray*)prepareDataSourceWithDepth:(NSMutableArray**)dataSourceDepth
{
    BookmarkFolder* rootFolder = [[CoreDataManager sharedInstance]rootFolder];
    
    NSMutableArray* dataSource = [NSMutableArray array];
    NSMutableArray* depths =[NSMutableArray array];
    
    [self fillDataSource:dataSource andDepths:depths withFolder:rootFolder andDepth:1];
    
    *dataSourceDepth = depths;
    return dataSource;
}

-(void)fillDataSource:(NSMutableArray*)array andDepths:(NSMutableArray*)depths withFolder:(BookmarkFolder*)folder andDepth:(int)depth
{
    [array addObject:folder];
    [depths addObject:@(depth)];
    
    for(BookmarkFolder* f in folder.subFolders)
    {
        [self fillDataSource:array andDepths:depths withFolder:f andDepth:depth+1];
    }
}

@end
