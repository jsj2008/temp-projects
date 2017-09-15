//
//  XYTrafficSearchTipViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/10/9.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYTrafficSearchTipViewController.h"
#import <AMapSearchKit/AMapSearchAPI.h>

@interface XYTrafficSearchTipViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,AMapSearchDelegate>
@property(strong,nonatomic)UISearchBar* searchBar;
@property(strong,nonatomic)UIButton* cancelButton;
@property(strong,nonatomic)UIView* titleBarView;
@property(strong,nonatomic)UITableView* tipsTableView;
@property(strong,nonatomic)NSMutableArray* tipsArray;
@end

@implementation XYTrafficSearchTipViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
    if (self.search) {
        self.search.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   [self.navigationController setNavigationBarHidden:false animated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

- (void)initializeUIElements
{
    [self shouldShowBackButton:false];
    self.view.backgroundColor = XY_COLOR(238,240,243);
    
    self.tipsArray = [[NSMutableArray alloc]init];
    
    _titleBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NAVI_BAR_HEIGHT +(ScreenHeight - ScreenFrameHeight ))];
    _titleBarView.backgroundColor = THEME_COLOR;
    [self.view addSubview:_titleBarView];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, (NAVI_BAR_HEIGHT - 30)/2 + (ScreenHeight - ScreenFrameHeight), ScreenWidth - 55, 30)];
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = WHITE_COLOR;
    
    for(UIView* subView in [[_searchBar.subviews lastObject] subviews]){
        if([subView isKindOfClass:[UITextField class]]) {
            ((UITextField*)subView).textColor = BLACK_COLOR;
            ((UITextField*)subView).font = SIMPLE_TEXT_FONT;
        }
    }
    
    for (UIView *view in _searchBar.subviews) {
        if ([view isKindOfClass:[UIView class]] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }

   self.searchBar.placeholder  = @"请输入地铁站/小区/商圈等";
    [_titleBarView addSubview:self.searchBar];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * done = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(endKeyboardInput)];
    [done setTitleTextAttributes:@{NSForegroundColorAttributeName:BLACK_COLOR} forState:UIControlStateNormal];
    NSArray *items = [NSArray arrayWithObjects:spacer, done, nil];
    [toolBar setItems:items animated:YES];
    self.searchBar.inputAccessoryView = toolBar;
    
    _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 60, (NAVI_BAR_HEIGHT - 30)/2 + (ScreenHeight - ScreenFrameHeight), 60, 30)];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [_cancelButton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(onCancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_titleBarView addSubview:_cancelButton];
    
    
    self.tipsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,  _titleBarView.frame.origin.y + _titleBarView.frame.size.height, ScreenWidth, ScreenFrameHeight - (_titleBarView.frame.origin.y + _titleBarView.frame.size.height))];
    self.tipsTableView.backgroundColor = BACKGROUND_COLOR;
    self.tipsTableView.delegate = self;
    self.tipsTableView.dataSource = self;
     self.tipsTableView.separatorColor = XY_COLOR(210,218,228);
    [self.tipsTableView setTableFooterView:[XYWidgetUtil getSingleLineWithColor:XY_COLOR(210,218,228)]];
    
    if ([self.tipsTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tipsTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tipsTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tipsTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:self.tipsTableView];
    
    [self.searchBar becomeFirstResponder];
}

#pragma mark - searchbar delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([XYStringUtil isNullOrEmpty:searchBar.text]) {
        return;
    }
    
    [self searchTipsWithKey:searchBar.text];
}


/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    [self.search AMapInputTipsSearch:tips];
}

- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.tipsArray setArray:response.tips];
    [self.tipsTableView reloadData];
}


#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tipsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
        
        cell.textLabel.font = SIMPLE_TEXT_FONT;
        cell.textLabel.textColor = BLACK_COLOR;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
        cell.detailTextLabel.textColor = MOST_LIGHT_COLOR;
        cell.detailTextLabel.numberOfLines = 2;
    }
    
    AMapTip *tip = self.tipsArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",tip.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"\n%@",tip.district];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
        AMapTip *tip = self.tipsArray[indexPath.row];
        [self.delegate onLocationTipSelected:[NSString stringWithFormat:@"%@%@",tip.district,tip.name]];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - action

-(void)endKeyboardInput
{
    [self.view endEditing:false];
}

-(void)onCancelButtonClicked{
    [self.view endEditing:false];
    [self.navigationController popViewControllerAnimated:false];
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
