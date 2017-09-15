//
//  DYMonthlyCalendarContentView.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/10/13.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DYMonthlyCalendarContentView;

@protocol DYMonthlyCollectionViewDelegate <NSObject>
@required
- (void)monthView:(DYMonthlyCalendarContentView*)contentView selectMonth:(NSInteger)month;//字面意义的年月
@end

@interface DYMonthlyCalendarContentView : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) id<DYMonthlyCollectionViewDelegate> collectionDelegate;
@property (nonatomic, assign) NSInteger selectedMonth;//0-11
@end
