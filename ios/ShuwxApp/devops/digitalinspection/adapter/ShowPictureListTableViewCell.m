//
//  ShowPictureListTableViewCell.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/18.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "ShowPictureListTableViewCell.h"
#import "YSPhotoBrowser.h"

static const CGFloat kPhotoViewMargin = 12.0;

@implementation ShowPictureListTableViewCell

-(NSMutableArray *)photoList{
    if (!_photoList) {
        _photoList = [NSMutableArray array];
    }
    return _photoList;
}


- (void)setFrame:(CGRect)frame {
    frame.size.height -= 1;    // 减掉的值就是分隔线的高度
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
      [self initView];
}

-(void)setUpdatePicList:(NSMutableArray *)nsmutableArray{
    HitPointViewController * hitPoint = (HitPointViewController *)_curViewController;
    for (NSMutableDictionary * picDic in nsmutableArray) {
       NSString * imageUrl =  [picDic objectForKey:@"image_url"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];
        NSString * myImageUrl = [hitPoint getPinjieNSString:pictureUrl :imageUrl];
        
        if ([myImageUrl containsString:@".mp4"] || [myImageUrl containsString:@".MP4"]) {
            HXPhotoModel * hxPhotoModel = [[HXPhotoModel alloc] init];
            hxPhotoModel.networkPhotoUrl = [NSURL URLWithString:myImageUrl];
            hxPhotoModel.livePhotoVideoURL = [NSURL URLWithString:myImageUrl];
            hxPhotoModel.videoURL = [NSURL URLWithString:myImageUrl];
                  [self.photoList addObject:hxPhotoModel];
        }else{
            HXPhotoModel * hxPhotoModel = [[HXPhotoModel alloc] init];
            hxPhotoModel.networkPhotoUrl = [NSURL URLWithString:myImageUrl];
                  [self.photoList addObject:hxPhotoModel];
        }
    }

    [hitPoint setNetWorkPic:self.photoList:self.photoView];

}

- (HXPhotoManager *)manager
{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.videoMaxNum = 5;
        _manager.configuration.type = HXConfigurationTypeWXChat;
        
        __weak typeof(self) weakSelf = self;
        
        // 使用自定义的相机  这里拿系统相机做示例
        _manager.configuration.shouldUseCamera = ^(UIViewController *viewController, HXPhotoConfigurationCameraType cameraType, HXPhotoManager *manager) {
            
            // 这里拿使用系统相机做例子
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = (id)weakSelf;
            imagePickerController.allowsEditing = NO;
            NSString *requiredMediaTypeImage = ( NSString *)kUTTypeImage;
            NSString *requiredMediaTypeMovie = ( NSString *)kUTTypeMovie;
            NSArray *arrMediaTypes;
            if (cameraType == HXPhotoConfigurationCameraTypePhoto) {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage,nil];
            }else if (cameraType == HXPhotoConfigurationCameraTypeVideo) {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeMovie,nil];
            }else {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage, requiredMediaTypeMovie,nil];
            }
            [imagePickerController setMediaTypes:arrMediaTypes];
            // 设置录制视频的质量
            [imagePickerController setVideoQuality:UIImagePickerControllerQualityTypeHigh];
            //设置最长摄像时间
            [imagePickerController setVideoMaximumDuration:15.f];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            imagePickerController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            [viewController presentViewController:imagePickerController animated:YES completion:nil];
        };
//        _manager.shouldSelectModel = ^NSString *(HXPhotoModel *model) {
//            // 如果return nil 则会走默认的判断是否达到最大值
//            //return nil;
//            return @"Demo1 116 - 120 行注释掉就能选啦~\(≧▽≦)/~";
//        };
        _manager.configuration.videoCanEdit = NO;
        _manager.configuration.photoCanEdit = NO;
    }
    return _manager;
}

-(void)setPhotoView{
    const CGFloat kPhotoViewMargin = 12.0;
    
    self.  photoView = [HXPhotoView photoManager:self.manager scrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.  photoView.frame = CGRectMake(0, 40, SCREEN_WIDTH, 110);
    self.   photoView.collectionView.contentInset = UIEdgeInsetsMake(0, kPhotoViewMargin, 0, kPhotoViewMargin);
//    photoView.spacing = kPhotoViewMargin;
//    photoView.lineCount = 1;
    self.  photoView.delegate = self;
    self.   photoView.hideDeleteButton = YES;
    self.   photoView.interceptAddCellClick = YES;
    self.   photoView.outerCamera = YES;
    self.   photoView.previewStyle = HXPhotoViewPreViewShowStyleDark;
    self.    photoView.previewShowDeleteButton = YES;
    self.   photoView.showAddCell = YES;
//    photoView.showDeleteNetworkPhotoAlert = YES;
//    photoView.adaptiveDarkness = NO;
//    photoView.previewShowBottomPageControl = NO;
    [ self.photoView.collectionView reloadData];
    [self.addPickView addSubview:self.photoView];
   
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initView{

    self.titleOne.layer.cornerRadius = _titleOne.frame.size.width / 2;
    self.titleOne.clipsToBounds = YES;
    self.titleOne.layer.borderWidth = 1;
    self.titleOne.layer.borderColor = [[UIColor colorWithRed:193.0/255.0 green:195.0/255.0 blue:255.0/225.0 alpha:1] CGColor];
    
     [self photoList];
    [self setPhotoView];
}


//  选择图片后回调
- (void)photoViewCurrentSelected:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    for (HXPhotoModel *photoModel in allList) {
        NSSLog(@"当前选择----> %@", photoModel.selectIndexStr);
        
    }
}
- (void)photoView:(HXPhotoView *)photoView currentDeleteModel:(HXPhotoModel *)model currentIndex:(NSInteger)index {
    NSSLog(@"%@ --> index - %ld",model,index);
}

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
   
}



@end
