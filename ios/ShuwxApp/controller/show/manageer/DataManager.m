//
//  DataManager.m
//  PanCollectionView
//
//  Created by lizq on 16/8/31.
//  Copyright © 2016年 zqLee. All rights reserved.
//

#import "DataManager.h"
#import <UIKit/UIKit.h>
#import "CellModel.h"
static DataManager *data = nil;
@implementation DataManager

-(NSMutableArray *)appData{
    if (!_appData) {
        _appData = [NSMutableArray array];
    }
    return _appData;
}


+(DataManager *)shareDataManager {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[DataManager alloc] init];
    });
    return data;
}
-(void)setDataManagerValue:(NSMutableArray *) dataValue{
    self.appData = dataValue;
    
    NSMutableDictionary * dicTable = [NSMutableDictionary dictionary];
           [dicTable setValue:@"全部应用" forKey:@"title"];
            [dicTable setValue:self.appData forKey:@"list"];
           
//             NSString *path = [[NSBundle mainBundle] pathForResource:@"TitleList" ofType:@"plist"];
//               NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray * arrayData = [NSMutableArray array];
    
    NSMutableDictionary * dictable = [NSMutableDictionary dictionary];
    [dictable setValue:self.appData forKey:@"list"];
     [dictable setValue:@"全部" forKey:@"title"];
    
    [arrayData addObject:dicTable];
     
           NSMutableArray *temp = @[].mutableCopy;
           self.titleArray = @[].mutableCopy;
           [self.titleArray addObject:@"我的应用"];
           for (int i = 0; i < arrayData.count; i ++) {
               NSMutableArray *tempSection = @[].mutableCopy;
               NSDictionary *dic = arrayData[i];
               NSArray *listArray = dic[@"list"];
               [self.titleArray addObject:dic[@"title"]];
               for (int j = 0; j < listArray.count; j ++) {
                   CellModel *model = [CellModel new];
                   model.state = ServeAdd;
                   model.isNewAdd = NO;
                   model.backGroundColor = [UIColor whiteColor];
                   NSMutableDictionary * dicJValue = [listArray objectAtIndex:j];
                   NSString * app_name =  [dicJValue objectForKey:@"app_name"];
                     NSString * app_id =  [dicJValue objectForKey:@"app_id"];
                     NSString * app_image =  [dicJValue objectForKey:@"app_image"];
                   model.title = app_name;
                   model.app_id = app_id;
                   model.app_image = app_image;
                   [tempSection addObject:model];
               }
               [temp addObject:tempSection.copy];
           }
           NSMutableArray *sectionOne = @[].mutableCopy;
           for (int i = 0; i < [self.appData count]; i++) {
               CellModel *model = temp[0][i];
               model.state = ServeSelected;
               [sectionOne addObject:model];
           }

           [temp insertObject:sectionOne atIndex:0];
           self.headArray = [NSMutableArray arrayWithArray:temp[0]];
           self.dataArray = temp.mutableCopy;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isEditing = NO;
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"TitleList" ofType:@"plist"];
        
       
    }

    return self;
}

@end
