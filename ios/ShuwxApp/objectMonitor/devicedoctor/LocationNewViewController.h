//
//  LocationNewViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/5/5.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <MapKit/MapKit.h>
#import <UMCommon/MobClick.h>
#import "MYTapGestureRecognizer.h"
#import "ReportDeviceViewController.h"

@interface LocationNewViewController : MainViewController<BMKMapViewDelegate>{
     int myPosition;
@public int total; 
}
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *rel_total;
@property (weak, nonatomic) IBOutlet UIView *relView;

@property (weak, nonatomic) IBOutlet UILabel *deviceTotal;

@property (nonatomic, strong) BMKPinAnnotationView * bmkPinAnnotation;
@property (nonatomic, strong) NSString * bmkCode;
@property (nonatomic,strong) NSMutableArray *dataMap;

@property (weak, nonatomic) IBOutlet UILabel *deviceName;// 设备名称
@property (weak, nonatomic) IBOutlet UILabel *deviceCode; // 设备编号
@property (weak, nonatomic) IBOutlet UILabel *runTime; // 设备运行时间
@property (weak, nonatomic) IBOutlet UILabel *deviceStateName;
@property (weak, nonatomic) IBOutlet UIImageView *imagedevice;

@property (nonatomic,strong) NSMutableArray * nsMutable;

@property (strong, nonatomic) IBOutlet UILabel *navigateButon;


@end

