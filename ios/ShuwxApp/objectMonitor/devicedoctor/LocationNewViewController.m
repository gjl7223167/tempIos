//
//  LocationNewViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/5/5.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

#import "LocationNewViewController.h"
#import "WRNavigationBar.h"
#import <XHGAlertView/XHGAlertView.h>
#import <XHGAlertView/XHGTextView.h>
#import <XHGAlertView/XHGAlertMenusView.h>


@interface LocationNewViewController (){
    BMKCircle* circle;
    BMKPolygon* polygon;
    BMKPolygon* polygon2;
    BMKPolyline* polyline;
    BMKPolyline* colorfulPolyline;
    BMKArcline* arcline;
    BMKGroundOverlay* ground2;
    //    BMKPointAnnotation* pointAnnotation;
    BMKPointAnnotation* animatedAnnotation;
    BMKPointAnnotation* lockedScreenAnnotation;
}

@end

@implementation LocationNewViewController

-(NSMutableArray *)dataMap{
    if (!_dataMap) {
        _dataMap = [NSMutableArray array];
    }
    return _dataMap;
}
-(NSMutableArray *)nsMutable{
    if (!_nsMutable) {
        _nsMutable = [NSMutableArray array];
    }
    return _nsMutable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"地图";
    
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
    
//    UIButton  *rightButton  = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    //    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
//    //    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
//    [rightButton setImage:[UIImage imageNamed:@"alarm"] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(toPopWin) forControlEvents:UIControlEventTouchUpInside];
//    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//居左显示
//    [rightButton setFrame:CGRectMake(0,0,60,40)];
//
//    UIBarButtonItem * rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    rightBarButton.enabled = YES;
//    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    // 设置导航栏颜色
   [self wr_setNavBarBarTintColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0]];
    
    // 设置初始导航栏透明度
    [self wr_setNavBarBackgroundAlpha:1];
    
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:[UIColor whiteColor]];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
//        self.navigationController.navigationBar.translucent = NO;
    }
    //设置地图缩放级别
    [self.mapView setZoomLevel:6];
    [self.mapView removeOverlays:self.mapView.overlays];
    
     [self.mapView setMapType:BMKMapTypeSatellite];
    
    [self dataMap];
    [self nsMutable];
     [self getMapDeviceInfoList];
}

// 地图设备信息列表
-(void)getMapDeviceInfoList{
    
    NSMutableDictionary * dicnary = [self queryData];
       NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
      [diction setValue:ptoken forKey:@"token"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :getMapDeviceInfoList];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
       total =   [[responseObject objectForKey:@"total"] intValue];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setMapDeviceInfoList:myResult];
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
-(void)setMapDeviceInfoList:(NSMutableArray *) nsArr{
    self.dataMap = nsArr;
    NSString *deviceCount = [NSString stringWithFormat:@"%d",nsArr.count];
    NSString * deviceNstr =  [self getPinjieNSString:[self getPinjieNSString:@"共":deviceCount]:@"个设备"];
    self.deviceTotal.text = deviceNstr;
    
    for ( NSMutableDictionary * dicnary in nsArr) {
        NSString * device_name =  [dicnary objectForKey:@"device_name"];
        NSLog(@"%@",device_name);
        NSString * device_code =  [dicnary objectForKey:@"device_code"];
        NSString * lon =  [dicnary objectForKey:@"lon"];
        NSString * lat =  [dicnary objectForKey:@"lat"];
        double run_totle_time = 0;
        if(![[dicnary objectForKey:@"run_totle_time"] isEqual:[NSNull null]]){
         run_totle_time =   [ [dicnary objectForKey:@"run_totle_time"] doubleValue];
        }
        
        if ([self isBlankString:lon]) {
            lon = @"0";
        }
        if ([self isBlankString:lat]) {
            lat = @"0";
        }
        
        BMKPointAnnotation* pointAnnotation  = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [lat doubleValue];
        coor.longitude = [lon doubleValue];
        pointAnnotation.coordinate = coor;
        pointAnnotation.title = device_code;
        
        [self.mapView addAnnotation:pointAnnotation];
    }
}

-(void)setScan{
      [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
      [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
     [MobClick beginLogPageView:@"LocationNewViewController"];
 
    
}

-(void)viewWillDisappear:(BOOL)animated {
      [super viewWillAppear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
     [MobClick endLogPageView:@"LocationNewViewController"];
    
}

- (void)dealloc {
    if (self.mapView) {
        self.mapView = nil;
    }
}

#pragma mark implement BMKMapViewDelegate

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:0.5];
        circleView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.5];
        circleView.lineWidth = 5.0;
        
        return circleView;
    }
    
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        if (overlay == colorfulPolyline) {
            polylineView.lineWidth = 5;
            /// 使用分段颜色绘制时，必须设置（内容必须为UIColor）
            polylineView.colors = [NSArray arrayWithObjects:
                                   [[UIColor alloc] initWithRed:0 green:1 blue:0 alpha:1],
                                   [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:1],
                                   [[UIColor alloc] initWithRed:1 green:1 blue:0 alpha:0.5], nil];
        } else {
            polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
            polylineView.lineWidth = 20.0;
            [polylineView loadStrokeTextureImage:[UIImage imageNamed:@"texture_arrow.png"]];
        }
        return polylineView;
    }
    
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0 blue:0.5 alpha:1];
        polygonView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:0.2];
        polygonView.lineWidth =2.0;
        polygonView.lineDash = (overlay == polygon2);
        return polygonView;
    }
    if ([overlay isKindOfClass:[BMKGroundOverlay class]])
    {
        BMKGroundOverlayView* groundView = [[BMKGroundOverlayView alloc] initWithOverlay:overlay];
        return groundView;
    }
    if ([overlay isKindOfClass:[BMKArcline class]]) {
        BMKArclineView *arclineView = [[BMKArclineView alloc] initWithArcline:overlay];
        arclineView.strokeColor = [UIColor blueColor];
        arclineView.lineDash = YES;
        arclineView.lineWidth = 6.0;
        return arclineView;
    }
    return nil;
}


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
    BMKPinAnnotationView *  newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.canShowCallout=NO;//不显示气泡 设置这个是为了在不设置title的情况下，标注也能接收到点击事件
        // 设置可拖拽
        newAnnotationView.draggable = NO;
        // 从天上掉下效果
        newAnnotationView.animatesDrop = YES;
        
        newAnnotationView.image = [UIImage imageNamed:@"datouzhen"];
        
        for (int i = 0; i < [self.dataMap count] ;i++) {
             NSMutableDictionary *threeDic = [self.dataMap objectAtIndex:i];
              NSString * device_code = [threeDic objectForKey:@"device_code"];
            if ([self getNSStringEqual:device_code :annotation.title]) {
                  newAnnotationView.tag = i;
            }
        }
        
        return newAnnotationView;
    }
    return nil;
}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    myPosition = view.tag;

        BMKPinAnnotationView *newAnnotationView = view;
    newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
    newAnnotationView.canShowCallout=NO;//不显示气泡 设置这个是为了在不设置title的情况下，标注也能接收到点击事件
    
    NSMutableDictionary *threeDic =    [self.dataMap objectAtIndex:myPosition];
    NSString * lon = [threeDic objectForKey:@"lon"];
    NSString * lat = [threeDic objectForKey:@"lat"];
    NSString * device_name = [threeDic objectForKey:@"device_name"];
    NSString *  device_code = [threeDic objectForKey:@"device_code"];
    NSString * device_status_name = [threeDic objectForKey:@"device_status_name"];
     NSString * device_status_color = [threeDic objectForKey:@"device_status_color"];
      NSString * device_img = [threeDic objectForKey:@"device_img"];
    
    double run_totle_time = 0;
    if(![[threeDic objectForKey:@"run_totle_time"] isEqual:[NSNull null]]){
        run_totle_time =   [ [threeDic objectForKey:@"run_totle_time"] doubleValue];
    }
    NSString * amountStr = [self doubleToNSString:run_totle_time];
    
    if ([self isBlankString:device_status_name]) {
        device_status_name = @"";
    }
    self.deviceStateName.text = device_status_name;
    
    self.deviceName.text = device_name;
    self.deviceCode.text = [self getPinjieNSString:@"设备编号：":device_code];
    
    int day =   [self getDay:run_totle_time];
    int hour =   [self getHour:run_totle_time];
    
    NSString *dayStr = [NSString stringWithFormat:@"%d", day];
    NSString *hourStr = [NSString stringWithFormat:@"%d", hour];
    
    NSString * myHour = @"";
    if ([self getNSStringEqual:dayStr:@"0"]) {
        myHour =    [self getPinjieNSString:dayStr:@"小时"];
    }
    else  if ([self getNSStringEqual:hourStr:@"0"]) {
        myHour =    [self getPinjieNSString:dayStr:@"天"];
    }else{
        myHour =  [self getPinjieNSString:[self getPinjieNSString:[self getPinjieNSString:dayStr:@"天"]:hourStr]:@"小时"];
    }
     self.runTime.text = [self getPinjieNSString:@"累计运行时间：":myHour];
    
    if ([self isBlankString:device_status_name]) {
         device_status_name = @"未知";
    }
    if ([self isBlankString:device_status_color]) {
       device_status_color = @"#0089ff";
    }
    
    self.deviceStateName.text = device_status_name;
    
    UIColor * myColor = [self colorWithHexString:device_status_color];
    self.deviceStateName.textColor = myColor;
    
    self.deviceStateName.layer.cornerRadius = 8;
    self.deviceStateName.layer.borderWidth = 1;
    self.deviceStateName.layer.borderColor = myColor.CGColor;
    
    self.deviceStateName.preferredMaxLayoutWidth = 200;
     self.deviceStateName.numberOfLines = 0;
    
    self.navigateButon.layer.cornerRadius = 8;
      self.navigateButon.layer.borderWidth = 1;
      self.navigateButon.layer.borderColor = myColor.CGColor;
    self.navigateButon.userInteractionEnabled=YES;
     MYTapGestureRecognizer* tap2=[[MYTapGestureRecognizer alloc]initWithTarget:self action:@selector(navgationTap:)];
      tap2.dictionary =threeDic;
 [self.navigateButon addGestureRecognizer:tap2];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];
    NSString * imageUrl = [self getPinjieNSString:pictureUrl:device_img];
    
    NSString * defaultImage = @"defaultpic";
    
    [self.imagedevice sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:defaultImage]];
    
    //给图层添加一个有色边框 
    self.imagedevice.layer.borderWidth = 1; 
    self.imagedevice.layer.borderColor = [[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0] CGColor]; 
    
//    MYTapGestureRecognizer* tap1=[[MYTapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
//    tap1.dictionary =threeDic;
//
//        [self.relView addGestureRecognizer:tap1];
    
    if (nil == self.bmkPinAnnotation) {
         newAnnotationView.image = [UIImage imageNamed:@"datouzhendown"];
        self.bmkPinAnnotation = view;
        self.bmkCode = device_code;
          [self.relView setHidden:NO];
        return;
    }
    
    if (![self getNSStringEqual:self.bmkCode:device_code]) {
          newAnnotationView.image = [UIImage imageNamed:@"datouzhendown"];
         self.bmkPinAnnotation.image = [UIImage imageNamed:@"datouzhen"];
    }else{
         newAnnotationView.image = [UIImage imageNamed:@"datouzhen"];
          self.bmkPinAnnotation.image = [UIImage imageNamed:@"datouzhendown"];
    }
    
    self.bmkPinAnnotation = view;
    self.bmkCode = device_code;
    
    [self.relView setHidden:NO];
    
}
-(void)navgationTap:(id)tap{
    [self.nsMutable removeAllObjects];
    
    MYTapGestureRecognizer* myTap =  tap;
    NSMutableDictionary * dicOne =  myTap.dictionary;
    NSString * lon = [dicOne objectForKey:@"lon"];
      NSString * lat = [dicOne objectForKey:@"lat"];
    
    if ([self isOpenGaode]) {
        [self.nsMutable addObject:@"高德地图"];
    }
    if ([self isOpenBaidu]) {
        [self.nsMutable addObject:@"百度地图"];
    }
    if ([self isOpenApple]) {
        [self.nsMutable addObject:@"苹果地图"];
    }

    if ([self.nsMutable count] <= 0) {
        [self showToast:@"没有发现地图哦！"];
        return;
    }
    
//    NSMutableArray * sheetAlartViewList = [NSMutableArray array];
//    for (NSString * sheetString in self.nsMutable) {
//        XHGAlertAction * confirmAction = [XHGAlertAction actionWithTitle:sheetString style:XHGAlertActionStyleBoldOcean handler:^(XHGAlertAction *action, XHGAlertView *alertView) {
////            XHGAlertMenusView *customView = alertView.customView;
////            NSLog(@">>>>>>textViewContent:%@",customView.textView.text);
//            [self setToNavigation:action.title:lat:lon];
//        }];
//        [sheetAlartViewList addObject:confirmAction];
//    }
//    XHGAlertAction * cancleAction = [XHGAlertAction actionWithTitle:@"取消" style:XHGAlertActionStyleBoldBlack handler:nil];
//    [sheetAlartViewList addObject:cancleAction];
//    
//    XHGAlertView * alert = [XHGAlertView alertWithTopImage:nil title:nil message:@"选择地图" customizeContentView:nil actions:sheetAlartViewList] ;
//          [alert showSheet];
}
-(void)tapAction:(id)tap

{
    
   MYTapGestureRecognizer* myTap =  tap;
  NSMutableDictionary * dicOne =  myTap.dictionary;
        NSString * deviceId = [self getIntegerValue:[dicOne objectForKey:@"device_id"]];
      NSString * device_name = [dicOne objectForKey:@"device_name"];
       ReportDeviceViewController * nextVC = [[ReportDeviceViewController alloc] init];
          nextVC.deviceId = deviceId;
       nextVC.deviceName = device_name;
          [self.navigationController pushViewController:nextVC  animated:YES];
    
}


/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 取消选中的annotation views
 */

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
  //  [self.rel_total setHidden:NO];
    
    if ([self.relView isHidden]) {
        
        [self.relView setHidden:NO];
    }else{
        
        [self.relView setHidden:YES];
    }
  
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    myPosition = view.tag;
    
//    NSDictionary * dicOne  =   [self.dataMap objectAtIndex:myPosition];
//
//    NSString * deviceId = [self getIntegerValue:[dicOne objectForKey:@"device_id"]];

//    ReportDeviceViewController * nextVC = [[ReportDeviceViewController alloc] init];
//    nextVC.deviceId = deviceId;
//    nextVC.deviceGetArea = self.deviceGetArea;
//    nextVC.dataMap = self.dataMap;
//    nextVC->total = total;
//    nextVC.deviceStatusDictionary = self.deviceStatusDictionary;
//    [self.navigationController pushViewController:nextVC  animated:YES];
}





@end
