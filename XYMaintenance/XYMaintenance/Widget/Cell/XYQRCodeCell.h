//
//  XYQRCodeCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/13.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTO.h"

@protocol XYQRCodeCellDelegate <NSObject>
- (void)getQrCodeOfType:(XYQRCodePayType)type;
@end

@interface XYQRCodeCell : UITableViewCell<UIScrollViewDelegate>

@property (assign,nonatomic) id<XYQRCodeCellDelegate> codeDelegate;
@property (assign,nonatomic) XYBrandType bid;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (CGFloat)defaultHeight;
+ (NSString*)defaultReuseId;

- (void)initAndAutoLoadQrCode:(XYBrandType)bid delegate:(id<XYQRCodeCellDelegate>)delegate;
- (NSInteger)startPageIndex;
- (void)setQRCode:(NSString*)code price:(NSString*)price type:(XYQRCodePayType)type bid:(XYBrandType)bid success:(BOOL)isSuccess;
- (void)resetQRCodes;

@end
