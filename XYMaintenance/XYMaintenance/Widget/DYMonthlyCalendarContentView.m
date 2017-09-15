//
//  DYMonthlyCalendarContentView.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/10/13.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "DYMonthlyCalendarContentView.h"
#import "DYMonthlyCell.h"
#import "XYConfig.h"

@implementation DYMonthlyCalendarContentView

- (id)initWithFrame:(CGRect)frame
{
        
    if (self = [super initWithFrame:frame collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]]) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self setDataSource:self];
        [self setDelegate:self];
        
        [self registerClass:[DYMonthlyCell class] forCellWithReuseIdentifier:[DYMonthlyCell defaultReuseId]];
        
        self.selectedMonth = -1;
    }
    return self;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DYMonthlyCell *cell = (DYMonthlyCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[DYMonthlyCell defaultReuseId] forIndexPath:indexPath];

    [cell setTitle:[NSString stringWithFormat:@"%ld月",(long)(indexPath.section* 4 + indexPath.row+1)]];
    
    if ((indexPath.section* 4 + indexPath.row)==self.selectedMonth) {
        cell.monthLabel.backgroundColor = THEME_COLOR;
        cell.monthLabel.textColor = WHITE_COLOR;
    }else{
        cell.monthLabel.backgroundColor = WHITE_COLOR;
        cell.monthLabel.textColor = THEME_COLOR;
    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedMonth = indexPath.section* 4 + indexPath.row;
    [self reloadData];
    [self.collectionDelegate monthView:self selectMonth:self.selectedMonth];
}

#pragma mark - UICollectionView Delegate FlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize sizeOfCell = CGSizeMake((collectionView.bounds.size.width-50)/4,(collectionView.bounds.size.height-20)/3);
    return sizeOfCell;
}



//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 0.;
//}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
