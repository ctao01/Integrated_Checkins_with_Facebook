//
//  jCustomizedCell.h
//  jCalendarView
//
//  Created by Joy Tao on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface jCustomizedCell : UITableViewCell

@property (nonatomic , assign) UIViewController * tableViewController;

@property (nonatomic , retain) UILabel * datelabel;
@property (nonatomic , retain) UILabel * weekdayLabel;

@property (nonatomic , retain) UIButton * addButton;

@property (nonatomic , retain) NSMutableArray * jArray; 

@end


