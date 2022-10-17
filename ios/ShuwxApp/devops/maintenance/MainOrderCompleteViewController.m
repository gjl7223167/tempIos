//
//  MainOrderCompleteViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/9/29.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainOrderCompleteViewController.h"
#import "WRNavigationBar.h"
#import <UMCommon/MobClick.h>



@interface MainOrderCompleteViewController ()<ChartViewDelegate,PGDatePickerDelegate>

@end

@implementation MainOrderCompleteViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.allView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
                  self.navigationItem.title = @"工单完成率统计";
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
    [MobClick beginLogPageView:@"MainOrderCompleteViewController"];
  
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MainOrderCompleteViewController"];
}
-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initView{
    [self setChartView];
     [self setComBindChartView];
    
  self.curMonth =  [self getCurrentMonth];
    
    NSString * curString = [self getMonthTranfer:self.curMonth];
     [self.curMonthButton setTitle:curString forState:UIControlStateNormal];
    
      [self.curMonthButton addTarget:self action:@selector(setCurDateDialog) forControlEvents:UIControlEventTouchUpInside];
     [self.aboveButton addTarget:self action:@selector(setAboveDate) forControlEvents:UIControlEventTouchUpInside];
     [self.nextButton addTarget:self action:@selector(setNextDate) forControlEvents:UIControlEventTouchUpInside];
    
    [self getOrderEndRateView];
}



-(void)setChartView{
    self.pieView.usePercentValuesEnabled = YES;
      self.pieView.drawSlicesUnderHoleEnabled = NO;
      self.pieView.holeRadiusPercent = 0.7;
      self.pieView.holeColor = [UIColor clearColor];//空心颜色
      self.pieView.transparentCircleRadiusPercent = 0.61;
      self.pieView.chartDescription.enabled = NO;
      [self.pieView setExtraOffsetsWithLeft:0 top:0 right:0 bottom:0];
          self.pieView.noDataText = @"暂无数据";
      self.pieView.drawCenterTextEnabled = YES;
    self.pieView.backgroundColor = [UIColor whiteColor];
      
      NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
      paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
      paragraphStyle.alignment = NSTextAlignmentCenter;
    
      self.pieView.drawHoleEnabled = YES;
      self.pieView.rotationAngle = 0.0;
      self.pieView.rotationEnabled = YES;
      self.pieView.highlightPerTapEnabled = YES;
      
      self.pieView.delegate = self;
      
      ChartLegend *l = self.pieView.legend;
      //    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
      //    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
      //    l.orientation = ChartLegendOrientationVertical;
      //    l.drawInside = NO;
      //    l.xEntrySpace = 7.0;
      //    l.yEntrySpace = 0.0;
      //    l.yOffset = 0.0;
      l.enabled = false;
      
      // entry label styling
      self.pieView.entryLabelColor = UIColor.whiteColor;
      self.pieView.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];

      [self.pieView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
}
-(void)setData:(NSMutableArray *)entries:(NSMutableArray *)colors{
       
       PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithEntries:entries label:@""];
       
       dataSet.sliceSpace = 2.0;
       
       // add a lot of colors
       
       dataSet.colors = colors;
       
    dataSet.valueLinePart1OffsetPercentage = 0.6;
     dataSet.valueLinePart1Length = 0.2;
     dataSet.valueLinePart2Length = 0.4;
      dataSet.valueLineColor = [UIColor whiteColor];//折线颜色
     //dataSet.xValuePosition = PieChartValuePositionOutsideSlice;
     dataSet.yValuePosition = PieChartValuePositionOutsideSlice;
     
     PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
     
     NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
     pFormatter.numberStyle = NSNumberFormatterPercentStyle;
     pFormatter.maximumFractionDigits = 1;
     pFormatter.multiplier = @1.f;
     pFormatter.percentSymbol = @" %";


    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
     [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
     [data setValueTextColor:UIColor.whiteColor];
     data.drawValues = NO;
       
       self.pieView.data = data;
       [self.pieView highlightValues:nil];
}

-(void)setComBindChartView{
  
    self.comBinedView.chartDescription.enabled = NO;
          
          self.comBinedView.drawGridBackgroundEnabled = NO;
          
          self.comBinedView.dragEnabled = YES;
          [self.comBinedView setScaleEnabled:YES];
          self.comBinedView.pinchZoomEnabled = NO;
            self.comBinedView.noDataText = @"暂无数据";
          
          // ChartYAxis *leftAxis = chartView.leftAxis;
          
          ChartXAxis *xAxis = self.comBinedView.xAxis;
          xAxis.labelPosition = XAxisLabelPositionBottom;
          
          self.comBinedView.rightAxis.enabled = NO;
          
          self.comBinedView.delegate = self;
          
          self.comBinedView.drawBarShadowEnabled = NO;
          self.comBinedView.drawValueAboveBarEnabled = YES;
    self.comBinedView.backgroundColor = [UIColor whiteColor];
          self.comBinedView.maxVisibleCount = 60;
          
          xAxis.labelPosition = XAxisLabelPositionBottom;
          xAxis.labelFont = [UIFont systemFontOfSize:10.f];
          xAxis.drawGridLinesEnabled = NO;
          xAxis.granularity = 1.0; // only intervals of 1 day
      //    xAxis.labelCount = 2;
          
      //    DateValueFormatter * dateValueFor =  [[DateValueFormatter alloc] init];
      //    xAxis.valueFormatter = dateValueFor;
      //       xAxis.valueFormatter = self;
          
          NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
      //    leftAxisFormatter.minimumFractionDigits = 0;
      //    leftAxisFormatter.maximumFractionDigits = 1;
          leftAxisFormatter.negativeSuffix = @"%";
          leftAxisFormatter.positiveSuffix = @"%";
          
          ChartYAxis *leftAxis = self.comBinedView.leftAxis;
          leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
      //    leftAxis.labelCount = 8;
          leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
          leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
          leftAxis.spaceTop = 0.15;
          leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
          
          ChartYAxis *rightAxis = self.comBinedView.rightAxis;
          rightAxis.enabled = NO;
          
          ChartLegend *l = self.comBinedView.legend;
          l.enabled = NO;

}

-(void)getOrderEndRateView{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:self.curMonth forKey:@"searchTime"];
     [diction setValue:@(9) forKey:@"timeType"];
    
    
    NSString * url = [self getPinjieNSString:baseUrl :mainorderEndRateView];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
    [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            [self setOrderEndRateView:myResult];
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
-(void)setOrderEndRateView:(NSMutableDictionary *) nsmutable{
    
    NSString * total_count =  [nsmutable objectForKey:@"total_count"];
    NSString * no_start_count = [nsmutable objectForKey:@"no_start_count"];
    NSString * v_ing_count =  [nsmutable objectForKey:@"v_ing_count"];
    NSString * v_end_count =  [nsmutable objectForKey:@"v_end_count"];
    double per_no_start =  [[nsmutable objectForKey:@"per_no_start"] doubleValue];
      double per_v_ing =  [[nsmutable objectForKey:@"per_v_ing"] doubleValue];
     double per_v_end =  [[nsmutable objectForKey:@"per_v_end"] doubleValue];
    
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
           NSMutableArray *colors = [[NSMutableArray alloc] init];
      
    PieChartDataEntry * onePieChart2 = [[PieChartDataEntry alloc] initWithValue:per_v_end];
                    [entries addObject:onePieChart2];
    UIColor *myColor2 = [self colorWithHexString:@"#3AA0FF"];
    [colors addObject:myColor2];
                 
    
    PieChartDataEntry * onePieChart1 = [[PieChartDataEntry alloc] initWithValue:per_v_ing];
                   [entries addObject:onePieChart1];
                   UIColor *myColor1 = [self colorWithHexString:@"#FACC14"];
                   [colors addObject:myColor1];
    

    PieChartDataEntry * onePieChart = [[PieChartDataEntry alloc] initWithValue:per_no_start];
                 [entries addObject:onePieChart];
    UIColor *myColor = [self colorWithHexString:@"#EC808D"];
    [colors addObject:myColor];
      
       [self setData:entries :colors];
     
    NSString * totalString = [self getIntegerValue:total_count];
    
  totalString =  [self getPinjieNSString:@"   ":totalString];
    totalString =  [self getPinjieNSString:totalString:@"单\n维保总数"];
     
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:totalString];
         [centerText setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:12],
                                     NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]}
                             range:NSMakeRange(0, centerText.length)];
         self.pieView.centerAttributedText = centerText;
    
      NSString * noStart = [self getIntegerValue:no_start_count];
    noStart = [self getPinjieNSString:@"待接单":noStart];
     NSString * vInt = [self getIntegerValue:v_ing_count];
     vInt = [self getPinjieNSString:@"进行中":vInt];
       NSString * vEnt = [self getIntegerValue:v_end_count];
     vEnt = [self getPinjieNSString:@"已完成":vEnt];
    
    [self.waitOrderButton setTitle:noStart  forState:(UIControlStateNormal)];
      [self.intOrderButton setTitle:vInt  forState:(UIControlStateNormal)];
      [self.endOrderButton setTitle:vEnt  forState:(UIControlStateNormal)];
    
    self.noStartList = [nsmutable objectForKey:@"vendList"];
      self.vingList = [nsmutable objectForKey:@"vingList"];
      self.vendList = [nsmutable objectForKey:@"noStartList"];
    NSMutableArray * timeList = [nsmutable objectForKey:@"timeList"];
    
    [self setDayInfor:0];
    
     NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.noStartList count]; i++){
        double noStart = [[self.noStartList objectAtIndex:i] doubleValue];
           double ving = [[self.vingList objectAtIndex:i] doubleValue];
           double vend = [[self.vendList objectAtIndex:i] doubleValue];
        
         [yVals addObject:[[BarChartDataEntry alloc] initWithX:i yValues:@[@(noStart), @(ving), @(vend)] ]];
    }
    

    
    BarChartDataSet *set1 = nil;
          if (self.comBinedView.data.dataSetCount > 0)
          {
              set1 = (BarChartDataSet *)self.comBinedView.data.dataSets[0];
              [set1 replaceEntries: yVals];
              [self.comBinedView.data notifyDataChanged];
              [self.comBinedView notifyDataSetChanged];
          }
          else
          {
              set1 = [[BarChartDataSet alloc] initWithEntries:yVals label:@""];
              
              set1.drawIconsEnabled = NO;
              
              set1.colors = colors;
      //        set1.stackLabels = @[@"Births", @"Divorces", @"Marriages"];
              
              NSMutableArray *dataSets = [[NSMutableArray alloc] init];
              [dataSets addObject:set1];
              
              NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
              formatter.maximumFractionDigits = 1;
              formatter.negativeSuffix = @"";
              formatter.positiveSuffix = @"";
              
              BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
              [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:0.f]];
              [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:formatter]];
              [data setValueTextColor:UIColor.whiteColor];
              
              self.comBinedView.fitBars = YES;
              self.comBinedView.data = data;
          }
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    
    if ([chartView isKindOfClass:[BarChartView class]]) {
       int myX = highlight.x;

        [self setDayInfor:myX];
    }
    
}

-(void)setDayInfor:(int) myInt{
    int dayAll = 0;
    int no_start_count = [[self.noStartList objectAtIndex:myInt] intValue];
   int v_ing_count = [[self.vingList objectAtIndex:myInt] intValue];
   int v_end_count = [[self.vendList objectAtIndex:myInt]intValue];
    
    dayAll = no_start_count + v_ing_count + v_end_count;
    
    NSString *noStart = [NSString stringWithFormat:@"%d", no_start_count];
    NSString *vInt = [NSString stringWithFormat:@"%d", v_ing_count];
    NSString *vEnt = [NSString stringWithFormat:@"%d", v_end_count];
 
       noStart = [self getPinjieNSString:@"待接单":noStart];
        vInt = [self getPinjieNSString:@"进行中":vInt];
        vEnt = [self getPinjieNSString:@"已完成":vEnt];
       
       [self.waitButtonBottom setTitle:vEnt  forState:(UIControlStateNormal)];
         [self.ingButtonBottom setTitle:vInt  forState:(UIControlStateNormal)];
         [self.endButtonBottom setTitle:noStart  forState:(UIControlStateNormal)];
    
    myInt += 1;
    
     NSString * singleDayTotal = [NSString stringWithFormat:@"%d", myInt];
      NSString *allDaySum = [NSString stringWithFormat:@"%d", dayAll];
    singleDayTotal = [self getPinjieNSString:singleDayTotal:@"日维保总数"];
       allDaySum = [self getPinjieNSString:singleDayTotal:allDaySum];
       allDaySum = [self getPinjieNSString:allDaySum:@"单"];
    self.dayTotalValue.text = allDaySum;
    
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
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
    
    self.curMonth =  dateString;
      
      NSString * curString = [self getMonthTranfer:self.curMonth];
       [self.curMonthButton setTitle:curString forState:UIControlStateNormal];
    
      [self getOrderEndRateView];
}

-(void)setAboveDate{
    NSString *aboveValue =  [self getLoatNextMonth:-1:self.curMonth];
    NSString * curString = [self getMonthTranfer:aboveValue];
          [self.curMonthButton setTitle:curString forState:UIControlStateNormal];
      self.curMonth =  aboveValue;
    
       [self getOrderEndRateView];
}
-(void)setNextDate{
     NSString *aboveValue =  [self getLoatNextMonth:1:self.curMonth];
    NSString * curString = [self getMonthTranfer:aboveValue];
          [self.curMonthButton setTitle:curString forState:UIControlStateNormal];
       self.curMonth =  aboveValue;
    
       [self getOrderEndRateView];
}


@end
