//
//  DYMonthlyCalendarView.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/10/13.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "DYMonthlyCalendarView.h"
#import "DYMonthlyCalendarContentView.h"
#import "XYConfig.h"

@interface DYMonthlyCalendarView ()<DYMonthlyCollectionViewDelegate,UIScrollViewDelegate>
@property (strong,nonatomic)UIScrollView* scrollView;
@property (strong,nonatomic)NSMutableArray* contentViews;
@property (strong,nonatomic)UILabel* lastYearLabel;
@property (strong,nonatomic)UILabel* thisYearLabel;
@property (strong,nonatomic)UILabel* nextYearLabel;

@property (assign,nonatomic)NSInteger centerYear;
@end

@implementation DYMonthlyCalendarView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)]) {
        [self initializeUI];
    }

    return self;
}

- (void)initializeUI
{
    [self initializeScrollView];
    [self initializeTitleLabel];
    [self initializeContentViews];
    [self initializeDecorators];
}

-(void)initializeScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 10)];
    self.scrollView.backgroundColor = WHITE_COLOR;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*3, self.scrollView.bounds.size.height);
    self.scrollView.pagingEnabled = true;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    [self addSubview:self.scrollView];
}

-(void)initializeTitleLabel
{
    self.lastYearLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.bounds.size.width-20, 40)];
    self.lastYearLabel.font = [UIFont systemFontOfSize:25.0f];
    self.lastYearLabel.textColor = BLACK_COLOR;
    self.lastYearLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.lastYearLabel];
    
    self.thisYearLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width+20, 0, self.bounds.size.width-20, 40)];
    self.thisYearLabel.font = [UIFont systemFontOfSize:25.0f];
    self.thisYearLabel.textColor = BLACK_COLOR;
    self.thisYearLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.thisYearLabel];
    
    self.nextYearLabel = [[UILabel alloc]initWithFrame:CGRectMake(2*self.bounds.size.width+20, 0, self.bounds.size.width-20, 40)];
    self.nextYearLabel.font = [UIFont systemFontOfSize:25.0f];
    self.nextYearLabel.textColor = BLACK_COLOR;
    self.nextYearLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.nextYearLabel];
    
}

-(void)initializeContentViews
{
    self.contentViews = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i < 3; i ++) {
        UIView* dividerLine = [[UIView alloc]initWithFrame:CGRectMake(i*self.bounds.size.width+20, 40-LINE_HEIGHT, self.bounds.size.width-20,  LINE_HEIGHT)];
        dividerLine.backgroundColor = XY_COLOR(210,218,228);
        [self.scrollView addSubview:dividerLine];
        DYMonthlyCalendarContentView* monthView = [[DYMonthlyCalendarContentView alloc]initWithFrame:CGRectMake(i*self.bounds.size.width+20, 40 + 10 , self.bounds.size.width-30, self.bounds.size.height - 50 - 20)];
        monthView.collectionDelegate = self;
        monthView.tag = i;
        [self.scrollView addSubview:monthView];
        [self.contentViews addObject:monthView];
    }
}

-(void)initializeDecorators
{
    UIView* tpLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.scrollView.bounds.size.height, self.bounds.size.width, LINE_HEIGHT)];
    tpLine.backgroundColor = XY_COLOR(210,218,228);
    [self addSubview:tpLine];
    
    UIView* devider = [[UIView alloc]initWithFrame:CGRectMake(0, self.scrollView.bounds.size.height+LINE_HEIGHT, self.bounds.size.width, 10-2*LINE_HEIGHT)];
    devider.backgroundColor = BACKGROUND_COLOR;
    [self addSubview:devider];
    
    UIView* btLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height -LINE_HEIGHT, self.bounds.size.width, LINE_HEIGHT)];
    btLine.backgroundColor = XY_COLOR(210,218,228);
    [self addSubview:btLine];
}

-(void)setDefaultYear:(NSInteger)year andMonth:(NSInteger)month
{
    self.centerYear = year;
    self.chosenYear = year;
    self.chosenMonth = month;
    
    [self reloadTitleLabels];
    [self reloadCenterView:false];
}

#pragma mark - action

-(void)reloadTitleLabels
{
    self.lastYearLabel.text = [NSString stringWithFormat:@"%ld",(long)(self.centerYear-1)];
    self.thisYearLabel.text = [NSString stringWithFormat:@"%ld",(long)(self.centerYear)];
    self.nextYearLabel.text = [NSString stringWithFormat:@"%ld",(long)(self.centerYear+1)];
}

-(void)reloadCenterView:(BOOL)isClear
{
    for (DYMonthlyCalendarContentView* view in self.contentViews) {
        if (view.tag==1) {
            if (isClear) {
                view.selectedMonth = -1;
            }else{
                view.selectedMonth = self.chosenMonth;
            }
            [view reloadData];
        }
    }
}

#pragma mark - delegates

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.x < self.bounds.size.width) {
        self.centerYear--;
    }else if(self.scrollView.contentOffset.x > self.bounds.size.width){
        self.centerYear++;
    }else{
        return;
    }
    
    [self reloadTitleLabels];
    [self reloadCenterView:(self.chosenYear!=self.centerYear)];
    
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
}

- (void)monthView:(DYMonthlyCalendarContentView*)contentView selectMonth:(NSInteger)month
{
    self.chosenMonth = month;
    self.chosenYear = self.centerYear;
    [self.monthDelegate selectMonthOfYear:self.centerYear month:month];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
