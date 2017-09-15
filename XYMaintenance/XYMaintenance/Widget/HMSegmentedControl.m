//
//  HMSegmentedControl.m
//  HMSegmentedControlExample
//
//  Created by Hesham Abd-Elmegid on 23/12/12.
//  Copyright (c) 2012 Hesham Abd-Elmegid. All rights reserved.
//

#import "HMSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>
#import "XYConfig.h"

@interface HMSegmentedControl ()

@property (nonatomic, strong) CALayer *selectedSegmentLayer;
@property (nonatomic, strong) CALayer *underLineLayer;
@property (nonatomic, readwrite) CGFloat segmentWidth;

@end

@implementation HMSegmentedControl

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
        self.sectionTitles = @[@""];
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults {
    
    self.redSpotStates = [self generateRedSpotsStatesFromSection:self.sectionTitles];
    
    self.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15.0f];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.selectionIndicatorColor = THEME_COLOR;
    
    self.selectedIndex = 0;
    self.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.height = 43.0f;
    self.selectionIndicatorHeight = 2 * LINE_HEIGHT;
    self.selectionIndicatorMode = HMSelectionIndicatorFillsSegment;
    
    self.selectedSegmentLayer = [CALayer layer];
    self.underLineLayer = [CALayer layer];
}

- (NSMutableArray*)generateRedSpotsStatesFromSection:(NSArray *)sectiontitles{
    NSMutableArray* redSpotsArray = [[NSMutableArray alloc]init];
    for (NSInteger i=0; i < [sectiontitles count]; i++ ) {
        [redSpotsArray addObject:@(false)];
    }
    return redSpotsArray;
}

#pragma mark - property

//- (NSArray*)sectionTitles{
//    if (!_sectionTitles) {
//        _sectionTitles = [[NSArray alloc]init];
//    }
//    return _sectionTitles;
//}
//

- (NSMutableArray*)redSpotStates{
    if (!_redSpotStates) {
        _redSpotStates = [self generateRedSpotsStatesFromSection:self.sectionTitles];;
    }
    return _redSpotStates;
}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect{
    
    [self.backgroundColor set];
    UIRectFill([self bounds]);
    
    [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop){
        CGFloat stringHeight = [titleString sizeWithAttributes:@{NSFontAttributeName:self.font}].height;
        CGFloat stringWidth = [titleString sizeWithAttributes:@{NSFontAttributeName:self.font}].width;
        CGFloat y = ((self.height - self.selectionIndicatorHeight) / 2) + (self.selectionIndicatorHeight - stringHeight / 2);
        CGRect rect = CGRectMake(self.segmentWidth * idx, y, self.segmentWidth, stringHeight);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, (idx == self.selectedIndex) ? THEME_COLOR.CGColor : LIGHT_TEXT_COLOR.CGColor);
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByClipping];
        [style setAlignment:NSTextAlignmentCenter];
        NSDictionary *attributes = @{NSFontAttributeName: self.font, NSParagraphStyleAttributeName: style,NSForegroundColorAttributeName:(idx == self.selectedIndex) ? THEME_COLOR : LIGHT_TEXT_COLOR};
        [titleString drawInRect:rect withAttributes:attributes];
        
        if ([self.redSpotStates count] > idx) {
            BOOL isAlerted = [self.redSpotStates[idx] boolValue];
            if (isAlerted) {
                UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x + (rect.size.width + stringWidth)/2 + 2 , rect.origin.y - 3.5, 7, 7) cornerRadius:3.5];
                [XY_HEX(0xff4b4b) setFill];
                [roundedRect fillWithBlendMode:kCGBlendModeNormal alpha:1];
            }
        }
    }];
    
    self.underLineLayer.frame = CGRectMake(0, self.height - LINE_HEIGHT, self.frame.size.width, LINE_HEIGHT);
    self.underLineLayer.backgroundColor = DEVIDE_LINE_COLOR.CGColor;
    [self.layer addSublayer:self.underLineLayer];
    self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
    self.selectedSegmentLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
    [self.layer addSublayer:self.selectedSegmentLayer];
    
}

- (CGRect)frameForSelectionIndicator{
    
    CGFloat stringWidth = [[self.sectionTitles objectAtIndex:self.selectedIndex] sizeWithAttributes:@{NSFontAttributeName:self.font}].width;
    
    if (self.selectionIndicatorMode == HMSelectionIndicatorResizesToStringWidth) {
        CGFloat widthTillEndOfSelectedIndex = (self.segmentWidth * self.selectedIndex) + self.segmentWidth;
        CGFloat widthTillBeforeSelectedIndex = (self.segmentWidth * self.selectedIndex);
        
        CGFloat x = ((widthTillEndOfSelectedIndex - widthTillBeforeSelectedIndex) / 2) + (widthTillBeforeSelectedIndex - stringWidth / 2);
        return CGRectMake(x, self.height - self.selectionIndicatorHeight, stringWidth, self.selectionIndicatorHeight);
    } else {
        return CGRectMake(self.segmentWidth * self.selectedIndex, self.height - self.selectionIndicatorHeight, self.segmentWidth, self.selectionIndicatorHeight);
    }
}

- (void)updateSegmentsRects {
    // If there's no frame set, calculate the width of the control based on the number of segments and their size
    if (CGRectIsEmpty(self.frame)) {
        self.segmentWidth = 0;
        
        for (NSString *titleString in self.sectionTitles) {
            CGFloat stringWidth = [titleString sizeWithAttributes:@{NSFontAttributeName:self.font}].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            self.segmentWidth = MAX(stringWidth, self.segmentWidth);
        }
        
        self.bounds = CGRectMake(0, 0, self.segmentWidth * self.sectionTitles.count, self.height);
    } else {
        self.segmentWidth = self.frame.size.width / self.sectionTitles.count;
        self.height = self.frame.size.height;
    }
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
            [self setRedSpot:false forIndex:segment];
        }
    }
}

#pragma mark -

- (void)setSelectedIndex:(NSInteger)index {
    [self setSelectedIndex:index animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated{
    
    _selectedIndex = index;
    
    if (animated) {
        // Restore CALayer animations
        self.selectedSegmentLayer.actions = nil;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.15f];
        [CATransaction setCompletionBlock:^{
            if (self.superview)
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            
            if (self.indexChangeBlock)
                self.indexChangeBlock(index);
        }];
        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        [CATransaction commit];
    } else {
        // Disable CALayer animations
        NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
        self.selectedSegmentLayer.actions = newActions;
        
        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        
        if (self.superview)
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        
        if (self.indexChangeBlock)
            self.indexChangeBlock(index);

    }
    
    [self setNeedsDisplay];
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

- (void)setSectionTitle:(NSString*)title forIndex:(NSUInteger)index
{
    NSMutableArray* mutableArray = [[NSMutableArray alloc]initWithArray:self.sectionTitles];
    if (index < mutableArray.count) {
        [mutableArray replaceObjectAtIndex:index withObject:title];
        self.sectionTitles = mutableArray;
        [self setNeedsDisplay];
    }
}

- (void)setRedSpot:(BOOL)showRedSpot forIndex:(NSUInteger)index{
    if (index < self.redSpotStates.count) {
        [self.redSpotStates replaceObjectAtIndex:index withObject:@(showRedSpot)];
        [self setNeedsDisplay];
    }
}


@end
