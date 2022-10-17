//
//  CarLogoViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/9/10.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "SGPagingView.h"
#import "CarLogoItemViewController.h"
#import <UMCommon/MobClick.h>

typedef void (^ReturnValueBlockTwo) (NSMutableDictionary *strValue);

@interface CarLogoViewController : MainViewController{
     @public int myPostion;
}
@property(nonatomic, copy) ReturnValueBlockTwo returnValueBlock;
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;
@property (nonatomic,strong) NSMutableArray *childArr;
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *carIp;
@end

