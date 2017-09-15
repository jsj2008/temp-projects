//
//  PEHeaderView.h
//  XYHiRepairs
//
//  Created by wuw on 16/5/18.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYRecycleSelectionsDto;
@class PEHeaderView;

/**
 *  回收估价选项
 */
@protocol PEHeaderViewDelegate <NSObject>
//展开/收起选项的回调
- (void)didClickButtonInHeaderView:(PEHeaderView *)headerView;
@end


@interface PEHeaderView : UICollectionReusableView

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<PEHeaderViewDelegate>delegate;

+ (NSString*)defaultReuseId;
//设置选项数据及选中信息
- (void)setData:(XYRecycleSelectionsDto*)data selected:(NSArray*)selectedIdArray;
@end
