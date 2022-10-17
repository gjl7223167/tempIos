//
//  NoDataView.m
//  ShuwxApp
//
//  Created by 徐伟 on 2021/9/23.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "NoDataView.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@implementation NoDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)initSubViewsWithTip:(NSString *)tiptext{
    UIImageView *imagev = [[UIImageView alloc] init];
    imagev.image = [UIImage imageNamed:@"mes_noworkdetail"];
    imagev.frame = CGRectMake(0, 0, 198, 98);
    imagev.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/3);
    [self addSubview:imagev];
    
    UILabel *bottomL = [[UILabel alloc] initWithFrame:CGRectMake(10, imagev.center.y + 49 + 34, self.bounds.size.width - 20, 20)];
    bottomL.textColor = RGBA(153, 153, 153, 1);
    bottomL.font = [UIFont systemFontOfSize:14];
    bottomL.textAlignment = NSTextAlignmentCenter;
    bottomL.text = tiptext;
    [self addSubview:bottomL];
}

@end
