//
//  MemoTableViewController.m
//  EncryptAlbumMeno
//
//  Created by ataw on 16/8/4.
//  Copyright © 2016年 王宗成. All rights reserved.
//

#import "MemoTableViewController.h"
#import "MenoTableViewCell.h"
#import "MenoViewController.h"
@interface MemoTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MemoTableViewController
{
    NSMutableArray *menoFIleArr;
    UITableView *_tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    menoFIleArr = [NSMutableArray array];
    self.navTitle = @"备忘录";
    [self creatNavAndStateView];
    [self creatLeftBtn];
    [self creatRightBtn];
    
    [self creatTable];
    
}

-(void)initDataFormDB
{
    [menoFIleArr removeAllObjects];
    NSArray *arr = [DataBaseManager queryValueFormMenoTable];
    
    [menoFIleArr addObjectsFromArray:arr];
    
    [_tableView reloadData];
}

-(void)creatTable
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,GBWidth,GBHeight - 64) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.showsVerticalScrollIndicator = NO;

    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[MenoTableViewCell class] forCellReuseIdentifier:@"MenoTableViewCell"];
    
    [self.view addSubview:_tableView];
}

-(void)creatRightBtn
{
    UIButton *rightButton;
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(GBWidth - 100, 20 + 7, 100, 30);
    [rightButton setTitle:@"添加备忘录" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navAndStateView addSubview:rightButton];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return menoFIleArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 54;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenoTableViewCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = menoFIleArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   dispatch_async(dispatch_get_main_queue(), ^{
       
       MenoViewController *vc = [[MenoViewController alloc]init];
       vc.mod = menoFIleArr[indexPath.row];
       
       [self presentViewController:vc animated:NO completion:nil];
   });
}

//添加一条备忘录
-(void)submitButtonAction:(UIButton *)b
{
    MenoViewController *vc = [[MenoViewController alloc]init];
    vc.mod = nil;
    [self presentViewController:vc animated:NO completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self initDataFormDB];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [DataBaseManager deleteMeno:menoFIleArr[indexPath.row]];
        
        [menoFIleArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
