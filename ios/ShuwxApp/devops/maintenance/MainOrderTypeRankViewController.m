//
//  MainOrderTypeRankViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/9/29.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainOrderTypeRankViewController.h"
#import "WRNavigationBar.h"

#import <UMCommon/MobClick.h>

@interface MainOrderTypeRankViewController ()<PGDatePickerDelegate>

@end

@implementation MainOrderTypeRankViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _allView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 50);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
                   self.navigationItem.title = @"工单类型排行";
                   UIButton  *leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
                   [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                   //    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
                   //    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
                   [leftButton setImage:[UIImage imageNamed:@"write_back"] forState:UIControlStateNormal];
                   [leftButton addTarget:self action:@selector(setScan) forControlEvents:UIControlEventTouchUpInside];
                   leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
                   [leftButton setFrame:CGRectMake(0,0,40,40)];
                   //    [leftButton sizeToFit];
                   
                   UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
                   leftBarButton.enabled = YES;
                   self.navigationItem.leftBarButtonItem = leftBarButton;
                   
                   
                   // 设置导航栏颜色
                   [self wr_setNavBarBarTintColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0]];
                   
                   // 设置初始导航栏透明度
                   [self wr_setNavBarBackgroundAlpha:1];
                   
                   // 设置导航栏按钮和标题颜色
                   [self wr_setNavBarTintColor:[UIColor whiteColor]];
                   [self wr_setNavBarTitleColor:[UIColor whiteColor]];
                   
                   [self initView];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MainOrderTypeRankViewController"];
  
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MainOrderTypeRankViewController"];
}
-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initView{
    [self setChartView];
    
    _curMonth =  [self getCurrentMonth];
       
       NSString * curString = [self getMonthTranfer:_curMonth];
        [_curMonthButton setTitle:curString forState:UIControlStateNormal];
       
         [_curMonthButton addTarget:self action:@selector(setCurDateDialog) forControlEvents:UIControlEventTouchUpInside];
        [_aboveButton addTarget:self action:@selector(setAboveDate) forControlEvents:UIControlEventTouchUpInside];
        [_nextButton addTarget:self action:@selector(setNextDate) forControlEvents:UIControlEventTouchUpInside];
    
    [self getOrderTypeRankView];
}



-(void)setChartView{
   _horizontalBar.delegate = self;
      
      _horizontalBar.drawBarShadowEnabled = NO;
      _horizontalBar.drawValueAboveBarEnabled = YES;
      
      _horizontalBar.maxVisibleCount = 60;
      
      ChartXAxis *xAxis = _horizontalBar.xAxis;
      xAxis.labelPosition = XAxisLabelPositionBottom;
      xAxis.labelFont = [UIFont systemFontOfSize:10.f];
      xAxis.drawAxisLineEnabled = YES;
      xAxis.drawGridLinesEnabled = NO;
      xAxis.granularity = 10.0;
      
      ChartYAxis *leftAxis = _horizontalBar.leftAxis;
    leftAxis.enabled = NO;
      
      ChartYAxis *rightAxis = _horizontalBar.rightAxis;
      rightAxis.enabled = YES;
      rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
      rightAxis.drawAxisLineEnabled = YES;
      rightAxis.drawGridLinesEnabled = NO;
      rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
      
      ChartLegend *l = _horizontalBar.legend;
      l.enabled = NO;
    
}

-(void)getOrderTypeRankView{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:_curMonth forKey:@"searchTime"];
     [diction setValue:@(9) forKey:@"timeType"];
    
    
    NSString * url = [self getPinjieNSString:baseUrl :ObjcetCountRankView];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
    [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
             [self setOrderTypeRankView:myResult];
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
           
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
-(void)setOrderTypeRankView:(NSMutableArray *) nsmutable{
    NSMutableArray * list = [NSMutableArray array];
      NSMutableArray * strings = [NSMutableArray array];
    for (NSMutableDictionary * dicOne in nsmutable) {
        NSString * order_count = [dicOne objectForKey:@"object_count"];
         NSString * type_name = [dicOne objectForKey:@"object_name"];
        
        if([self isBlankString:type_name]){
            type_name = @"";
        }
        
        [list addObject:order_count];
         [strings addObject:type_name];
    }
    
     NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    double barWidth = 9.0;
    double spaceForBar = 10.0;
    
    for (int i = 0;i < [list count] ;i++) {
        double val =   [[list objectAtIndex:i] doubleValue];
         [yVals addObject:[[BarChartDataEntry alloc] initWithX:i * spaceForBar y:val]];
    }
    
    BarChartDataSet *set1 = nil;
     if (_horizontalBar.data.dataSetCount > 0)
     {
         set1 = (BarChartDataSet *)_horizontalBar.data.dataSets[0];
         [set1 replaceEntries:yVals];
         [_horizontalBar.data notifyDataChanged];
         [_horizontalBar notifyDataSetChanged];
     }
     else
     {
         set1 = [[BarChartDataSet alloc] initWithEntries:yVals label:@""];
         
         set1.drawIconsEnabled = NO;
         
         NSMutableArray *dataSets = [[NSMutableArray alloc] init];
         [dataSets addObject:set1];
         
         BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
         [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:0.f]];
         data.barWidth = barWidth;
         
         _horizontalBar.data = data;
     }
}

-(void)setCurDateDialog{
       PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
          datePickManager.isShadeBackground = true;
          PGDatePicker *datePicker = datePickManager.datePicker;
          datePicker.delegate = self;
          datePicker.datePickerType = PGDatePickerTypeSegment;
          datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
          [self presentViewController:datePickManager animated:false completion:nil];

}
#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    NSString * year = [NSString stringWithFormat:@"%d",dateComponents.year];
    NSString * month = [NSString stringWithFormat:@"%d",dateComponents.month];
    int month_int = [month intValue];
    if (month_int < 10) {
        month = [self getPinjieNSString:@"0":month];
    }
    NSString * dateString = @"";
       dateString =  [self getPinjieNSString:dateString:year];
     dateString =  [self getPinjieNSString:dateString:@"-"];
       dateString =  [self getPinjieNSString:dateString:month];
    
    _curMonth =  dateString;
      
      NSString * curString = [self getMonthTranfer:_curMonth];
       [_curMonthButton setTitle:curString forState:UIControlStateNormal];
    
      [self getOrderTypeRankView];
}

-(void)setAboveDate{
    NSString *aboveValue =  [self getLoatNextMonth:-1:_curMonth];
    NSString * curString = [self getMonthTranfer:aboveValue];
          [_curMonthButton setTitle:curString forState:UIControlStateNormal];
      _curMonth =  aboveValue;
    
       [self getOrderTypeRankView];
}
-(void)setNextDate{
     NSString *aboveValue =  [self getLoatNextMonth:1:_curMonth];
    NSString * curString = [self getMonthTranfer:aboveValue];
          [_curMonthButton setTitle:curString forState:UIControlStateNormal];
       _curMonth =  aboveValue;
    
       [self getOrderTypeRankView];
}
@end
