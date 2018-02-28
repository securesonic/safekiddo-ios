//
//  SettingsOptionSelectViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 17.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "SettingsOptionSelectViewController.h"
#import "Appearance.h"

@interface SettingsOptionSelectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsOptionSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [Appearance tintColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView - 

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfKeys.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = self.arrayOfTitles[indexPath.row];
    
    if(self.arrayOfKeys[indexPath.row] == self.currentKey)
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentKey = self.arrayOfKeys[indexPath.row];
    
    [self.delegate settingsOptionSelectViewController:self didSelectKey:self.currentKey];
    
    [self.navigationController popViewControllerAnimated:YES];
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
