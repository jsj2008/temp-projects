//
//  XYSimpleSegmentedControl.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/10/10.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYSimpleSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>
#import "XYConfig.h"

@implementation XYSimpleSegmentedControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */
- (id)initWithFrame:(CGRect)frame {
     self = [super initWithFrame:frame];
     
     if (self) {
         [self setDefaults];
     }
     
     return self;
 }

- (id)initWithSectionTitles:(NSArray *)sectiontitles {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.sectionTitles = sectiontitles;
        [self setDefaults];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
       [self setDefaults];
    }
    return self;
}

- (void)setDefaults {
    
    self.backgroundColor = [UIColor whiteColor];
    self.font = [UIFont systemFontOfSize:18.0];
    self.selectedIndex = 0;
    self.height = 32.0f;
    self.underLineLayer = [CALayer layer];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    if(!self.sectionTitles){
        return;
    }
    
    [self.backgroundColor set];
    
    UIRectFill([self bounds]);
    
    [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop)
     {
         if(idx == self.selectedIndex){[self.backgroundColor set]; }else{[XY_COLOR(244,246,248) set];}
         UIRectFill(CGRectMake(self.segmentWidth * idx, 0, self.segmentWidth, self.frame.size.height));
         
         CGFloat stringHeight = [titleString sizeWithAttributes:@{NSFontAttributeName:self.font}].height;
         CGFloat y = (self.height- stringHeight) / 2;
         CGRect rect = CGRectMake(self.segmentWidth * idx, y, self.segmentWidth, stringHeight);
         NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
         [style setLineBreakMode:NSLineBreakByClipping];
         [style setAlignment:NSTextAlignmentCenter];
         NSDictionary *attributes = @{NSFontAttributeName: self.font, NSParagraphStyleAttributeName: style,NSForegroundColorAttributeName:(idx == self.selectedIndex) ? THEME_COLOR : LIGHT_TEXT_COLOR,NSBackgroundColorAttributeName:(idx == self.selectedIndex) ? WHITE_COLOR : XY_COLOR(244,246,248)};
         [titleString drawInRect:rect withAttributes:attributes];
     }];
    
    self.underLineLayer.frame = CGRectMake(0, self.height - LINE_HEIGHT, self.frame.size.width, LINE_HEIGHT);
    self.underLineLayer.backgroundColor = DEVIDE_LINE_COLOR.CGColor;
    [self.layer addSublayer:self.underLineLayer];
    
}

- (void)updateSegmentsRects {
    // If there's no frame set, calculate the width of the control based on the number of segments and their size
    self.segmentWidth = self.frame.size.width / self.sectionTitles.count;
    self.height = self.frame.size.height;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // Control is being removed
    if (newSuperview == nil)
        return;
    
    [self updateSegmentsRects];
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        NSInteger segment = touchLocation.x / self.segmentWidth;
        
        if (segment != self.selectedIndex) {
            [self setSelectedIndex:segment animated:YES];
        }
    }
}

#pragma mark -

- (void)setSelectedIndex:(NSInteger)index {
    [self setSelectedIndex:index animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated {
    _selectedIndex = index;
    [self setNeedsDisplay];
    
    if (self.superview)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if (self.indexChangeBlock)
        self.indexChangeBlock(index);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (self.sectionTitles)
        [self updateSegmentsRects];
    
    [self setNeedsDisplay];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    if (self.sectionTitles)
        [self updateSegmentsRects];
    
    [self setNeedsDisplay];
}

@end
