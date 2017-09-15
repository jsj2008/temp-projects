//
//  XYTrafficAddFeeViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/24.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYTrafficAddFeeViewController.h"
#import "XYTrafficAddFeeViewModel.h"
#import "XYAddTrafficFeeCell.h"
#import "XYTrafficOrderListViewController.h"


@interface XYTrafficAddFeeViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,XYTrafficLocationDelegate,XYTrafficAddFeeCallBackDelegate,UITextFieldDelegate>
@property(strong,nonatomic)UITableView* tableView;
@property(strong,nonatomic)UIButton* confirmBtn;
@property(strong,nonatomic)UILabel* totalLabel;

@property(strong,nonatomic)XYTrafficAddFeeViewModel* viewModel;
@property(assign,nonatomic)BOOL isRecordEditable;
@property(strong,nonatomic)NSString* date;
@property(strong,nonatomic)XYTrafficOrderListViewController* orderListViewController;
@end

@implementation XYTrafficAddFeeViewController

-(id)initWithEditable:(BOOL)canEdit date:(NSString*)date{
    
    if (self = [super init]) {
        _isRecordEditable = canEdit;
        _date = [date copy];
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(xyKeyboardDidShow:)  name:UIKeyboardDidShowNotification  object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xyKeyboardDidHide)  name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [_viewModel cancelAllRequests];
    _viewModel.delegate = nil;
}

#pragma mark - override 
-(void)initializeModelBinding{
    self.viewModel = [[XYTrafficAddFeeViewModel alloc]init];
    self.viewModel.delegate = self;
}
-(void)initializeUIElements{
    
    self.navigationItem.title = self.isRecordEditable?@"添加交通费":@"查看交通费";
    [self shouldShowBackButton:true];
    self.navigationItem.rightBarButtonItem = self.isRecordEditable? [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"order_add"] style:UIBarButtonItemStylePlain target:self action:@selector(addRecord)]:nil;
    
    [self initTableView];
    [self initFooterView];
    [self loadFormerRecords];
}

#pragma mark - initUI

-(void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenFrameHeight - NAVI_BAR_HEIGHT-50)];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    [self.tableView setTableHeaderView:[XYWidgetUtil getSingleLineWithColor:XY_COLOR(210,218,228)]];
    [self.tableView setTableFooterView:[XYWidgetUtil getSingleLineWithColor:XY_COLOR(210,218,228)]];
    [self.view addSubview:self.tableView];
}

-(void)initFooterView{
    
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenFrameHeight - NAVI_BAR_HEIGHT - 50, ScreenWidth, 50)];
    footerView.backgroundColor = WHITE_COLOR;
    [footerView addSubview:[XYWidgetUtil getSingleLineWithColor:THEME_COLOR]];
    
    if (self.isRecordEditable) {
        self.confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-110,0, 110, 50)];
        self.confirmBtn.backgroundColor = THEME_COLOR;
        [self.confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:self.confirmBtn];
    }
    
    self.totalLabel = [[UILabel alloc]init];
    self.totalLabel.frame = CGRectMake(0, LINE_HEIGHT, self.isRecordEditable ?(ScreenWidth-110-15):ScreenWidth-15, 50);
    self.totalLabel.font = SIMPLE_TEXT_FONT;
    self.totalLabel.textColor = MOST_LIGHT_COLOR;
    self.totalLabel.textAlignment = NSTextAlignmentRight;
    [footerView addSubview:self.totalLabel];
    [self.view addSubview:footerView];
    
    [self recalculateTotalFees];
}

-(void)setTotalAmount:(CGFloat)amount
{
    self.totalLabel.attributedText = [XYStringUtil getAttributedStringFromString:[NSString stringWithFormat:@"合计：￥%.2f",amount] lightRange:[NSString stringWithFormat:@"￥%.2f",amount] lightColor:THEME_COLOR];
    [self.totalLabel sizeToFit];
    self.totalLabel.frame = CGRectMake(0, LINE_HEIGHT + (50 - self.totalLabel.frame.size.height)/2, self.isRecordEditable ?(ScreenWidth-110-15):ScreenWidth-15, self.totalLabel.frame.size.height);
}

#pragma mark - keyboard
- (void)xyKeyboardDidShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (self.tableView) {
        [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kbSize.height)]];
    }
}

-(void)xyKeyboardDidHide
{
    if (self.tableView) {
       [self.tableView setTableFooterView:[XYWidgetUtil getSingleLineWithColor:XY_COLOR(210,218,228)]];
    }
}
#pragma mark - tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.viewModel.editedRecordsArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYAddTrafficFeeCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYAddTrafficFeeCell defaultReuseId]];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:[XYAddTrafficFeeCell defaultReuseId] owner:self options:nil]lastObject];
        
        if (self.isRecordEditable) {
            NSMutableArray *rightUtilityButtons = [[NSMutableArray alloc]init];
            [rightUtilityButtons sw_addUtilityButtonWithColor:THEME_COLOR title:@"删除"];
            cell.rightUtilityButtons = rightUtilityButtons;
            cell.delegate = self;
            [cell.startBtn addTarget:self action:@selector(selectStartLoc:) forControlEvents:UIControlEventTouchUpInside];
            [cell.endBtn addTarget:self action:@selector(selectEndLoc:) forControlEvents:UIControlEventTouchUpInside];
            cell.feeTextField.delegate = self;
        }
        
        cell.startBtn.userInteractionEnabled = cell.endBtn.userInteractionEnabled = cell.feeTextField.userInteractionEnabled = self.isRecordEditable;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.startBtn.tag = indexPath.section;
    cell.endBtn.tag = indexPath.section;
    cell.feeTextField.tag = indexPath.section;
    cell.routeIdLabel.text = [NSString stringWithFormat:@"路\n线\n%ld",(long)indexPath.section];

    XYTrafficRecordDto* dto = [self.viewModel.editedRecordsArray objectAtIndex:indexPath.section];
    cell.startLabel.text = dto.start_point;
    cell.endLabel.text = dto.end_point;
    cell.feeTextField.text = [NSString stringWithFormat:@"￥%@",dto.fare];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [XYAddTrafficFeeCell defaultHeight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [XYWidgetUtil getSingleLineWithColor:XY_COLOR(210,218,228)];
    }
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    view.backgroundColor = BACKGROUND_COLOR;
    [view addSubview:[XYWidgetUtil getSingleLineWithColor:XY_COLOR(210,218,228)]];
    UIView* btLine = [XYWidgetUtil getSingleLineWithColor:XY_COLOR(210,218,228)];
    btLine.frame = CGRectMake(0, view.bounds.size.height-LINE_HEIGHT, ScreenWidth, LINE_HEIGHT);
    [view addSubview:btLine];
    return view;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 10;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
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


#pragma mark - swipe cell delegate

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    [cell hideUtilityButtonsAnimated:YES];
    [self.viewModel deleteItemOfIntex:[self.tableView indexPathForCell:cell].section];
    [self.tableView reloadData];
    [self recalculateTotalFees];
}

#pragma mark - textField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self recalculateTotalFees];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location == 0 && range.length == 1) {
        return NO;
    }

    NSCharacterSet *cs;
    NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
    if (NSNotFound == nDotLoc && 1 != range.location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERSDOT_ONLY] invertedSet];
    }else{
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
    }
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest){ return NO; }
    if (NSNotFound != nDotLoc && range.location > nDotLoc + 2){return NO;}
    
    [self.viewModel editFeeOfIndexItem:textField.tag into:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    return true;
}


#pragma mark - select loc

-(void)onLocationStrSelected:(NSString *)locString routeIndex:(NSInteger)section startOrEnd:(BOOL)isStart
{
    [self.navigationController popToViewController:self animated:true];
    self.navigationController.navigationBarHidden = false;
    [self.viewModel editLocOfIndexItem:section into:locString type:isStart];
    [self.tableView reloadData];
}

#pragma mark - action 

-(void)loadFormerRecords{
    [self showLoadingMask];
    self.navigationItem.rightBarButtonItem.enabled = false;
    [self.viewModel loadFormerRecords:self.date];
}

-(void)addRecord{
    [self.viewModel addNewItem];
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height-10, self.tableView.contentSize.width, 10) animated:true];
}

-(void)selectStartLoc:(UIButton*)btn{
    [self goToSelectLocation:btn.tag isStart:true];
}

-(void)selectEndLoc:(UIButton*)btn{
    [self goToSelectLocation:btn.tag isStart:false];
}

-(void)goToSelectLocation:(NSInteger)section isStart:(BOOL)isStart
{
    [self.view endEditing:false];
    if (!self.orderListViewController) {
        self.orderListViewController = [[XYTrafficOrderListViewController alloc]init];
        self.orderListViewController.delegate = self;
        self.orderListViewController.date = self.date;
    }
    self.orderListViewController.routeId = section;
    self.orderListViewController.isStartLoc = isStart;
    [self.navigationController pushViewController:self.orderListViewController animated:true];
}

-(void)confirmBtnClicked{
    [self.viewModel submitEditedRecords:self.date];
}

-(void)recalculateTotalFees{
    [self setTotalAmount:self.viewModel.totalFee];
}

#pragma mark - call back

-(void)onFormerRecordsLoaded:(BOOL)isSuccess noteString:(NSString*)str;
{
    [self hideLoadingMask];
    if (isSuccess) {
        if (self.isRecordEditable && self.viewModel.editedRecordsArray.count==0) {
            [self.viewModel addNewItem];
        }
        [self.tableView reloadData];
        [self recalculateTotalFees];
        self.navigationItem.rightBarButtonItem.enabled = true;
    }else{
        [self showToast:str];
    }
}

-(void)onOperationsSubmitted:(BOOL)isSuccess noteString:(NSString *)str
{
    [self hideLoadingMask];
    if (isSuccess) {
        [self.delegate onXYTrafficEditFeesSuccess];
        [self.navigationController popViewControllerAnimated:true];
    }else{
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
