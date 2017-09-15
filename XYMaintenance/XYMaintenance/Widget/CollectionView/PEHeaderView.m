//
//  PEHeaderView.m
//  XYHiRepairs
//
//  Created by wuw on 16/5/18.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "PEHeaderView.h"
#import "XYConfig.h"
#import "DTO.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
static CGFloat const titleLabelDefaultWidth = 70;
static CGFloat const titleLabelMaxWidth = 150;
@interface PEHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;
@property (weak, nonatomic) IBOutlet UILabel *modifyLabel;
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelWidth;
@end

@implementation PEHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString*)defaultReuseId{
    return @"PEHeaderView";
}

- (void)setData:(XYRecycleSelectionsDto*)data selected:(NSArray*)selectedIdArray{
    self.headerBtn.enabled = true;
    self.titleLabel.textColor = BLACK_COLOR;
    if ((!selectedIdArray )|| (selectedIdArray.count == 0)) {
        //没有选择内容
        self.arrowView.hidden = YES;
        self.modifyLabel.hidden = YES;
        self.descLabel.hidden = YES;
    }else{
        if (data.isExpanded) {
            //展开
            self.arrowView.hidden = NO;
            self.modifyLabel.hidden = NO;
            self.descLabel.hidden = YES;
            [self rotateArrowView:false];
        }else{
            //收起
            self.arrowView.hidden = NO;
            self.modifyLabel.hidden = NO;
            self.descLabel.hidden = NO;
            [self rotateArrowView:true];
            self.descLabel.text = @"";
            for (XYRecycleSelectionItem* item in data.detail_info) {
                for (NSString* selectedId in selectedIdArray) {
                    if ([item.fault_id isEqualToString:selectedId]) {
                        self.descLabel.text = [self.descLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@ ",item.name]];
                    }
                }
            }
        }
    }
    
    if (!data.option_type) {
        self.titleLabel.text = data.name;
        self.titleLabelWidth.constant = titleLabelDefaultWidth;
        self.headerBtn.enabled = YES;
    }else{
        self.titleLabelWidth.constant = titleLabelMaxWidth;
        self.titleLabel.text = data.name;
        self.headerBtn.enabled = NO;
    }
}

- (IBAction)clickAction:(id)sender {
    WS(weakSelf);
    if ([self.delegate respondsToSelector:@selector(didClickButtonInHeaderView:)]) {
        [self.delegate didClickButtonInHeaderView:weakSelf];
    }
}

- (void)rotateArrowView:(BOOL)isReverse{
    [UIView animateWithDuration:0.6 animations:^{
        CATransform3D transfrom = CATransform3DIdentity;
        self.arrowView.layer.transform = CATransform3DRotate(transfrom, (isReverse?1:-1) * 180.0 / 360.0 * 2 * M_PI, 0, 0, 1);
    }];
}

@end
