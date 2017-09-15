//
//  XYPersonalEvaluationViewController.m
//  XYMaintenance
//
//  Created by lisd on 2017/5/2.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPersonalEvaluationViewController.h"
#import "XYEvaluationStarCountCell.h"
#import "XYEvaluationReturnVisitCell.h"
#import "XYEvaluationUserCell.h"
#import "XYAPIService+V11API.h"
#import "XYEvaluationDto.h"

static NSString * const kXYEvaluationStarCountCell = @"XYEvaluationStarCountCell";
static NSString * const kXYEvaluationReturnVisitCell = @"XYEvaluationReturnVisitCell";
static NSString * const kXYEvaluationUserCell = @"XYEvaluationUserCell";
@interface XYPersonalEvaluationViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) XYEvaluationDto *evaluationDto;

@end

@implementation XYPersonalEvaluationViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评价";
    [self initTableView];
    [self loadData];
}


#pragma mark - InitUI
- (void)initTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:kXYEvaluationStarCountCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kXYEvaluationStarCountCell];
    [self.tableView registerNib:[UINib nibWithNibName:kXYEvaluationReturnVisitCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kXYEvaluationReturnVisitCell];
    [self.tableView registerNib:[UINib nibWithNibName:kXYEvaluationUserCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kXYEvaluationUserCell];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
        {
            XYEvaluationReturnVisitCell *returnVisitCell = [tableView dequeueReusableCellWithIdentifier:kXYEvaluationReturnVisitCell];
            returnVisitCell.evaluationDto = self.evaluationDto;
            cell = returnVisitCell;
        }
            break;
        case 1:
        {
            XYEvaluationUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:kXYEvaluationUserCell];
            userCell.evaluationDto = self.evaluationDto;
            cell = userCell;
        }
            break;
            
        default:
        {
            XYEvaluationStarCountCell *starCountCell = [tableView dequeueReusableCellWithIdentifier:kXYEvaluationStarCountCell];
            starCountCell.starTitleLabel.text = [self getStarTitle:indexPath];
            self.evaluationDto.row = indexPath.row;
            starCountCell.evaluationDto = self.evaluationDto;
            cell = starCountCell;
        }
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 105;
            break;
        case 1:
            return 75;
            break;
            
        default:
            return 40;
            break;
    }
    return 0;
}

#pragma mark - Private methods
- (void)loadData {
    __weak __typeof(self)weakSelf = self;
    [[XYAPIService shareInstance] getEvaluationInfoWithAccount:nil success:^(XYEvaluationDto *evaluationDto) {
        self.evaluationDto = evaluationDto;
        [weakSelf.tableView reloadData];
    } errorString:^(NSString *err) {
        [self showToast:err];
    }];
}

- (NSString *)getStarTitle:(NSIndexPath*)indexPath {
    NSString *title;
    switch (indexPath.row) {
        case 2:
            title = @"五星";
            break;
        case 3:
            title = @"四星";
            break;
        case 4:
            title = @"三星";
            break;
        case 5:
            title = @"二星";
            break;
        case 6:
            title = @"一星";
            break;
        default:
            break;
    }
    return title;
}

@end
