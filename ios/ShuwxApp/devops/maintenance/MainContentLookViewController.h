//
//  MainContentLookViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/8/20.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "HXPhotoPicker.h"
#import "BaseNavigationController.h"
 #import "UIImageView+WebCache.h"
#import "OperateStepViewController.h"

@interface MainContentLookViewController : MainViewController

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (strong,nonatomic) NSString * order_id;
@property (strong,nonatomic) NSString * content_in_id;
@property (strong,nonatomic) NSString * content_id;
@property (strong,nonatomic) NSMutableDictionary * orderJson;
@property (strong,nonatomic) NSString * is_image;
@property (strong,nonatomic) NSString * content;
@property (strong, nonatomic) UIView *linearOneUiView;
@property (strong, nonatomic) UIView *picListView;
@property (strong, nonatomic) IBOutlet UIView *allView;

@property (strong, nonatomic) IBOutlet UIView *weibRecordView;
@property (strong, nonatomic) IBOutlet UIView *weibPicView;
@property (strong,nonatomic) NSMutableArray * selectArray;

@property (strong, nonatomic) NSMutableArray * photoList;
@property (strong, nonatomic) NSMutableArray * netPhotoList;

@property (strong, nonatomic) IBOutlet UIButton *operateButton;
@property (strong, nonatomic) IBOutlet UILabel *weibContent;
@property (strong, nonatomic) IBOutlet UITextView *weibRecord;

@property (strong, nonatomic) NSMutableArray * spareList;

@property (strong, nonatomic) IBOutlet UIButton *upPicTitBtn;
@property (strong, nonatomic) HXPhotoView *photoView;

@end

