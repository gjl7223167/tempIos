//
//  WorkJournalViewTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/18.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WorkJournalViewTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *logName;
@property (strong, nonatomic) IBOutlet UILabel *logContent;
@property (strong, nonatomic) IBOutlet UILabel *logTime;



@end

