//
//  propertyModel.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/9.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface propertyModel : NSObject

@property(nonatomic,copy) NSString *code; //属性的编码
@property(nonatomic,copy) NSString *bingdingModel;//是否有关联属性，不为null就需要从关联属性获取值
@property(nonatomic,copy) NSString *bingdingModelCode;//
@property(nonatomic,copy) NSString *bingdingField;//关联属性的key值
@property(nonatomic,copy) NSString *elementLabel;//需要显示的左边的属性值
@property(nonatomic,copy) NSString *showPosition;//显示位置,1:列表,2:新增,3:编辑,4:详情  showPosition = "1,2,3,4";
@property(nonatomic,copy) NSString *api;//接口
@property(nonatomic,copy) NSString *apiParam;//接口param

@property(nonatomic,copy) NSString *defaultValue;
@property(nonatomic,copy) NSString *elementType;
@property(nonatomic,copy) NSString *isEdit;
@property(nonatomic,copy) NSString *isSearch;
@property(nonatomic,copy) NSString *showFlag;//是否需要显示
@property(nonatomic,copy) NSString *relaType;//关联类型：1基本类型 2.值域(字典)3.主数据（关联了另外的模型）4.自定义 5.接口
@property(nonatomic,copy) NSString *sort;

@property(nonatomic,copy) NSArray *bingdingArr;//通过接口获取的数据
@property(nonatomic,copy) NSDictionary *apiParamDic;//请求参数

//{
//    api = "<null>";
//    apiParam = "<null>";
//    belongings = mes;
//    bingdingField = "<null>";
//    bingdingModel = "<null>";
//    bingdingModelCode = "<null>";
//    checkRule = "<null>";
//    code = code;
//    createTime = "2020-09-23 15:59:03";
//    createUser = "<null>";
//    dataModelId = 20;
//    dataType = 1;
//    defaultValue = "<null>";
//    description = "<null>";
//    detailType = 1;
//    elementLabel = "\U5de5\U5e8f\U5de5\U5355\U7f16\U53f7";
//    elementTip = "<null>";
//    elementType = 1;
//    id = 20001;
//    isCodeField = "<null>";
//    isEdit = 0;
//    isMultiple = 0;
//    isRequired = 1;
//    isSearch = 1;
//    isUnique = 1;
//    name = "\U5de5\U5e8f\U5de5\U5355\U7f16\U53f7";
//    propclass = "<null>";
//    relaType = 1;
//    remark = "<null>";
//    selectJson = "<null>";
//    shorformat = "<null>";
//    showFlag = 1;
//    showPosition =             (
//    );
//    sort = 1;
//    status = 1;
//    textlength = "<null>";
//    unit = "<null>";
//    updateTime = "2020-12-01 10:09:37";
//    updateUser = "<null>";
//}



@end

NS_ASSUME_NONNULL_END
