//
//  NSObject+modelValue.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/10.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "NSObject+modelValue.h"
#import "propertyModel.h"
#import "UrlRequestModel.h"
#import "UrlRequest.h"

@implementation NSObject (modelValue)

-(NSArray *)ModelArrayFromrecords:(NSArray *)recordsArr propertyInfo:(NSDictionary *  __nullable)propertyInfoDic
{
    NSArray *selfArr = (NSArray *)self;
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSDictionary *oneRec in recordsArr) {
        NSMutableDictionary *oneRecDic = [[NSMutableDictionary alloc] initWithCapacity:(selfArr.count + 1)];
        for (propertyModel *model in selfArr) {
            id value = oneRec[model.code];
//            NSLog(@"bingdingModel=%@$$$$$code=%@$$$$$bingdingField=%@",model.bingdingModel,model.code,model.bingdingField);
            if (propertyInfoDic) {
                if (![self isNullString:value])
                {
                    if (![self isNullString:model.bingdingModel]) {
                    //                NSLog(@"bingdingModel=%@===code=%@",model.bingdingModel,model.code);
                    
                    NSDictionary *proDic = propertyInfoDic[model.code];
                    NSDictionary *infoDic = proDic[[NSString stringWithFormat:@"%@",value]];
                    value = infoDic[model.bingdingField];
                    }
                    if ([model.relaType intValue] == 2||[model.relaType intValue] == 5)
                    {
                        value = [self valueForModel:model value:value];
                    }
                    //            NSLog(@"----%@-----%@--",model.code,value);
                    if ([self isNullString:value]) {
                        value = @"";
                    }
                }else{
                    value = @"";
                }
                [oneRecDic setObject:value forKey:model.code];
            }else
            {
                if ([self isNullString:value]) {
                    value = @"";
                }else{
                    if ([model.relaType intValue] == 2||[model.relaType intValue] == 5)
                    {
                        value = [self valueForModel:model value:value];
                    }
                    else if ([model.relaType intValue] == 3){
                        NSLog(@"111");
                        NSDictionary *selectedDic = nil;
                        for (NSDictionary *dic in model.bingdingArr) {
                            if ([dic[@"id"] intValue] == [value intValue]) {
                                selectedDic = dic;
                            }
                        }
                        if (selectedDic) {
                            value = selectedDic[model.bingdingField];
                        }else{
                            value = @"";
                        }
                    }
                }
                
                [oneRecDic setObject:value forKey:model.code];
            }
        }
        
        NSString *workOrderId = [NSString stringWithFormat:@"%@",[oneRec objectForKey:@"id"]];
        [oneRecDic setObject:workOrderId forKey:@"workOrderId"];
        
        [arr addObject:oneRecDic];
    }
    return arr.copy;
}

-(id)valueForModel:(propertyModel *)model value:(id)value
{
    id reValue = nil;
    
    NSDictionary *selectedDic = nil;
    for (NSDictionary *dic in model.bingdingArr) {
        if ([dic[@"id"] intValue] == [value intValue]) {
            selectedDic = dic;
        }
    }
    if (selectedDic) {
        reValue = selectedDic[@"name"];
        if (!reValue) {
            reValue = selectedDic[@"dic_name"];
            if (!reValue) {
                reValue = @"";
            }
        }
    }else{
        reValue = @"";
    }
    
    return reValue;
    
}

-(NSArray<propertyModel *> *)ModelShowArrFromshowPosition:(NSInteger)Postion
{
    //Postion显示位置,1:列表,2:新增,3:编辑,4:详情
    NSArray *selfArr = (NSArray *)self;
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:selfArr.count];
    for (propertyModel *model in selfArr) {
        NSArray *posArr = [model.showPosition componentsSeparatedByString:@","];
        for (NSString *pos in posArr) {
            if (Postion == [pos integerValue]) {
                [arr addObject:model];
            }
        }
    }
    
    return arr.copy;
}



- (BOOL)isNullString:(id)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isMemberOfClass:[NSString class]]) {
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        //        NSLog(@"bbbbb");
                return YES;
            }
            if ([string isEqualToString:@""] || [string isEqualToString:@"<null>"]||[string isEqualToString:@"(null)"]) {
        //        NSLog(@"lllllll");
                return YES;
            }
    }
    
    return NO;
}

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(void)ModelArrayHandleModelData{
    NSArray<propertyModel *> *selfArr = (NSArray *)self;
//    __block int i = 0;
    for (propertyModel *model in selfArr) {
        model.bingdingArr = [NSArray array];
        [self getLinkedData:model];
    }
}


-(void)ModelArrayFromrecords:(NSArray *)recordsArr completion:(void(^)(NSDictionary *))completion
{
    NSArray *selfArr = (NSArray *)self;
    for (NSDictionary *oneRec in recordsArr) {
        
        NSMutableDictionary *oneRecDic = [[NSMutableDictionary alloc] initWithCapacity:(selfArr.count + 1)];
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t customQ = dispatch_queue_create("ccccc", DISPATCH_QUEUE_CONCURRENT);

        for (propertyModel *model in selfArr) {
            id value = oneRec[model.code];
            if ([self isNullString:value]) {
                value = @"";
                [oneRecDic setValue:value forKey:model.code];
            }else
            {
                NSLog(@"-----%@---%@",model.code,model.api);
                if ([value integerValue] == 805) {
                    dispatch_group_async(group, customQ, ^{
                        [self getLinkedData:model value:value completion:^(NSString *newValue) {
                            
                            @synchronized (self) {
                                [oneRecDic setValue:newValue forKey:model.code];
                            }
                            NSLog(@"d");
                        }];
                    });
                }
                else{
                    [oneRecDic setValue:@"" forKey:model.code];

                }
                
            }
            
        }
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            completion(oneRecDic);
        });
        
//        NSString *workOrderId = [NSString stringWithFormat:@"%@",[oneRec objectForKey:@"id"]];
//        [oneRecDic setObject:workOrderId forKey:@"workOrderId"];
    }
}


-(void)getLinkedData:(propertyModel *)model value:(NSString *)value completion:(void(^)(NSString *))completion
{
    
}

-(void)getLinkedData:(propertyModel *)model
{
    NSLog(@"model------%@--------",model);
    if (!model.api) {
        return;
    }
    NSDictionary *param = nil;
    if ([model.relaType intValue] == 2||[model.relaType intValue] == 5) {
        param = [self dictionaryWithJsonString:model.apiParam];
        
        if (param[@"type"]) {
            NSString *type = [NSString stringWithFormat:@"%@",param[@"type"]];
            if ([type isEqualToString:@"relation"]) {
                NSArray *codeArr = param[@"code"];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                for (NSString *key in codeArr) {
                    [dic setValue:@"" forKey:key];
                }
                param = dic;
            }
        }

//        return;
    }else if([model.relaType intValue] == 3){
        param = @{@"property":@"id",
                  @"code":[NSString stringWithFormat:@"%@",model.bingdingModelCode],
                  @"elementType":[NSString stringWithFormat:@"%@",model.elementType],
                  @"value":@""
                };
//        return;
    }else
    {
        return;
    }
    
    NSLog(@"param----%@----%@",param,model.sort);
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    if ([model.api containsString:@"api.bjttsf.com/bcs/universal/dictionary/selectDictionaryByType"]) {
        
        [UrlRequest requestSelectDictionaryByTypeWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            if (result) {
                model.bingdingArr = [NSArray arrayWithArray:data];
            }
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return;
    }
    
    model.apiParamDic = param;

    [UrlRequestModel requestLinkedData:model.api Param:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
        
        if (result) {
            model.bingdingArr = [NSArray arrayWithArray:data];
        }
        
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"nnnnnnn");
}


@end
