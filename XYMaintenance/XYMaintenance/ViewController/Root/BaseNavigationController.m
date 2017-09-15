//
//  BaseNavigationController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/26.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "BaseNavigationController.h"

@implementation XYBaseNavigationController

- (void)loadView{
    [super loadView];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = true;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.viewControllers.count <= 1){
        return NO;
    }else{
        return YES;
    }
}


- (void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed{
    [super setHidesBottomBarWhenPushed:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (self.viewControllers.count > 0 ) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
    
    if (self.viewControllers.count >= 1){
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = YES;
            UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onLeftButtonClicked)];
            viewController.navigationItem.leftBarButtonItem = backItem;
        }
    }
}

-(void)onLeftButtonClicked{
    if ((!self.viewControllers)||[self.viewControllers count]==0) {
        return;
    }
    if ([self.topViewController respondsToSelector:@selector(goBack)]) {
        [self.topViewController performSelector:@selector(goBack)];
    }
}



//- (void)backClick:(BackBarbuttonItem *)backItem
//{
//    [backItem.vc.navigationController popViewControllerAnimated:YES];
//}

@end
