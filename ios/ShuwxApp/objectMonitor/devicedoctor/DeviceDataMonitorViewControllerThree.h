//
//  DeviceDataMonitorViewControllerThree.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/12/13.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <UMCommon/MobClick.h>
#import "MyCollectionViewCellTwo.h"
#import "MJRefresh.h"
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "LowerControlViewController.h"
#import "LowerControlViewControllerTwo.h"
#import "LowerControlViewControllerThree.h"
#import "SocketRocket.h"
#import "Masonry.h"
#import "ProBtn.h"
#import "CollectionReusableView.h"

typedef void (^ReturnValueBlockTwo) (NSMutableDictionary *strValue);

@interface DeviceDataMonitorViewControllerThree : MainViewController<SRWebSocketDelegate>{
    UINib *_personNib;
         @public int startRow;
             @public int total;
}
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) NSMutableArray *indexPathList;
@property(nonatomic, copy) ReturnValueBlockTwo returnValueBlock;
@property (nonatomic,strong)NSString * projectId;
-(void)setRefresh:(NSString *)projectId;
@property (nonatomic,strong)NSString * pointKey;
@property (strong, nonatomic) SRWebSocket *socket;
@property (weak, nonatomic) IBOutlet ProBtn *setBtn;
@property (strong, nonatomic) NSMutableDictionary * cellIdentifierDic;
@property (strong, nonatomic) CollectionReusableView *footerView;
@property (nonatomic, strong) NSString * deviceName;

@end

