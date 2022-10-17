//
//  PictureListTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/27.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureItemCollectionViewCell.h"
#import "HXPhotoPicker.h"
#import "BaseNavigationController.h"
#import "HitPointViewController.h"
 #import "UIImageView+WebCache.h"
#import "HitPointViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface PictureListTableViewCell : UITableViewCell<HXPhotoViewDelegate,UIImagePickerControllerDelegate, HXPhotoViewCellCustomProtocol>{
   
        @public int temPosition;
}

@property (weak, nonatomic) IBOutlet UIView *titleOne;
@property (weak, nonatomic) IBOutlet UILabel *titleNumber;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (strong, nonatomic) NSMutableArray * photoList;
@property (weak, nonatomic) IBOutlet UILabel *isReqest;

@property (nonatomic, weak) NSString * curPosition;
@property (weak, nonatomic) UIViewController * myViewController;

@property (strong, nonatomic) IBOutlet UIView *addPickView;
//@property (strong, nonatomic) HXPhotoView * photoView;
-(void)setListCell:(HXPhotoView *)photoView;
@end

