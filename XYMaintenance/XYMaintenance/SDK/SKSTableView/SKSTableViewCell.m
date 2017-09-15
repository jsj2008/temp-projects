//
//  SKSTableViewCell.m
//  SKSTableView
//
//  Created by Sakkaras on 26/12/13.
//  Copyright (c) 2013 Sakkaras. All rights reserved.
//

#import "SKSTableViewCell.h"
#import <Masonry.h>

@interface SKSTableViewCell ()

@end

@implementation SKSTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.expandable = YES;
        self.expanded = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}

- (UIButton *)arrowButton {
    if (!_arrowButton) {
        _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowButton setBackgroundImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
        [self.contentView addSubview:_arrowButton];
        [_arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(11);
            make.width.mas_equalTo(11);
        }];
    }
    
    return _arrowButton;
}

static UIImage *_image = nil;
- (UIView *)expandableView
{
    if (!_image) {
        _image = [UIImage imageNamed:@"jiantou"];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(SCREEN_WIDTH-15-_image.size.width, 0.0, _image.size.width, _image.size.height);
    button.frame = frame;
    
    
    [button setBackgroundImage:_image forState:UIControlStateNormal];
    
    return button;
}

- (void)setExpandable:(BOOL)isExpandable {
    if (isExpandable) {
        self.arrowButton.hidden = NO;
    }else {
        self.arrowButton.hidden = YES;
    }
    
    _expandable = isExpandable;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


- (void)accessoryViewAnimation
{
    [UIView animateWithDuration:0.2 animations:^{
        if (self.isExpanded) {
            self.arrowButton.transform = CGAffineTransformMakeRotation(M_PI);
        } else {
            self.arrowButton.transform = CGAffineTransformMakeRotation(0);
        }
    } completion:^(BOOL finished) {}];
}

@end
