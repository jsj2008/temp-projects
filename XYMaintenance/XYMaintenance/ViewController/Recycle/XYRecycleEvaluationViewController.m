//
//  XYRecycleEvaluationViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYRecycleEvaluationViewController.h"
#import "XYRecycleInputInfoViewController.h"
#import "PECell.h"
#import "PEHeaderView.h"

static NSString *const XYRecycleEvaluationCellIdentifier = @"XYRecycleEvaluationCellIdentifier";
static NSString *const XYRecycleEvaluationHeaderIdentifier = @"XYRecycleEvaluationHeaderIdentifier";
static NSString *const XYRecycleEvaluationFooterViewIdentifier = @"PEFooterView";

@interface XYRecycleEvaluationViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PEHeaderViewDelegate>
@property(strong,nonatomic)NSMutableArray* selectionsArray;
@property(strong,nonatomic)NSMutableDictionary<NSString*,NSMutableArray*>* resultMap;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation XYRecycleEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getSelections];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld context:NULL];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self.collectionView removeObserver:self forKeyPath:@"contentSize" context:NULL];
    [self.view endEditing:false];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary  *)change context:(void *)context{}

#pragma mark - override

- (void)initializeUIElements{
    self.navigationItem.title = @"机型属性";
    //UICollectionView
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = XY_HEX(0xefeff4);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PEHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[PEHeaderView defaultReuseId]];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:XYRecycleEvaluationFooterViewIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PECell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[PECell defaultReuseId]];
    
    self.progressBar.tintColor = THEME_COLOR;
    self.progressBar.progressTintColor = THEME_COLOR;
}

#pragma mark - collectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.selectionsArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    XYRecycleSelectionsDto* dto = [self.selectionsArray objectAtIndex:section];
    return dto.isExpanded?dto.detail_info.count:0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PECell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PECell defaultReuseId] forIndexPath:indexPath];
    XYRecycleSelectionsDto* dto = [self.selectionsArray objectAtIndex:indexPath.section];
    XYRecycleSelectionItem* item = [dto.detail_info objectAtIndex:indexPath.row];
    [cell setItemSelected:[self faultSelected:item.fault_id ofSelection:dto.attr_id]];
    cell.xyTitleLabel.text = item.name?item.name:@"";
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
        if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
            PEHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[PEHeaderView defaultReuseId] forIndexPath:indexPath];
            headerView.indexPath = indexPath;
            headerView.delegate = self;
            XYRecycleSelectionsDto* dto = [self.selectionsArray objectAtIndex:indexPath.section];
            [headerView setData:dto selected:self.resultMap[dto.attr_id]];
            return headerView;
        }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
            UICollectionReusableView *footer = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:XYRecycleEvaluationFooterViewIdentifier forIndexPath:indexPath];
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(15, 0, SCREEN_WIDTH - 30, LINE_HEIGHT);
            lineView.backgroundColor = XY_HEX(0xE2E6EE);
            [footer addSubview:lineView];
            return footer;
        }
    return [[UICollectionReusableView alloc]init];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    XYRecycleSelectionsDto* dto = [self.selectionsArray objectAtIndex:indexPath.section];
    XYRecycleSelectionItem* item = [dto.detail_info objectAtIndex:indexPath.row];
    if ([self faultSelected:item.fault_id ofSelection:dto.attr_id]) {
        [self deSelectFaultSelected:item.fault_id ofSelection:dto.attr_id];
    }else{
        [self setFaultSelected:item.fault_id ofSelection:dto.attr_id isMultiSelection:dto.option_type];
        dto.isExpanded = dto.option_type;
         //展开下一项(自己不是最后一项)
        if (indexPath.section != self.selectionsArray.count - 1) {
            XYRecycleSelectionsDto* nextItem = [self.selectionsArray objectAtIndex:indexPath.section+1];
            nextItem.isExpanded = true;
            //如果展开的这项是非必选项，则再展开一项
            if ((!nextItem.required) && indexPath.section + 1 != self.selectionsArray.count - 1) {
                XYRecycleSelectionsDto* nextNextItem = [self.selectionsArray objectAtIndex:indexPath.section+2];
                nextNextItem.isExpanded = true;
            }
        }
    }
    [self.collectionView reloadData];
    self.progressBar.progress = [self calculateProgress];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 50);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, LINE_HEIGHT);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    XYRecycleSelectionsDto* item = [self.selectionsArray objectAtIndex:section];
    return item.isExpanded?UIEdgeInsetsMake(0, 15, 18, 15):UIEdgeInsetsMake(0, 15, 0, 15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH - 15 * 3) / 2, 55);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

#pragma mark - PEHeaderViewDelegate
- (void)didClickButtonInHeaderView:(PEHeaderView *)headerView{
    XYRecycleSelectionsDto* dto = [self.selectionsArray objectAtIndex:headerView.indexPath.section];
    dto.isExpanded = !dto.isExpanded;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:headerView.indexPath.section]];
}

#pragma mark - property

- (NSMutableArray*)selectionsArray{
    if (!_selectionsArray) {
        _selectionsArray = [[NSMutableArray alloc]init];
    }
    return _selectionsArray;
}

- (NSMutableDictionary*)resultMap{
    if (!_resultMap) {
        _resultMap = [[NSMutableDictionary alloc]init];
    }
    return _resultMap;
}


#pragma mark - selection
//获取选中状态
- (BOOL)faultSelected:(NSString*)faultId ofSelection:(NSString*)attrId{
    if ((!faultId) || (!attrId)) {
        return false;
    }
    NSMutableArray* itemsArray = self.resultMap[attrId];
    if (!itemsArray) {
        return false;
    }
    for (NSString* itemStr in itemsArray) {
        if ([itemStr isEqualToString:faultId]) {
            return true;
        }
    }
    return false;
}
//选中
- (void)setFaultSelected:(NSString*)faultId ofSelection:(NSString*)attrId isMultiSelection:(BOOL)isMulti{
    if ((!faultId) || (!attrId)) {
        return;
    }
    NSMutableArray* itemsArray = self.resultMap[attrId];
    if (!itemsArray) {
        itemsArray = [[NSMutableArray alloc]init];
    }
    if (!isMulti) {
        [itemsArray removeAllObjects];
    }
    [itemsArray addObject:faultId];
    self.resultMap[attrId] = itemsArray;
}
//反选
- (void)deSelectFaultSelected:(NSString*)faultId ofSelection:(NSString*)attrId{
    if ((!faultId) || (!attrId)) {
        return;
    }
    NSMutableArray* itemsArray = self.resultMap[attrId];
    if (!itemsArray) {
        return;
    }
    for(NSString* str in itemsArray){
        if ([str isEqualToString:faultId]) {
            [itemsArray removeObject:str];
            return;
        }
    }
    self.resultMap[attrId] = itemsArray;
}

#pragma mark - action

- (CGFloat)calculateProgress{
        __block NSInteger finish = 0;
        __block NSInteger total = 0;
        [self.selectionsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XYRecycleSelectionsDto *item = (XYRecycleSelectionsDto *)obj;
            if (item.required) {
                total ++;
                if (self.resultMap[item.attr_id] && self.resultMap[item.attr_id].count>0) {
                    finish ++;
                }
            }
        }];
        if (total) {
            return (float)finish / (float)total;
        }else{
            return 0;
        }
    }

- (IBAction)sunmitEvaluation:(id)sender {
    
    //判断是否都已选
    TTDEBUGLOG(@"resultmap = %@",self.resultMap);
    for (XYRecycleSelectionsDto* dto in self.selectionsArray) {
        NSMutableArray* array = self.resultMap[dto.attr_id];
        if (dto.required &&((!array)||array.count <=0)) {
            [self showToast:@"请选择所有必选项"];
            return;
        }
    }

    [self getEstimatePrice];
}

- (void)getSelections{
    [self showLoadingMask];
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance] getRecycleSelectionsList:self.preOrderDetail.mould_id success:^(NSArray *selectionsList) {
        [weakself hideLoadingMask];
        weakself.selectionsArray = [[NSMutableArray alloc]initWithArray:selectionsList];
        [weakself fillPreSelections];
        [weakself.collectionView reloadData];
    } errorString:^(NSString *error) {
        [weakself hideLoadingMask];
        [weakself showToast:error];
    }];
}

- (void)fillPreSelections{
    
    //用预选项对resultMap初始化
    if(self.preOrderDetail.attr && self.preOrderDetail.attr.count > 0){
        for (NSString* preItem in self.preOrderDetail.attr) {
            for (XYRecycleSelectionsDto* dto in self.selectionsArray) {
                dto.isExpanded = true;
                for (XYRecycleSelectionItem* item in dto.detail_info) {
                    if ([item.fault_id isEqualToString:preItem]) {
                        [self setFaultSelected:item.fault_id ofSelection:dto.attr_id isMultiSelection:dto.option_type];
                    }
                }
            }
        }
    }else{
        //没有初始化
        if (self.selectionsArray && self.selectionsArray.count > 0) {
            XYRecycleSelectionsDto* dto = self.selectionsArray[0];
            dto.isExpanded = true;
            [self.selectionsArray replaceObjectAtIndex:0 withObject:dto];
        }
    }
    
}

- (void)getEstimatePrice{
    
    [self showLoadingMask];
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance] getEstimatePriceOfDevice:self.preOrderDetail.mould_id selections:[[self getResultArray] mj_JSONString] success:^(NSInteger price) {
        [weakself hideLoadingMask];
        [weakself goToNextPageWithPrice:price];
    } errorString:^(NSString *error) {
        [weakself hideLoadingMask];
        [weakself showToast:error];
    }];
    
}

- (void)goToNextPageWithPrice:(NSInteger)price{
    //组合选项json
    self.preOrderDetail.attrString = [[self getResultArray] mj_JSONString];
    //下一页
    XYRecycleInputInfoViewController* userInfoViewController = [[XYRecycleInputInfoViewController alloc]init];
    userInfoViewController.preOrderDetail = self.preOrderDetail;
    userInfoViewController.estimatePrice = price;
    [self.navigationController pushViewController:userInfoViewController animated:true];
}


- (NSArray*)getResultArray{
    NSMutableArray* array = [[NSMutableArray alloc]init];
    for (NSString* key in [self.resultMap allKeys]) {
        if (self.resultMap[key] && [self.resultMap[key] isKindOfClass:[NSMutableArray class]]) {
            [array addObjectsFromArray:self.resultMap[key]];
        }
    }
    return array;
}


#pragma mark - tableView


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.selectionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    XYRecycleSelectionsDto* dto = [self.selectionsArray objectAtIndex:section];
    return dto.detail_info.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:XYRecycleEvaluationCellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:XYRecycleEvaluationCellIdentifier];
        cell.textLabel.textColor = BLACK_COLOR;
        cell.textLabel.font = LARGE_TEXT_FONT;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.adjustsFontSizeToFitWidth = true;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    XYRecycleSelectionsDto* dto = [self.selectionsArray objectAtIndex:indexPath.section];
    XYRecycleSelectionItem* item = [dto.detail_info objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name?item.name:@"";
    cell.accessoryView = [self faultSelected:item.fault_id ofSelection:dto.attr_id]?[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_cancel_order"]]:nil;
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView* headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:XYRecycleEvaluationHeaderIdentifier];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:XYRecycleEvaluationHeaderIdentifier];
        headerView.contentView.backgroundColor = XY_COLOR(236, 240, 246);
        headerView.textLabel.font = SIMPLE_TEXT_FONT;
        headerView.textLabel.textColor = BLACK_COLOR;
    }
    XYRecycleSelectionsDto* dto = [self.selectionsArray objectAtIndex:section];
    headerView.textLabel.text = dto.name?dto.name:@"";
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    XYRecycleSelectionsDto* dto = [self.selectionsArray objectAtIndex:indexPath.section];
    XYRecycleSelectionItem* item = [dto.detail_info objectAtIndex:indexPath.row];
    if ([self faultSelected:item.fault_id ofSelection:dto.attr_id]) {
        [self deSelectFaultSelected:item.fault_id ofSelection:dto.attr_id];
    }else{
        [self setFaultSelected:item.fault_id ofSelection:dto.attr_id isMultiSelection:dto.option_type];
    }
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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
