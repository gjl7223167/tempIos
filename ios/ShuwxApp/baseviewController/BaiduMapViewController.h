//
//  BaiduMapViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/10/20.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface BaiduMapViewController : MainViewController<BMKMapViewDelegate, BMKLocationManagerDelegate>{
    BMKMapView *_mapView;
}
@property (nonatomic,strong) NSString * mCurrentLat;
@property (nonatomic,strong) NSString * mCurrentLon;

-(NSString *)getBaiduLat;
-(NSString *)getBaiduLon;
-(BOOL)isRange:(NSString *)mYLat :(NSString *)mYLon;
-(void)resStart;

@end

