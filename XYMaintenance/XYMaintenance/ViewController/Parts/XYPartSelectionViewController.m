//
//  XYPartSelectionViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/21.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYPartSelectionViewController.h"

static NSString *const XYPartSelectionCellIdentifier = @"XYPartSelectionCellIdentifier";

@interface XYPartSelectionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView* tableView;
@property(strong,nonatomic)NSMutableArray* partsArray;
@property(assign,nonatomic)NSInteger selectedIndex;
@end

@implementation XYPartSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

- (void)initializeUIElements{
    self.navigationItem.title = @"选择零件";
    [self shouldShowBackButton:true];
    self.view.backgroundColor = WHITE_COLOR;
    [self.view addSubview:self.tableView];
    self.selectedIndex = -1;
    [self getParts];
}

#pragma mark - properties

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT)];
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.separatorColor = XY_HEX(0xc9d2e0);
        _tableView.delegate = self;
        _tableView.rowHeight = 45;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[XYWidgetUtil getSingleLineWithInset:15]];
        [_tableView setTableHeaderView:nil];
    }
    return _tableView;
}

-(NSMutableArray*)partsArray{
    if (!_partsArray) {
        _partsArray = [[NSMutableArray alloc]init];        
    }
    return _partsArray;
}

-(void)getParts{
//    [self showLoadingMask];
//    __weak typeof(self) weakself = self;
//    [_viewModel getDeviceColors:^{
//        [weakself hideLoadingMask];
//        [_tableView reloadData];
//        _tableView.hidden = false;
//    } errorString:^(NSString *e) {
//        [weakself hideLoadingMask];
//        [weakself showToast:e];
//    }];
}


#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.partsArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:XYPartSelectionCellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:XYPartSelectionCellIdentifier];
        cell.textLabel.font = SIMPLE_TEXT_FONT;
        cell.textLabel.textColor = BLACK_COLOR;
    }
    cell.textLabel.text = [self.partsArray objectAtIndex:indexPath.row];
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:(self.selectedIndex==indexPath.row)? @"part_yes":@"part_no"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    self.selectedIndex=indexPath.row;
    [self.tableView reloadData];
   // [self.delegate onColorSelected:[_viewModel.colorArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
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
