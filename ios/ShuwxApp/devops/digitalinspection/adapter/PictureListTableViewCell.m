//
//  PictureListTableViewCell.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/27.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "PictureListTableViewCell.h"
#import "YSPhotoBrowser.h"

//static const CGFloat kPhotoViewMargin = 12.0;

@implementation PictureListTableViewCell

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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setListCell:(HXPhotoView *)photoView{
    photoView.delegate = self;
}

-(void)initView{

    self.titleOne.layer.cornerRadius = self.titleOne.frame.size.width / 2;
    self.titleOne.clipsToBounds = YES;
    self.titleOne.layer.borderWidth = 1;
    self.titleOne.layer.borderColor = [[UIColor colorWithRed:193.0/255.0 green:195.0/255.0 blue:225.0/255.0 alpha:1] CGColor];

     [self photoList];
 
   
}

//  选择图片后回调
- (void)photoViewCurrentSelected:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
//    if (allList.count >0) {
      
//    }
  
}
- (void)photoView:(HXPhotoView *)photoView currentDeleteModel:(HXPhotoModel *)model currentIndex:(NSInteger)index {
    NSSLog(@"%@ --> index - %ld",model,index);
}

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    
    [self.photoList removeAllObjects];
    for(HXPhotoModel * photoModel in allList){
        PHAssetResource * resource = [[PHAssetResource assetResourcesForAsset:photoModel.asset] firstObject];
        NSString * tempFilename = resource.originalFilename;
        if (photoModel.subType == HXPhotoModelMediaSubTypePhoto) {
          UIImage * myImage =  photoModel.previewPhoto;
            [self saveImageAndVideo:myImage:tempFilename];
        }else{
            NSString *tempPrivateFileURL = [resource valueForKey:@"privateFileURL"];
            NSSLog(@"videocount----%@",tempPrivateFileURL);
//            NSSLog(@"videocount----%@",tempFilename);
            if (nil != tempPrivateFileURL) {
                [self.photoList addObject:tempPrivateFileURL];
            }
        }
       
    }
    HitPointViewController * hitPoint = (HitPointViewController *)_myViewController;
    [hitPoint.myValue setObject:self.photoList forKey:self.curPosition];
    
//    HitPointViewController * hitPoint = (HitPointViewController *)_myViewController;
//    [hitPoint setPhotoAndVideoList:allList :self.photoList];
//    [hitPoint.myValue setObject:self.photoList forKey:self.curPosition];
//    NSLog(@"videocount---%d",self.photoList.count);
}

- (void)saveImageAndVideo:(UIImage*)image:(NSString *)fileNmae {

NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString*filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:fileNmae]];// 保存文件的名称

BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath  atomically:YES];// 保存成功会返回YES

if(result ==YES && nil != filePath) {
    NSURL *outPutURL = [NSURL fileURLWithPath:filePath];
    NSSLog(@"videocount----%@",outPutURL);
    [self.photoList addObject:outPutURL];
 }
   
}



@end
