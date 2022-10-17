//
//  ShowPictureListTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/18.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureItemCollectionViewCell.h"

#import "HXPhotoPicker.h"
#import "BaseNavigationController.h"
#import "HitPointViewController.h"
 #import "UIImageView+WebCache.h"

#import "YSPhotoBrowser.h"    

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ShowPictureListTableViewCell : UITableViewCell<HXPhotoViewDelegate,UIImagePickerControllerDelegate, HXPhotoViewCellCustomProtocol>{
 
           @public int temPosition;
}

@property (weak, nonatomic) IBOutlet UIView *titleOne;
@property (weak, nonatomic) IBOutlet UILabel *titleNumber;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (strong, nonatomic) NSMutableArray * photoList;
@property (strong, nonatomic) HXPhotoView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *isReqest;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) UIViewController * curViewController;
@property (strong, nonatomic) IBOutlet UIView *addPickView;
-(void)setUpdatePicList:(NSMutableArray *)nsmutableArray;

@end


