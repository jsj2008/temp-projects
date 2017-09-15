//
//  XYPartListTableView.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/23.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYPartListTableView.h"
#import "XYPartCell.h"
#import "XYPartClaimCell.h"
#import "XYPartsFlowCell.h"
#import "UITableViewCell+XYTableViewRegister.h"
#import "XYConfig.h"
#import "XYPartApplyLogCell.h"

@interface XYPartListTableView ()
{
    UIView* _partListEmptyView;
}
@end

@implementation XYPartListTableView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.dataSource = self;
        self.delegate = self;
        self.type = XYPartListViewTypeUnknown;
    }
    return self;
}

- (void)setType:(XYPartListViewType)type{
    _type = type;
    switch (type) {
        case XYPartListViewTypeMyParts:
            [XYPartCell xy_registerTableView:self identifier:[XYPartCell defaultReuseId]];
            break;
        case XYPartListViewTypeClaimRecords:
            [XYPartClaimCell xy_registerTableView:self identifier:[XYPartClaimCell defaultIdentifier]];
            break;
        case XYPartListViewTypePartsFlow:
            [XYPartsFlowCell xy_registerTableView:self identifier:[XYPartsFlowCell defaultReuseId]];
            break;
        case XYPartListViewTypePartsApplyLog:
            [XYPartApplyLogCell xy_registerTableView:self identifier:[XYPartApplyLogCell defaultReuseId]];
            break;
        case XYPartListViewTypeUnknown:
            break;
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList count] ;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case XYPartListViewTypeMyParts:
            return [self getMyPartsListCell:indexPath];
            break;
        case XYPartListViewTypePartsApplyLog:
            return [self getApplyRecordCell:indexPath];
            break;
        case XYPartListViewTypeClaimRecords:
            return [self getClaimRecordsCell:indexPath];
            break;
        case XYPartListViewTypePartsFlow:
            return [self getFlowCell:indexPath];
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case XYPartListViewTypeMyParts:
            return [XYPartCell defaultHeight];
            break;
        case XYPartListViewTypePartsApplyLog:
            return [XYPartApplyLogCell defaultHeight];
            break;
        case XYPartListViewTypeClaimRecords:
        {
            XYPartRecordDto* dto = [self.dataList objectAtIndex:indexPath.row];
            return [XYPartClaimCell getHeight:dto.is_receive];
        }
            break;
        case XYPartListViewTypePartsFlow:
            return [XYPartsFlowCell defaultHeight];
        default:
            return 0;
            break;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if(self.type == XYPartListViewTypeClaimRecords){
        XYPartRecordDto* dto = [self.dataList objectAtIndex:indexPath.row];
       [self.partListViewDelegate goToClaimRecordDetail:dto];
    }
    if(self.type == XYPartListViewTypePartsApplyLog){
        XYPartsApplyLogDto* dto = [self.dataList objectAtIndex:indexPath.row];
        [self.partListViewDelegate goToApplyRecordVc:dto];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - cell

- (XYPartCell*)getMyPartsListCell:(NSIndexPath*)indexPath{
    XYPartCell* cell = [self dequeueReusableCellWithIdentifier:[XYPartCell defaultReuseId]];
    [cell setListData:[self.dataList objectAtIndex:indexPath.row]];
    return cell;
}

- (XYPartApplyLogCell*)getApplyRecordCell:(NSIndexPath*)indexPath{
    XYPartApplyLogCell* cell = [self dequeueReusableCellWithIdentifier:[XYPartApplyLogCell defaultReuseId]];
    [cell setData:[self.dataList objectAtIndex:indexPath.row]];
    cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    return cell;
}

- (XYPartsFlowCell*)getFlowCell:(NSIndexPath*)indexPath{
    XYPartsFlowCell* cell = [self dequeueReusableCellWithIdentifier:[XYPartsFlowCell defaultReuseId]];
    [cell setData:[self.dataList objectAtIndex:indexPath.row]];
    return cell;
}

- (XYPartClaimCell*)getClaimRecordsCell:(NSIndexPath*)indexPath{
    XYPartClaimCell* cell = [self dequeueReusableCellWithIdentifier:[XYPartClaimCell defaultIdentifier]];
    [cell.confirmButton addTarget:self action:@selector(confirmClaim:) forControlEvents:UIControlEventTouchUpInside];
    [cell setData:[self.dataList objectAtIndex:indexPath.row]];
    cell.confirmButton.tag = indexPath.row;
    return cell;
}

#pragma mark - action 

- (void)confirmClaim:(UIButton*)btn{
    XYPartRecordDto* dto = [self.dataList objectAtIndex:btn.tag];
    [self.partListViewDelegate confirmClaimRecord:dto.id bid:dto.bid];
}

- (UIView*)emptyView{
    if(self.type==XYPartListViewTypePartsFlow){
        if (!_partListEmptyView){
            _partListEmptyView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableHeaderView.bounds.size.height, self.bounds.size.width, self.bounds.size.height - self.tableHeaderView.bounds.size.height)];
            _partListEmptyView.backgroundColor = [UIColor whiteColor];
            UILabel* noteLabel = [[UILabel alloc]init];
            noteLabel.textColor = THEME_COLOR;
            noteLabel.font = SIMPLE_TEXT_FONT;
            noteLabel.text = @"暂无搜索结果";
            CGSize size = [noteLabel.text sizeWithAttributes:@{NSFontAttributeName:SIMPLE_TEXT_FONT}];
            noteLabel.frame = CGRectMake((self.bounds.size.width - size.width)/2, (_partListEmptyView.bounds.size.height - size.height)/2, size.width, size.height);
            [_partListEmptyView addSubview:noteLabel];
        }
        return _partListEmptyView;
    }
    return [super emptyView];
}


@end
