//
//  XYBaseTableView.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/28.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYBaseTableView;

@protocol XYTableViewWebDelegate <NSObject> //回调，

- (void)tableView:(XYBaseTableView*)tableView loadData:(NSInteger)p; // 从哪一页开始拿数据， 如果是refresh就传0

@end


/**
 *  长列表式TableView专用基类 自组织 管理下拉上拉分页 数据更新
 */
@interface XYBaseTableView : UITableView

@property(assign,nonatomic,readonly) NSInteger nextStartIndex;   //下一页
@property(assign,nonatomic,readonly) NSInteger totalCount;     //总页数

@property(assign,nonatomic) id<XYTableViewWebDelegate> webDelegate;//通常是所在viewController
@property(strong,nonatomic,readonly) NSMutableArray* dataList;//

@property(strong,nonatomic) UIView* emptyView;

- (void)enableDragToRefresh:(BOOL)enable; //是否开启下拉刷新 默认开启

- (void)refresh;        //刷新tableView
- (void)loadMore;

- (void)addListItems:(NSArray*)items isRefresh:(BOOL)isRefresh withTotalCount:(NSInteger)count;  //网络获取的列表项加入
- (void)setDataList:(NSMutableArray*)array totalItems:(NSInteger)count;
- (void)replaceObjectWith:(id)obj atIndex:(NSInteger)index;

- (void)showEmptyView;
- (void)removeEmptyView;

- (void)onLoadingFailed;

- (void)insertListItem:(id)item atIndex:(NSInteger)index;

- (void)removeListItem:(id)item;

- (void)resetAll;

@end
