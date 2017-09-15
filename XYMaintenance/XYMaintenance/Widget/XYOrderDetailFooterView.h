//
//  XYOrderDetailFooterView.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/25.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYCommentView.h"

@interface XYOrderDetailFooterView : UIView

@property (weak, nonatomic) IBOutlet XYCommentView *commentView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;

+(instancetype)getFooterView;
-(void)setComment:(BOOL)isComment content:(XYPHPCommentDto*)comment;
-(void)resetButtons;

@end
