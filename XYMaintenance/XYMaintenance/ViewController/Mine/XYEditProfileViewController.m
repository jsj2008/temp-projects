//
//  XYEditProfileViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/12/29.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYEditProfileViewController.h"
#import "XYEditProfileViewModel.h"
#import "UIImageView+WebCache.h"

@interface XYEditProfileViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)XYEditProfileViewModel* viewModel;
@property(nonatomic,strong)UIActionSheet* actionSheet;
@property(nonatomic,strong)UIImageView* avatarView;
@end

@implementation XYEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.actionSheet = nil;
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

#pragma mark - override

- (void)initializeModelBinding{
    self.viewModel = [[XYEditProfileViewModel alloc]init];
}

- (void)initializeUIElements{
    
   self.navigationItem.title = @"个人信息";
   [self.view addSubview:self.tableView];
}

#pragma mark - property

- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [XYWidgetUtil getSimpleTableView:CGRectMake(0, 0, ScreenWidth, ScreenFrameHeight - NAVI_BAR_HEIGHT)];
        _tableView.separatorColor = TABLE_DEVIDER_COLOR;
        _tableView.backgroundColor = XY_COLOR(238,240,243);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableHeaderView:nil];
        [_tableView setTableFooterView:[XYWidgetUtil getSingleLine]];
    }
    return _tableView;
}

- (UIActionSheet*)actionSheet{
    if (!_actionSheet) {
        _actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",nil];
    }
    return _actionSheet;
}

- (UIImageView*)avatarView{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
        [_avatarView sd_setImageWithURL:[NSURL URLWithString:[XYAPPSingleton sharedInstance].currentUser.Url] placeholderImage:[UIImage imageNamed:@"img_avatar"] options:SDWebImageHighPriority];
    }
    return _avatarView;
}

#pragma mark - tableView

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifer = @"XYEditProfileCellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifer];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"头像";
            cell.detailTextLabel.text = @"";
            cell.accessoryView = self.avatarView;
            break;
        case 1:
            cell.textLabel.text = @"联系方式";
            cell.detailTextLabel.text = @"";
            cell.accessoryView = nil;
            break;
        case 2:
            cell.textLabel.text = @"名字";
            cell.detailTextLabel.text = [XYAPPSingleton sharedInstance].currentUser.Name;
            cell.accessoryView = nil;
            break;
        case 3:
            cell.textLabel.text = @"工号";
            cell.detailTextLabel.text = [XYAPPSingleton sharedInstance].currentUser.Id;
            cell.accessoryView = nil;
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    if (indexPath.row==0) {
        [self.actionSheet showFromTabBar:self.tabBarController.tabBar];
    }else if (indexPath.row == 1){
        //。。。改名字
    }
}

#pragma mark - photo

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0 || buttonIndex == 1){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        if(buttonIndex == 0){
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }else{
                [self showToast:@"设备不支持拍照"];
                return;
            }
        }else if(buttonIndex == 1){
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }else{
                return;
            }
        }
        [self presentViewController:picker animated:true completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:true completion:^{
        UIImage* image=[info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp){
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];//可以改大小
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        [self.viewModel editAvatar:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:true completion:nil];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
