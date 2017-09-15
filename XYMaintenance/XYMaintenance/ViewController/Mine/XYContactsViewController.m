//
//  XYContactsViewController.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/21.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYContactsViewController.h"
#import "XYContactCell.h"
#import "XYWarningTitleView.h"
#import "XYContactViewModel.h"

@interface XYContactsViewController ()<UITableViewDataSource,UITableViewDelegate,XYContactCallBackDelegate>
{
    UITableView* _tableView;
    XYWarningTitleView* _titleView;
    
    XYContactViewModel* _viewModel;
}
@end

@implementation XYContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    _viewModel.delegate = nil;
    [_viewModel cancelAllRequests];
}

#pragma mark - override

- (void)initializeModelBinding
{
    _viewModel = [[XYContactViewModel alloc]init];
    _viewModel.delegate = self;
}

- (void)initializeUIElements
{
    self.navigationItem.title = @"企业通讯录";
    [self shouldShowBackButton:true];
    
    _titleView = [[XYWarningTitleView alloc]init];
    [_titleView setWarningText:[NSString stringWithFormat:@"紧急电话：%@",_viewModel.servicePhone]];
    [self.view addSubview:_titleView];
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callServicePhone)];
    [_titleView addGestureRecognizer:tapGesture];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _titleView.frame.size.height, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - _titleView.frame.size.height - NAVI_BAR_HEIGHT)];
    _tableView.backgroundColor = BACKGROUND_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableFooterView:[XYWidgetUtil getSingleLine]];
    [_tableView setTableHeaderView:[XYWidgetUtil getSingleLine]];
    [XYContactCell xy_registerTableView:_tableView identifier:[XYContactCell defaultReuseId]];
    [self.view addSubview:_tableView];
    
    [self getContactsList];
}


#pragma mark - refresh view

-(void)getContactsList
{
    [self showLoadingMask];
    [_viewModel loadContactsList];
}

#pragma mark - phone call

-(void)callServicePhone
{
    [self callPhone:_viewModel.servicePhone];
}

-(void)callPhone:(NSString*)phoneNumber{
    [XYAlertTool callPhone:phoneNumber onView:self];
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_viewModel.sectionTitleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray*)[_viewModel.contactsDictionary objectForKey:[_viewModel.sectionTitleArray objectAtIndex:section]]count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [XYContactCell defaultHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_viewModel.sectionTitleArray objectAtIndex:section];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYContactCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYContactCell defaultReuseId]];
    NSArray* contactArray = [_viewModel.contactsDictionary objectForKey:[_viewModel.sectionTitleArray objectAtIndex:indexPath.section]];
    [cell setData:[contactArray objectAtIndex:indexPath.row]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return  _viewModel.sectionTitleArray;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
   
    NSArray* contactArray = [_viewModel.contactsDictionary objectForKey:[_viewModel.sectionTitleArray objectAtIndex:indexPath.section]];
    XYUserDto* dto = [contactArray objectAtIndex:indexPath.row];
    [self callPhone:dto.mobile];
}

#pragma mark - call back 

-(void)onContactsListLoaded:(BOOL)success noteString:(NSString *)str
{
    [self hideLoadingMask];
    
    if (success)
    {
        [_tableView reloadData];
    }
    else
    {
        [self showToast:str];
    }
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
