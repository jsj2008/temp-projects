//
//  XYAttendenceViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAttendenceViewController.h"
#import "HMSegmentedControl.h"
#import "XYLeaveViewController.h"
#import "XYGesturableScrollView.h"
#import "NSDate+DateTools.h"
#import "XYLeaveListCell.h"
#import "XYAttendenceCalenderCell.h"
#import "XYAttendanceDetailView.h"

@interface XYAttendenceViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,XYTableViewWebDelegate,XYLeaveViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//UI
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *usedDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveDaysLabel;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segControl;
@property (strong,nonatomic) XYGesturableScrollView* scrollView;
@property (strong,nonatomic) UICollectionView* myAttendenceListView;
@property (strong,nonatomic) XYBaseTableView* myLeaveListView;

//data
@property (assign, nonatomic)NSInteger year; //当前展示年份
@property (assign, nonatomic)NSInteger month; //当前展示月份

@property (strong, nonatomic)NSArray* dateTitlesArray;
@property (assign, nonatomic)NSDate* selectedDate;//当前选定日期
@property (strong, nonatomic)NSMutableArray* datesArray;//当前展示月份的日期列表
@property (strong, nonatomic)NSArray<XYAttendanceDto*>* attendanceArray;//当前展示月份的数据

@end

@implementation XYAttendenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateMonthLabelAndRefreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override 

- (void)initializeData{
    NSDate* date = [NSDate date];
    self.year = [date year];
    self.month = [date month];
}

- (void)initializeUIElements{
    
    self.navigationItem.title = @"考勤中心";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"请假" style:UIBarButtonItemStylePlain target:self action:@selector(askForLeave)];
    
    self.view.backgroundColor = BACKGROUND_COLOR;//XY_HEX(0xeef0f3);
    self.segControl.sectionTitles = @[@"我的考勤",@"请假申请记录"];
    self.segControl.selectedIndex = 0;
    self.segControl.selectionIndicatorMode = HMSelectionIndicatorResizesToStringWidth;
    [self.segControl addTarget:self action:@selector(switchTableView:) forControlEvents:UIControlEventValueChanged];

    [self.scrollView addSubview:self.myAttendenceListView];
    [self.scrollView addSubview:self.myLeaveListView];
    [self.view addSubview:self.scrollView];
    
    self.usedDaysLabel.textColor = THEME_COLOR;
    self.leaveDaysLabel.textColor = THEME_COLOR;
}

#pragma mark - property

- (NSMutableArray*)datesArray{
    if (!_datesArray) {
        _datesArray = [[NSMutableArray alloc]init];
    }
    return _datesArray;
}

- (NSArray*)attendanceArray{
    if (!_attendanceArray) {
        _attendanceArray = [[NSArray alloc]init];
    }
    return _attendanceArray;
}

- (NSArray*)dateTitlesArray{
    if (!_dateTitlesArray) {
        _dateTitlesArray = [NSMutableArray arrayWithArray:@[@"一",@"二",@"三",@"四",@"五",@"六",@"七"]];
    }
    return _dateTitlesArray;
}

- (UIScrollView*)scrollView{
    if (!_scrollView) {
        CGFloat scrollableHeight = SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT - 210;
        _scrollView = [[XYGesturableScrollView alloc]initWithFrame:CGRectMake(0, 210, SCREEN_WIDTH, scrollableHeight)];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, self.scrollView.frame.size.height);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = true;
        _scrollView.bounces = false;
        _scrollView.scrollEnabled = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.backgroundColor = [UIColor yellowColor];
    }
    return _scrollView;
}

- (UICollectionView*)myAttendenceListView{
    if (!_myAttendenceListView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing=0.f;//左右间隔
        flowLayout.minimumLineSpacing=0.f;
        _myAttendenceListView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height) collectionViewLayout:flowLayout];
        _myAttendenceListView.backgroundColor = WHITE_COLOR;
        _myAttendenceListView.tag = 0;
        _myAttendenceListView.showsVerticalScrollIndicator = true;
        _myAttendenceListView.delegate = self;
        _myAttendenceListView.dataSource = self;
        [_myAttendenceListView registerNib:[UINib nibWithNibName:[XYAttendenceCalenderCell defaultReuseId] bundle:nil] forCellWithReuseIdentifier:[XYAttendenceCalenderCell defaultReuseId]];
        [_myAttendenceListView registerNib:[UINib nibWithNibName:[XYAttendanceDetailView defaultReuseId] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[XYAttendanceDetailView defaultReuseId]];
    }
    return _myAttendenceListView;
}

- (XYBaseTableView*)myLeaveListView{
    if (!_myLeaveListView) {
        _myLeaveListView = [[XYBaseTableView alloc]initWithFrame:CGRectMake(self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
        _myLeaveListView.backgroundColor = [UIColor whiteColor];
        _myLeaveListView.tag = 1;
        _myLeaveListView.delegate = self;
        _myLeaveListView.dataSource = self;
        _myLeaveListView.webDelegate = self;
        _myLeaveListView.showsVerticalScrollIndicator = true;
        [_myLeaveListView setTableFooterView:[[UIView alloc]init]];
        [_myLeaveListView setTableHeaderView:[[UIView alloc]init]];
        [XYLeaveListCell xy_registerTableView:_myLeaveListView identifier:[XYLeaveListCell defaultReuseId]];
    }
    return _myLeaveListView;
}

- (void)switchTableView:(HMSegmentedControl*)seg{
    [self.scrollView setContentOffset:CGPointMake(seg.selectedIndex*self.scrollView.bounds.size.width, 0) animated:false];
    [self showLoadingMask];
    switch (seg.selectedIndex) {
        case 0:
            [self prepareDaysOfCurrentMonth];
            [self getAttendenceList];
            break;
        case 1:
            [self getLeaveList];
            break;
        default:
            break;
    }
    if ([self isThisMonth:self.month year:self.year]) {
        [self getDaysStatics];
    }
}

#pragma mark - tableView

- (void)tableView:(XYBaseTableView*)tableView loadData:(NSInteger)p{
    switch (tableView.tag) {
        case 1:
            [self getLeaveList];
            break;
        default:
            break;
    }
    if ([self isThisMonth:self.month year:self.year]) {
        [self getDaysStatics];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isKindOfClass:[XYBaseTableView class]]) {
        return [((XYBaseTableView*)tableView).dataList count];
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isKindOfClass:[XYBaseTableView class]]) {
        NSArray* dataList = ((XYBaseTableView*)tableView).dataList;
        if (tableView.tag == 1){
            XYLeaveListCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYLeaveListCell defaultReuseId]];
            [cell.actionButton addTarget:self action:@selector(expandAndFold:) forControlEvents:UIControlEventTouchUpInside];
            cell.actionButton.tag = indexPath.row;
            XYLeaveDto* dto = [dataList objectAtIndex:indexPath.row];
            [cell setLeaveData:dto];
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isKindOfClass:[XYBaseTableView class]]) {
        switch (tableView.tag) {
            case 1:
            {
                XYLeaveDto* dto = [self.myLeaveListView.dataList objectAtIndex:indexPath.row];
                return dto.isExpanded?[XYLeaveListCell defaultHeight]:[XYLeaveListCell foldedHeight];
            }
                break;
            default:
                break;
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - collectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return (self.selectedDate != nil) ? 3:2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 7;
        case 1:
            return [self getNumbersOfItemsInUpSection:true];
        case 2:
            return [self getNumbersOfItemsInUpSection:false];
        default:
            break;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XYAttendenceCalenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[XYAttendenceCalenderCell defaultReuseId] forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell setTitle:self.dateTitlesArray[indexPath.row]];
    }else{
        NSDate* cellDate = [self getDateByIndexPath:indexPath];
        [cell setDate:cellDate.day isThisMonth:(cellDate.month == self.month) isAbsence:![self getAttendanceOfDate:cellDate] isLeave:[self getLeaveOfDate:cellDate] isSelected:[cellDate isSameDay:self.selectedDate]];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        if(indexPath.section == 2){
            XYAttendanceDetailView *headerView = [self.myAttendenceListView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[XYAttendanceDetailView defaultReuseId] forIndexPath:indexPath];
            [headerView setAttendanceData:[self getAttendanceDataOfDate:self.selectedDate]];
            return headerView;
        }
    }
    return [[UICollectionReusableView alloc]init];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDate* date = [self getDateByIndexPath:indexPath];
    if(date.month != self.month){
        return;//不是当前月份，不能展示！
    }
    self.selectedDate = date;
    [self.myAttendenceListView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return CGSizeMake(SCREEN_WIDTH, 40);
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/7, 54);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


#pragma mark - action

- (void)expandAndFold:(UIButton*)btn{
    XYLeaveDto* dto = [self.myLeaveListView.dataList objectAtIndex:btn.tag];
    dto.isExpanded = !dto.isExpanded;
    [self.myLeaveListView reloadData];
}

- (BOOL)isThisMonth:(NSInteger)month year:(NSInteger)year{
    NSDate* date = [NSDate date];
    return ([date year] == year) && ([date month] == month) ;
}

- (void)askForLeave{
    XYLeaveViewController* leaveViewController = [[XYLeaveViewController alloc]init];
    leaveViewController.delegate = self;
    [self.navigationController pushViewController:leaveViewController animated:true];
}

- (void)updateMonthLabelAndRefreshData{
    self.monthLabel.text = [NSString stringWithFormat:@"%@ 年 %@ 月",@(self.year),@(self.month)];
    [self showLoadingMask];
    switch (self.segControl.selectedIndex) {
        case 0:
            [self prepareDaysOfCurrentMonth];//修改日历
            [self getAttendenceList];
            break;
        case 1:
            [self getLeaveList];
            break;
        default:
            break;
    }
    
    if ([self isThisMonth:self.month year:self.year]) {
        [self getDaysStatics];
    }
}

- (IBAction)nextMonth:(id)sender {
    self.month += 1;
    if (self.month > 12) {
        self.month = self.month-12;
        self.year += 1;
    }
    [self updateMonthLabelAndRefreshData];
}

- (IBAction)preMonth:(id)sender {
    self.month -= 1;
    if (self.month < 1) {
        self.month = self.month+12;
        self.year -= 1;
    }
    [self updateMonthLabelAndRefreshData];
}

#pragma mark - delegate 

- (void)onLeaveApplicationSubmitted{
    [self getDaysStatics];
    [self.myLeaveListView refresh];
}

#pragma mark - request

- (void)getDaysStatics{
    //固定本月的
    NSDate* date = [NSDate date];
    NSInteger year = [date year];
    NSInteger month = [date month];
    __weak typeof(self) weakSelf = self;
    [[XYAPIService shareInstance]getAttendenceStaticis:[NSString stringWithFormat:@"%@%02ld",@(year),(long)month] success:^(NSInteger holidays,NSInteger leavedays) {
        weakSelf.usedDaysLabel.text = [NSString stringWithFormat:@"%@天",@(holidays)];
        weakSelf.leaveDaysLabel.text = [NSString stringWithFormat:@"%@天",@(leavedays)];
    } errorString:^(NSString *err) {
        [weakSelf showToast:err];
    }];
}

- (void)prepareDaysOfCurrentMonth{
    
    self.selectedDate = nil;//更换月份时，重置已选日期
    
    NSDate* firstDay = [NSDate dateWithYear:self.year month:self.month day:1];
    NSInteger numberOfWeeks = [NSDate numberOfWeeks:firstDay];
    NSDate* firstListDay = [NSDate firstWeekDayOfWeek:firstDay];
    [self.datesArray removeAllObjects];
    for(NSInteger i = 0; i < numberOfWeeks; i++){
        for (NSInteger j = 0; j < 7; j++){
            [self.datesArray addObject:[firstListDay dateByAddingDays:i*7+j]];
        }
    }
    [self.myAttendenceListView reloadData];
}

- (NSInteger)getNumbersOfItemsInUpSection:(BOOL)isTop{//上下半区各有几个item
    
    if (!self.selectedDate) {
        return isTop?self.datesArray.count:0;
    }
    
    for(NSInteger i = 0 ; i < self.datesArray.count; i++){
        NSDate* lineDate = self.datesArray[i];
        if ([lineDate isSameDay:self.selectedDate]) {
            NSInteger topLines = (i+1)/7 + (((i+1)%7==0)?0:1);
            return isTop?topLines*7:(self.datesArray.count - topLines*7);
        }
    }
    return 0;
}

- (NSDate*)getDateByIndexPath:(NSIndexPath*)path{
    
    if (path.section == 0) {
        return nil;
    }
    NSInteger index = -1;
    if (path.section == 1) {//上半区
        index = path.row;
    }else if(path.section == 2){//下半区
        NSInteger numbers = [self getNumbersOfItemsInUpSection:true];
        index = numbers + path.row;
    }
    
    if (index < 0 || index >= self.datesArray.count) {
        return nil;
    }
    
    return [self.datesArray objectAtIndex:index];
}

- (XYAttendanceDto*)getAttendanceDataOfDate:(NSDate*)date{
    NSString* formattedStr = [date formattedDateWithFormat:@"yyyy-MM-dd"];
    for (XYAttendanceDto* dto in self.attendanceArray){
        if ([dto.create_at isEqualToString:formattedStr]){
            return dto;
        }
    }
    return nil;
}

- (BOOL)getAttendanceOfDate:(NSDate*)date{
    XYAttendanceDto* dto = [self getAttendanceDataOfDate:date];
    if (dto) {
        if (dto.online_at > 0.5) {
            return true;//有上班时间，没缺席
        }else{
            if ((dto.status == XYAttendenceTypeAbsence)||(dto.status == XYAttendenceTypeHoliday)) {
                if (dto.leave_status != XYLeaveReviewTypeApproved) {
                    return false;
                }
            }
        }
    }
    return true;//默认都是有上班？否则很难看，，
}

- (BOOL)getLeaveOfDate:(NSDate*)date{
    XYAttendanceDto* dto = [self getAttendanceDataOfDate:date];
    if (dto) {
        if (dto.online_at > 0.5) {
            return false;//有上班时间，没请假
        }else{
            if ((dto.status == XYAttendenceTypeAbsence)||(dto.status == XYAttendenceTypeHoliday)) {
                if (dto.leave_status == XYLeaveReviewTypeApproved) {
                    return true;
                }
            }
        }
    }
    return false;//默认都是没请假的
}

#pragma mark - web

- (void)getAttendenceList{
    __weak typeof(self) weakSelf = self;
    [[XYAPIService shareInstance]getAttendenceList:[NSString stringWithFormat:@"%@%02ld",@(self.year),(long)self.month] success:^(NSArray<XYAttendanceDto *> *resultList) {
        weakSelf.attendanceArray = resultList;
        [weakSelf.myAttendenceListView reloadData];
        [weakSelf hideLoadingMask];
    } errorString:^(NSString *err) {
        weakSelf.attendanceArray = nil;
        [weakSelf.myAttendenceListView reloadData];
        [weakSelf hideLoadingMask];
        [weakSelf showToast:err];
    }];
}

- (void)getLeaveList{
    __weak typeof(self) weakSelf = self;
    [[XYAPIService shareInstance]getLeaveList:[NSString stringWithFormat:@"%@%02ld",@(self.year),(long)self.month] success:^(NSArray<XYLeaveDto *> *resultList) {
        [weakSelf hideLoadingMask];
        [weakSelf.myLeaveListView addListItems:resultList isRefresh:true withTotalCount:[resultList count]];
    } errorString:^(NSString *err) {
        [weakSelf hideLoadingMask];
        [weakSelf.myLeaveListView onLoadingFailed];
        [weakSelf.myLeaveListView resetAll];
        [weakSelf showToast:err];
    }];
}


#pragma mark - public action

- (void)refreshLeaveList{
    [self getDaysStatics];
    [self.myLeaveListView refresh];
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
