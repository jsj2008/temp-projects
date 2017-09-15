//
//  XYFaultTagsCell.h
//  XYMaintenance
//
//  Created by Kingnet on 16/10/9.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTagView.h"

@protocol XYFaultTagsCellDelegate <NSObject>
- (void)addFault;
- (void)removeFault:(NSString*)planId faultName:(NSString*)name;
@end

@interface XYFaultTagsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SKTagView *tagsView;
@property (assign, nonatomic) id<XYFaultTagsCellDelegate> delegate;
@property (strong,nonatomic) NSMutableArray* tagsArray;
- (void)setPlanIds:(NSString*)rp_id names:(NSString*)faultNames;//planid,name joined by ','
+ (NSString*)defaultReuseId;

@end
