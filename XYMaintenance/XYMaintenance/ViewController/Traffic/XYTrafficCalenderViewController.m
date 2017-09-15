//
//  XYTrafficCalenderViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/24.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYTrafficCalenderViewController.h"
#import "XYTrafficCalendarViewModel.h"
#import "JTCalendar.h"
#import "XYTrafficFeeCell.h"
#import "XYSimpleSegmentedControl.h"
#import "DYMonthlyCalendarView.h"
#import "XYTrafficAddFeeViewController.h"



@interface XYTrafficCalenderViewController ()<JTCalendarDelegate,UITableViewDataSource,UITableViewDelegate,XYTrafficCalendarCallBackDelegate,DYMonthlyCalendarViewDelegate,XYTrafficAddFeeDelegate>

@property (strong, nonatomic)  XYSimpleSegmentedControl* segControl;

@property (strong, nonatomic)  JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic)  JTHorizontalCalendarView *calendarContentView;
@property (strong, nonatomic)  JTCalendarManager *calendarManager;

@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  UIView* dayHeaderView;
@property (strong, nonatomic)  DYMonthlyCalendarView* monthHeaderView;
@property (strong, nonatomic)  UIButton *addFeeButton;

@property (strong,nonatomic) XYTrafficCalendarViewModel* viewModel;
@property (strong,nonatomic) NSDate* todayDate;
@property (strong,nonatomic) NSDate* selectedDate;

@end

@implementation XYTrafficCalenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    _viewModel = [[XYTrafficCalendarViewModel alloc]init];
    _viewModel.delegate = self;
}

- (void)initializeUIElements {
   
    self.navigationItem.title = @"交通费";
    [self shouldShowBackButton:true];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [self initTitleSeg];
    [self initTableView];
    
    [self.viewModel loadRecordOfDate:self.todayDate forced:false];
}

#pragma mark - init UI

- (void)initTitleSeg{
    self.segControl = [[XYSimpleSegmentedControl alloc]initWithSectionTitles:@[@"日",@"月"]];
    self.segControl.frame = CGRectMake(0, 0, ScreenWidth, 45);
    [self.segControl addTarget:self action:@selector(onSegmentSelected) forControlEvents:UIControlEventValueChanged];
    self.segControl.selectedIndex = 0;
    [self.view addSubview:self.segControl];
}

-(void)initTableView
{
    self.dayHeaderView = [self getDayHeaderView];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.segControl.frame.size.height, ScreenWidth, ScreenFrameHeight - NAVI_BAR_HEIGHT- self.segControl.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.tableView setTableHeaderView:self.dayHeaderView];
    [self.tableView setTableFooterView:[XYWidgetUtil getSingleLineWithColor:XY_COLOR(210,218,228)]];
    [self.view addSubview:self.tableView];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UIView*)getDayHeaderView
{
    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, 300)];
    headerView.backgroundColor = BACKGROUND_COLOR;
    
    self.calendarMenuView = [[JTCalendarMenuView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    self.calendarMenuView.backgroundColor = WHITE_COLOR;
    [headerView addSubview:self.calendarMenuView];
    
    self.calendarContentView = [[JTHorizontalCalendarView alloc]initWithFrame:CGRectMake(0, self.calendarMenuView.frame.origin.y + self.calendarMenuView.frame.size.height, ScreenWidth, 250)];
    self.calendarContentView.backgroundColor = WHITE_COLOR;
    [headerView addSubview:self.calendarContentView];
    
    UIView* btLine = [XYWidgetUtil getSingleLineWithColor:XY_COLOR(210,218,228)];
    btLine.frame = CGRectMake(0, self.calendarContentView.frame.size.height + self.calendarContentView.frame.origin.y,ScreenWidth,LINE_HEIGHT);
    [headerView addSubview:btLine];
    
    UIView* dvdLine = [XYWidgetUtil getSingleLineWithColor:XY_COLOR(210,218,228)];
    dvdLine.frame = CGRectMake(0, self.calendarContentView.frame.size.height + self.calendarContentView.frame.origin.y + 10-LINE_HEIGHT,ScreenWidth,LINE_HEIGHT);
    [headerView addSubview:dvdLine];
    
    self.todayDate = [NSDate date];
    self.selectedDate = self.todayDate;
    
    self.calendarManager = [[JTCalendarManager alloc]init];
    self.calendarManager.delegate = self;
    [self.calendarManager setMenuView:self.calendarMenuView];
    [self.calendarManager setContentView:self.calendarContentView];
    [self.calendarManager setDate:self.todayDate];
    
    return headerView;
}

-(DYMonthlyCalendarView*)monthHeaderView
{
    if (!_monthHeaderView) {
        _monthHeaderView = [[DYMonthlyCalendarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 240)];
        _monthHeaderView.monthDelegate = self;
        NSDateComponents *comps = [self.calendarManager.dateHelper.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:self.todayDate];
        [self.monthHeaderView setDefaultYear:comps.year andMonth:comps.month-1];
    }
    
    return _monthHeaderView;
}

-(UIButton*)addFeeButton
{
    if (!_addFeeButton) {
        _addFeeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
        [_addFeeButton setBackgroundImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
        [_addFeeButton addTarget:self action:@selector(goToDayRecordList) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addFeeButton;
}

#pragma mark - CalendarManager delegate

- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:[NSDate dateWithTimeIntervalSince1970:0] andEqualOrBefore:[_calendarManager.dateHelper addToDate:_todayDate months:1]];
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = false;
    
    // Other month
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.hidden = true;
    }
    // Selected date
    else if(self.selectedDate && [_calendarManager.dateHelper date:self.selectedDate isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    //Today
    else if([_calendarManager.dateHelper date:self.todayDate isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.1];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Weekend
    else if([_calendarManager.dateHelper isSaturdayOrSunday:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
     dayView.dotView.hidden = YES;
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    if ( [self.selectedDate isEqualToDate:dayView.date] ){
        return;
    }
    
    self.selectedDate = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    
    [self getRecordOfDate:self.selectedDate];
}

#pragma mark - month delegate

- (void)selectMonthOfYear:(NSInteger)year month:(NSInteger)month//0-11的
{
    [self getRecordOfMonth:month+1 year:year];
}


#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.segControl.selectedIndex == 0) {
        return 1;
    }else if (self.segControl.selectedIndex == 1) {
        return 2;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return [self.viewModel.currentMonthInfo.list count];
            break;
        default:
            return 0;
            break;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* cellIdentifier = @"XYTrafficCalendarCell";
    
    if (indexPath.section == 0)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.textLabel.textColor = BLACK_COLOR;
            cell.textLabel.font = LARGE_TEXT_FONT;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row ==0)
        {
            cell.detailTextLabel.textColor = BLACK_COLOR;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@完成订单数",(self.segControl.selectedIndex==0)?@"日":@"月"];

            if (self.segControl.selectedIndex==0) {
                XYTFCDailyInfo* info = [self.viewModel getFeeRecordOfDate:self.selectedDate];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",(long)info.count];
            }else{
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",(long)self.viewModel.currentMonthInfo.info.count];
            }
        }
        else if (indexPath.row==1)
        {
            cell.detailTextLabel.textColor = THEME_COLOR;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.textLabel.text = [NSString stringWithFormat:@"%@交通费统计",(self.segControl.selectedIndex==0)?@"日":@"月"];

            if (self.segControl.selectedIndex==0) {//日
                XYTFCDailyInfo* info = [self.viewModel getFeeRecordOfDate:self.selectedDate];
                if (info.money>0.001) {//有交通费记录
                    cell.accessoryView = nil;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2f",info.money];
                }else{//没报过
                    if (info.edit) {
                        cell.detailTextLabel.text = @"";
                        cell.accessoryView = self.addFeeButton;
                    }else{
                        cell.detailTextLabel.text = @"￥0.00";
                        cell.accessoryView = nil;
                    }
                   cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }else{//月
                cell.accessoryView = nil;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2f",self.viewModel.currentMonthInfo.info.money];
            }
        }
        
        return cell;
    }
    else
    {
        XYTrafficFeeCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYTrafficFeeCell defaultReuseId]];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:[XYTrafficFeeCell defaultReuseId] owner:self options:nil]lastObject];
        }
        XYMonthlyFeeDto* dto = [self.viewModel.currentMonthInfo.list objectAtIndex:indexPath.row];
        [cell setData:dto];
        
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }
    
    return [XYTrafficFeeCell defaultHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (self.segControl.selectedIndex == 0) {
        if (indexPath.section == 0 && indexPath.row == 1) {
            
                [self goToDayRecordList];//前往修改
            
        }
    }else if(self.segControl.selectedIndex == 1){
        if (indexPath.section ==1) {

            XYMonthlyFeeDto* dto = [self.viewModel.currentMonthInfo.list objectAtIndex:indexPath.row];
            [self goToMonthRecordList:dto.date];//前往修改
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
        }
    }else{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    
}

#pragma mark - action

-(void)onSegmentSelected
{
    if (self.segControl.selectedIndex == 0) {
        [self.tableView setTableHeaderView:self.dayHeaderView];
    }
    else{
        [self.tableView setTableHeaderView:self.monthHeaderView];
        [self getRecordOfMonth:self.monthHeaderView.chosenMonth+1 year:self.monthHeaderView.chosenYear];
    }
    
    [self.tableView reloadData];
}

-(void)goToDayRecordList
{
    XYTFCDailyInfo* info = [self.viewModel getFeeRecordOfDate:self.selectedDate];
    XYTrafficAddFeeViewController* trafficViewController = [[XYTrafficAddFeeViewController alloc]initWithEditable:info.edit date:[self.viewModel getFormattedDate:self.selectedDate]];
    trafficViewController.delegate = self;
    [self.navigationController pushViewController:trafficViewController animated:true];
}

-(void)goToMonthRecordList:(NSString*)date
{
    XYTrafficAddFeeViewController* trafficViewController = [[XYTrafficAddFeeViewController alloc]initWithEditable:false date:date];
    [self.navigationController pushViewController:trafficViewController animated:true];
}


-(void)getRecordOfDate:(NSDate*)date
{
    [self showLoadingMask];
    [_viewModel loadRecordOfDate:date forced:false];
}

-(void)getRecordOfMonth:(NSInteger)month year:(NSInteger)year
{
    [self showLoadingMask];
    [_viewModel loadRecordOfMonth:month year:year];
}

#pragma mark - call back

-(void)onDateTrafficRecordLoaded:(BOOL)isSuccess date:(NSDate*)date noteString:(NSString*)str
{
    [self hideLoadingMask];
    
    if (self.segControl.selectedIndex!=0 || ![date isEqualToDate:self.selectedDate]) {
        return;
    }
    
    if (isSuccess) {
        [self.tableView reloadData];
    }else{
        [self showToast:str];
    }
}


-(void)onMonthTrafficRecordLoaded:(BOOL)isSuccess month:(NSInteger)month year:(NSInteger)year noteString:(NSString*)str
{
    [self hideLoadingMask];
    
    if (self.segControl.selectedIndex!=1) {
        return;
    }
    
    if (isSuccess) {
        [self.tableView reloadData];
    }else{
        [self showToast:str];
    }
}

-(void)onXYTrafficEditFeesSuccess
{
    [self.viewModel loadRecordOfDate:self.selectedDate forced:true];
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
