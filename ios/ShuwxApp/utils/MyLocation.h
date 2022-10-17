//
//  MyLocation.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/10/20.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <CoreLocation/CLLocation.h>
#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@class CLLocation;
@class CLHeading;

@interface MyLocation : BMKUserLocation

-(id)initWithLocation:(CLLocation *)loc withHeading:(CLHeading *)head;

@end

