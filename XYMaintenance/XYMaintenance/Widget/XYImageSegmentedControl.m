//
//  HMSegmentedControl.m
//  HMSegmentedControlExample
//
//  Created by Hesham Abd-Elmegid on 23/12/12.
//  Copyright (c) 2012 Hesham Abd-Elmegid. All rights reserved.
//

#import "XYImageSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>

@interface XYImageSegmentedControl ()

@property (nonatomic, strong) CALayer *selectedSegmentLayer;
@property (nonatomic, readwrite) CGFloat segmentWidth;

@end

@implementation XYImageSegmentedControl

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

- (void)setDefaults {
    
    self.backgroundColor = [UIColor whiteColor];

    self.selectedIndex = 0;
    self.height = 32.0f;
    
    self.selectedSegmentLayer = [CALayer layer];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [self.backgroundColor set];
    
    UIRectFill([self bounds]);
    
    [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop)
    {
        UIImage* img;
        
        if (idx == self.selectedIndex){
            img = [UIImage imageNamed:[NSString stringWithFormat:@"%@_select",titleString]];
        }else{
            img = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",titleString]];
        }
        
        CGFloat xInset = (self.segmentWidth - img.size.width)/2;
        CGFloat y = (self.height - img.size.height) / 2;
        CGRect rect = CGRectMake(xInset + self.segmentWidth * idx, y, img.size.width, img.size.height);
        
        [img drawInRect:rect];
    }];
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
    
    NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
    self.selectedSegmentLayer.actions = newActions;
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
