//
//  MultilevelCollectionViewCell.h
//  XYHiRepairs
//
//  Created by lisd on 16/7/17.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTO.h"

@interface MultilevelCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *leftLineView;

+ (NSString*)defaultReuseId;
- (void)setData:(XYRecycleDeviceDto*)dto;

@end
