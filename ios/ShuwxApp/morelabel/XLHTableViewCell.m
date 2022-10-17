//
//  XLHTableViewCell.m
//  XLHLookMoreLabel
//
//  Created by 薛立恒 on 2019/3/6.
//  Copyright © 2019 薛立恒. All rights reserved.
//

#import "XLHTableViewCell.h"
#import "XLHLookMoreLabel.h"
#import "XLHModel.h"

@interface XLHTableViewCell ()<XLHAttributedLabelDelegate>

@end

@implementation XLHTableViewCell

#pragma mark - ======== life cycle ========

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.careTime];
          [self.contentView addSubview:self.carePerson];
         [self.contentView addSubview:self.setRunTimes];
        [self.contentView addSubview:self.label];
         [self.contentView addSubview:self.setRemarks];
        
    }
    return self;
}

#pragma mark - ======== XLHAttributedLabelDelegate ========

- (void)displayView:(XLHLookMoreLabel *)label openHeight:(CGFloat)height {
    if ([self.delegate respondsToSelector:@selector(tableViewCell:model:numberOfLines:)]) {
        [self.delegate tableViewCell:self model:_model numberOfLines:0];
//       int myHeight = height - 55;
//          _remakes.transform = CGAffineTransformTranslate(_remakes.transform, 0, myHeight);
    }
}

- (void)displayview:(XLHLookMoreLabel *)label closeHeight:(CGFloat)height {
    if ([self.delegate respondsToSelector:@selector(tableViewCell:model:numberOfLines:)]) {
        [self.delegate tableViewCell:self model:_model numberOfLines:3];
//        int myHeight = height - 55;
//         _remakes.transform = CGAffineTransformTranslate(_remakes.transform, 0,  - myHeight);
    }
}

#pragma mark - ======== getter ========
- (XLHLookMoreLabel *)label {
    if (!_label) {
        _label = [[XLHLookMoreLabel alloc]init];
        _label.delegate = self;
        _label.textColor = [UIColor blackColor];
        _label.backgroundColor = [UIColor clearColor];
        [_label setOpenString:@"【更多】" andCloseString:@"【收起】" andFont:[UIFont systemFontOfSize:16] andTextColor:[UIColor blueColor]];
    }
    return _label;
}

//拼接字符串
-(NSString *) getPinjieNSString:(NSString *) fromStr:(NSString *) toStr{
    if (nil == fromStr) {
        fromStr = @"";
    }
    if (nil == toStr) {
        toStr = @"";
    }
    NSString * pinjieStr = @"";
    pinjieStr = [fromStr stringByAppendingString:toStr];
    return pinjieStr;
}

-(void)setValues:(XLHModel *)model{
    _careTime.text = [self getPinjieNSString:@"保养时间：":model.careTime];
     _carePerson.text = [self getPinjieNSString:@"保养人：":model.carePerson];
     _runTime.text = [self getPinjieNSString:@"工作时长：":model.careWorkTimes];
      _remakes.text = [self getPinjieNSString:@"备注：":model.careRemares];
}

#pragma mark - ======== getter ========
- (UILabel *)careTime {
    if (!_careTime) {
        _careTime  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,200 , 20)];
        _careTime.text = @"保养时间：";
        _careTime.font = [UIFont systemFontOfSize:14];//采用系统默认文字设置大小
        _careTime.textColor = [UIColor blackColor];
        _careTime.backgroundColor = [UIColor clearColor];
     
    }
    return _careTime;
}
- (UILabel *)carePerson {
    if (!_carePerson) {
        _carePerson  = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 210, 10,200 , 20)];
        _carePerson.text = @"保养人：";
        _carePerson.font = [UIFont systemFontOfSize:14];//采用系统默认文字设置大小
        _carePerson.textColor = [UIColor blackColor];
        _carePerson.backgroundColor = [UIColor clearColor];
        
    }
    return _carePerson;
}
- (UILabel *)setRunTimes {
    if (!_runTime) {
       _runTime  = [[UILabel alloc] initWithFrame:CGRectMake(10, 30,SCREEN_WIDTH - 30 , 20)];
        _runTime.text = @"工作时长：";
        _runTime.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
        _runTime.textColor = [UIColor blackColor];
        _runTime.backgroundColor = [UIColor clearColor];
        
    }
    return _runTime;
}

#pragma mark - ======== setter ========
- (void)setModel:(XLHModel *)model {
    _model = model;
    [_label setText:model.title];
    _label.state = model.state;
    _label.numberOfLines = model.numberOfLines;
    CGSize size = [_label sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * 15, MAXFLOAT)];
    _label.frame = CGRectMake(10, 50, size.width, size.height);
    
    [self setRemarks:size];
}

- (UILabel *)setRemarks {
    if (!_remakes) {
        _remakes  = [[UILabel alloc] initWithFrame:CGRectMake(10, 70,SCREEN_WIDTH - 30 , 20)];
        _remakes.text = @"备注：";
        _remakes.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
        _remakes.textColor = [UIColor blackColor];
        _remakes.backgroundColor = [UIColor clearColor];
        
        //        [self setMyViews:mySize];
    }
    return _remakes;
}

- (void)setRemarks:(CGSize)mySize {
    _remakes.frame = CGRectMake(10, mySize.height + 50,SCREEN_WIDTH - 30 , 20);
  
}

- (UILabel *)setMyViews:(CGSize)mySize {
    if (!_myView) {
        _myView  = [[UILabel alloc] initWithFrame:CGRectMake(0, mySize.height + 70,SCREEN_WIDTH , 1)];
        _myView.backgroundColor = [UIColor blackColor];
        
    }
    return _myView;
}
@end
