//
//  LoginBaseViewController.h
//  ShuwxApw
//
//  Dreated by apple on 2018/11/21.
//  Copyright © 2018年 tiantuosifang. All rights reserved.
//

#import "DBBaseViewController.h"
#import "CKAlertViewController.h"

@interface LoginBaseViewController : DBBaseViewController
-(void)clearCookie;
-(id) getMyResult:(id)responseObject;
-(NSString *)getError:(NSError *)error;
-(void)setSaveAppStamp:(NSMutableDictionary *)dictionary;
@end

