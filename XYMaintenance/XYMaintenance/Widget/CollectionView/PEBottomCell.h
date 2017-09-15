//
//  PEBottomCell.h
//  XYHiRepairs
//
//  Created by wuw on 16/5/18.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PEBottomCell;
@protocol PEBottomCellDelegate <NSObject>

- (void)didClickEvaluationButton;

@end
@interface PEBottomCell : UICollectionViewCell
@property (nonatomic, weak) id<PEBottomCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *evaluationButton;
@end
