//
//  LookRepairViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/11/25.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "BaseConst.h"
#import <UMCommon/MobClick.h>
#import "FSTextView.h"
#import "PictureItemCollectionViewCell.h"
#import "OrderTypeViewController.h"
#import "RepairTargetViewController.h"
#import "AlarmTypeListViewController.h"
#import "HXPhotoPicker.h"
#import "BaseNavigationController.h"
 #import "UIImageView+WebCache.h"

@interface LookRepairViewController : MainViewController<HXAlbumListViewControllerDelegate>{
    UINib *_personNib;
   int myType ;
}
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableDictionary * cellIdentifierDic;
@property (strong, nonatomic) IBOutlet UIButton *orderTypeBtn;
@property (strong, nonatomic) IBOutlet FSTextView *mbTextView;
@property (strong, nonatomic) IBOutlet UIButton *bxmbBtn;
@property (strong, nonatomic) IBOutlet UIView *addPicView;
//@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) NSMutableArray * photoList;
@property (strong, nonatomic) NSMutableArray * fileNameList;

@property (strong, nonatomic) NSString * order_id;

@property (strong, nonatomic) IBOutlet UIButton *alarmTypeBtn;

@property (strong, nonatomic) IBOutlet UILabel *zdTextValue;

@property (strong, nonatomic) IBOutlet UIScrollView *allScrollView;

@end

