//
//  PlanCell.h
//  XYHiRepairs
//
//  Created by zhoujl on 15/11/4.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanCell : UICollectionViewCell
@property (nonatomic,strong) PlanResult *plan;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
