//
//  XYBaseTableView.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/28.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseTableView.h"
#import "MJRefresh.h"
#import "XYConfig.h"
#import "XYRefreshLegendHeader.h"

#define XY_TABLEVIEW_SIZE 20  //分页的列表 每页cell条数


@interface XYBaseTableView (){
     NSMutableArray* _mutableDataList;
}
@end


@implementation XYBaseTableView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self preInitializeData];
        [self setUpAppearance];
    }
    
    return self;
}

- (void)preInitializeData{
    _mutableDataList = [[NSMutableArray alloc]init];
    _nextStartIndex = 0;
    _totalCount = 0;
}

- (UIView*)getSingleLine{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,LINE_HEIGHT)];
    view.backgroundColor = TABLE_DEVIDER_COLOR;
    return view;
}

- (void)setUpAppearance{
    self.backgroundColor = BACKGROUND_COLOR;
    self.separatorColor = TABLE_DEVIDER_COLOR;
    [self setTableHeaderView:[self getSingleLine]];
    [self setTableFooterView:[self getSingleLine]];
    [self addXYHeaderWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    [self addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMore)];

    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)refresh{
   if(self.webDelegate!=nil){
       [self.webDelegate tableView:self loadData:[self getPageFromNextIndex:0]];
   }
}

- (void)loadMore{
    if(self.webDelegate!=nil){
        [self.webDelegate tableView:self loadData:[self getPageFromNextIndex:self.nextStartIndex]];
    }
}

- (void)addListItems:(NSArray*)items isRefresh:(BOOL)isRefresh withTotalCount:(NSInteger)count
{
    _totalCount = count;
    
    if (isRefresh){
        [_mutableDataList removeAllObjects];
    }
    
    [_mutableDataList addObjectsFromArray:items];
    _nextStartIndex = [_mutableDataList count];
    
    [self reloadData];
}

- (void)setDataList:(NSMutableArray*)array totalItems:(NSInteger)count{
    [self addListItems:array isRefresh:true withTotalCount:count];
}

- (void)replaceObjectWith:(id)obj atIndex:(NSInteger)index{
    
    if ((!obj) || index >= _mutableDataList.count || index < 0) {
        return;
    }
    
    [_mutableDataList replaceObjectAtIndex:index withObject:obj];
}

- (void)onLoadingFailed{
    [self.xyHeader endRefreshing];
    [self.legendFooter endRefreshing];
    self.legendFooter.hidden = ![self canLoadMore];
}

- (void)insertListItem:(id)item atIndex:(NSInteger)index
{
    if (item && _mutableDataList)
    {
        [_mutableDataList insertObject:item atIndex:index];
    }
    
    _nextStartIndex = [_mutableDataList count];
}

- (void)removeListItem:(id)item
{
    if (item && _mutableDataList)
    {
        [_mutableDataList removeObject:item];
    }
    
    _totalCount -= 1;
    _nextStartIndex = [_mutableDataList count];
}

- (void)resetAll
{
    if (_mutableDataList)
    {
        [_mutableDataList removeAllObjects];
    }
    
    _nextStartIndex = 0;
    _totalCount = 0;
    
    [self reloadData];
}

- (BOOL)canLoadMore{
    return  self.nextStartIndex < self.totalCount;
}

- (void)reloadData
{
    [super reloadData];
    [self.xyHeader endRefreshing];
    [self.legendFooter endRefreshing];
     self.legendFooter.hidden = ![self canLoadMore];
    if ([self.dataList count]>0)
    {
        [self removeEmptyView];
    }
    else
    {
        [self showEmptyView];
    }
}

- (void)enableDragToRefresh:(BOOL)enable;
{
    self.xyHeader.hidden = !enable;
}

- (NSMutableArray*)dataList{
    return _mutableDataList;
}

- (NSInteger)getPageFromNextIndex:(NSInteger)nextIndex
{
    if (nextIndex == 0) {
        return 1;
    }
    
    TTDEBUGLOG(@"load page = %ld",(long)(1 + nextIndex/XY_TABLEVIEW_SIZE + (nextIndex%XY_TABLEVIEW_SIZE!=0)));
    
    return 1 + nextIndex/XY_TABLEVIEW_SIZE + (nextIndex%XY_TABLEVIEW_SIZE!=0);
   // return 1 + ceil(nextIndex/XY_TABLEVIEW_SIZE);
}

- (void)showEmptyView{
    if (self.emptyView.superview==nil) {
        [self addSubview:[self emptyView]];
    }
}

- (void)removeEmptyView{
    [self.emptyView removeFromSuperview];
    self.emptyView = nil;
}


- (UIView *)emptyView{
    return [[UIView alloc]init];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
