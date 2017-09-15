//
//  PECell.h
//  XYHiRepairs
//
//  Created by wuw on 16/5/18.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  机型估价选项cell
 */

@interface PECell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *xyTitleLabel;

+ (NSString*)defaultReuseId;

//选中/反选
- (void)setItemSelected:(BOOL)selected;

@end
