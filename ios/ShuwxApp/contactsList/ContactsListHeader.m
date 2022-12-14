//
//  ContactsListHeader.m
//  QQProject
//
//  Created by Lester on 16/9/8.
//  Copyright © 2016年 Lester-iOS开发:98787555. All rights reserved.
//

#import "ContactsListHeader.h"
/** 设备的宽高 */
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#pragma mark - Font
/** 设置主题字体*/
#define MAIN_FONT(fontSize) [UIFont fontWithName:@"Heiti J" size:fontSize]



@interface ContactsListHeader()
/** 箭头*/
@property (strong, nonatomic) UIButton *arrowButton;
@end

@implementation ContactsListHeader

+ (instancetype)headerView:(UITableView *)tableView
{
    static NSString *identifier = @"header";
    ContactsListHeader *headerView = (ContactsListHeader *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[ContactsListHeader alloc] initWithReuseIdentifier:identifier];
    }
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {

        [self addSubview:self.arrowButton];
        
        /** 添加一条线*/
        UIView *linesView = [[UIView alloc]initWithFrame:CGRectMake(0, 44 - 0.3, SCREEN_WIDTH, 0.3)];
        linesView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:linesView];
    }
    return self;
}

#pragma mark - 懒加载
- (UIButton *)arrowButton{
    if(!_arrowButton){
        _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
       
        [_arrowButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        /** 设置Button按钮内容的内边距*/
//        [_arrowButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//        /** 设置Button内容的位置居左*/
        [_arrowButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_arrowButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//        /** 设置button图片的位置*/
//        [_arrowButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [_arrowButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        _arrowButton.imageView.clipsToBounds = NO;
        _arrowButton.titleLabel.font = MAIN_FONT(15.f);
        [_arrowButton setTitle:@"车当当" forState:UIControlStateNormal];
    }
    return _arrowButton;
}


#pragma mark - buttonAction
- (void)buttonAction
{
    self.groupModel.isOpen = !self.groupModel.isOpen;
    
    /** 如果代理响应了代理方法，就要调用这个方法*/ 
    if ([self.delegate respondsToSelector:@selector(didSelectTableViewHeaderFooterView)]) {
        [self.delegate didSelectTableViewHeaderFooterView];
    }
}
- (void)didMoveToSuperview
{
    /** 根据isOpen属性判断是否旋转？如果为YES，则旋转90°，否则不旋转*/
    self.arrowButton.imageView.transform = self.groupModel.isOpen ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    /** 注意这里要设置为bounds 不然会出错*/
    self.arrowButton.frame = self.bounds;
  
}

#pragma mark - groupModel
-(void)setGroupModel:(NSString *)groupName{
    _groupName = groupName;
    [self.arrowButton setTitle:groupName forState:UIControlStateNormal];
}

@end
