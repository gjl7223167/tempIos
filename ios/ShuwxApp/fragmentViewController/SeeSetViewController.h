//
//  SeeSetViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/11/10.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"

@interface SeeSetViewController : MainViewController{
@public int pmTempInt;
}

@property (strong, nonatomic) IBOutlet UIView *hpView;
@property (strong, nonatomic) IBOutlet UIView *spView;
@property (strong, nonatomic) IBOutlet UIView *zyView;


@property (strong, nonatomic) IBOutlet UIImageView *hpImgSelect;
@property (strong, nonatomic) IBOutlet UIImageView *spImgSelect;
@property (strong, nonatomic) IBOutlet UIImageView *zyImgSelect;


@property (strong, nonatomic) IBOutlet UIView *allView;
@property (strong, nonatomic) IBOutlet UIView *twoView;


@end

