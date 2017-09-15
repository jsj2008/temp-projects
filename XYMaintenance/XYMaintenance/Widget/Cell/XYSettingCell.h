//
//  XYSettingCell.h
//  XYHiRepairs
//
//  Created by DamocsYang on 15/10/29.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYSettingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *badgeView;

+ (NSString*)defaultReuseIdentifier;
+ (UINib*)defaultNib;
- (void)setBadgeNumber:(NSInteger)count hideNumber:(BOOL)shouldHideNumber;

@end
