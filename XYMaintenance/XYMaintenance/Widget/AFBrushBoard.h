//
//  AFBrushBoard.h
//  AFBrushBoard
//
//  Created by Ordinary on 16/3/24.
//  Copyright © 2016年 Ordinary. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  手写签名板，生成签名图片
 */

@interface AFBrushBoard : UIImageView

//更新UI（初始化）
- (void)updateUI;

//清空重写
- (void)cleanBtnDidClick;

@end
