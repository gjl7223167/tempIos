//
//  WbConditionViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/7/28.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "WbConditionViewController.h"

@interface WbConditionViewController ()

@end

@implementation WbConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.viewbg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    //设置圆角半径值
    self.addView.layer.cornerRadius  = 10.f;
    //设置为遮罩，除非view有阴影，否则都要指定为YES的
    self.addView.layer.masksToBounds = YES;
    
      [self.closeButton addTarget:self action:@selector(setClose) forControlEvents:UIControlEventTouchUpInside];
    
    self.addView.userInteractionEnabled=YES;
    UITapGestureRecognizer *ggggg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture2)];
    [self.addView addGestureRecognizer:ggggg];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture1)];
    
    [self.view addGestureRecognizer:gesture];
    
    [self getSelectMasContentByContentId];
}
-(void)setClose{
       [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

-(void)tagGesture1 {
    if ([self respondsToSelector:@selector(presentingViewController)]) {
        [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [[self parentViewController] dismissModalViewControllerAnimated:YES];
    }
    
}
-(void)tagGesture2 {
    
}

// 维保条件查询
-(void)getSelectMasContentByContentId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:_content_in_id forKey:@"content_in_id"];
    
    
    NSString * url = [self getPinjieNSString:baseUrl :selectMasContentByContentId];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
    [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];

    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            [self setSelectMasContentByContentId:myResult];
        }
        if ([myResult isKindOfClass:[NSString class]]) {
            [self showToastTwo:myResult];
        }
        
    } failure:^(NSError *error) {
        //请求失败
        NSString * errorStr =  [self getError:error];
        [self showToastTwo:errorStr];
        
    }];
}
-(void)setSelectMasContentByContentId:(NSMutableDictionary *) nsmutable{
    NSString * case_json =  [nsmutable objectForKey:@"case_json"];
    NSMutableArray * caseJsonList  =    [self dictionaryWithJsonString:case_json];
    int myLengththree = 0;
    for(int i = 0; i < [caseJsonList count]; i++){
        NSMutableDictionary * dictionns = [caseJsonList objectAtIndex:i];
        NSString * case_type = [dictionns objectForKey:@"case_type"];
        NSMutableArray * case_content_list =  [dictionns objectForKey:@"case_content_list"];
        
        int temp = i + 1;
        
        UILabel *needLabel = [[UILabel alloc]init];
        needLabel.frame = CGRectMake(10, myLengththree, 50, 30);
        needLabel.font=[UIFont systemFontOfSize:14];
        NSString *string = [NSString stringWithFormat:@"%d",temp];
        needLabel.text = string;
        needLabel.textAlignment = UITextAlignmentCenter;
        [self.weibContentView addSubview:needLabel];
        
        int case_type_int = [case_type intValue];
        UILabel *centerLabel = [[UILabel alloc]init];
        centerLabel.frame = CGRectMake(60, myLengththree, 100, 30);
        centerLabel.font=[UIFont systemFontOfSize:14];
        centerLabel.text = [self getCaseType:case_type_int];
        centerLabel.textAlignment = UITextAlignmentCenter;
        [self.weibContentView addSubview:centerLabel];
        
        NSMutableDictionary * digs = [caseJsonList objectAtIndex:i];
        NSMutableArray * case_content_list_two =  [digs objectForKey:@"case_content_list"];
       
        if ([case_content_list_two isKindOfClass:[NSString class]]) {
            return;
        }
          NSMutableDictionary * dictioNs = [case_content_list_two objectAtIndex:i];
        
           NSString * allConteent = @"";
        if ([dictioNs count] > 0) {
            NSString * case_count = [self getIntegerValue:[dictioNs objectForKey:@"case_count"]];
                            NSString * case_unit = [dictioNs objectForKey:@"case_unit"];
            NSString * case_content_cn = [dictioNs objectForKey:@"case_content_cn"];
            NSString * case_symbol = [dictioNs objectForKey:@"case_symbol"];
          
                            NSString * current_val = @"";
                            if ([dictioNs objectForKey:@"current_val"]) {
                                current_val =  [dictioNs objectForKey:@"current_val"];
                            }
            allConteent =  [self getPinjieNSString:allConteent:case_content_cn];
            allConteent =  [self getPinjieNSString:allConteent:case_symbol];
            allConteent =  [self getPinjieNSString:allConteent:case_count];
            allConteent =  [self getPinjieNSString:allConteent:case_unit];
                            if ([self isBlankString:current_val]) {
                                allConteent =  [self getPinjieNSString:allConteent:@"(当前值：无)"];
                            }else{
                                NSString * curString = @"(当前值：";
                                curString  = [self getPinjieNSString:curString:current_val];
                                curString  = [self getPinjieNSString:curString:@")"];
                                allConteent =  [self getPinjieNSString:allConteent:curString];
                            }
        }
        
        UILabel *rightLabel = [[UILabel alloc]init];
        rightLabel.frame = CGRectMake(160, myLengththree, 100, 30);
        rightLabel.font=[UIFont systemFontOfSize:8];
        rightLabel.text = allConteent;
        rightLabel.textAlignment = UITextAlignmentCenter;
        [self.weibContentView addSubview:rightLabel];
        
        myLengththree += 30;
        
    }
}
-(NSString *)getCaseType:(int)typeInt{
    switch (typeInt) {
        case 1:
            return @"维保间隔";
            break;
        case 2:
            return @"运行时间";
            break;
        case 3:
            return @"事件条件";
            break;
        case 4:
            return @"运行条件";
            break;
        case 5:
            return @"时间设置";
            break;
            
        default:
            return @"";
            break;
    }
    return @"";
}

@end
