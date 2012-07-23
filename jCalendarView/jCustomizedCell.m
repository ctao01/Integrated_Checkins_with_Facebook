//
//  jCustomizedCell.m
//  jCalendarView
//
//  Created by Joy Tao on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "jCustomizedCell.h"
#import "jAgendaViewController.h"
#import "jCustomizedView.h"

#import "NSDateFormatter+Extension.h"


@implementation jCustomizedCell
@synthesize datelabel, weekdayLabel;
@synthesize addButton;
@synthesize jArray = _jArray;
@synthesize tableViewController;

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    
    return [self.contentView hitTest:point withEvent:event]; // e04
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        // Initialization code
        self.weekdayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 18.0f)];
        self.weekdayLabel.frame = CGRectOffset(self.weekdayLabel.frame, 5.0f, 5.0f);
        self.weekdayLabel.font = [UIFont fontWithName:@"Courier-Oblique" size:13.0f];
        self.weekdayLabel.textAlignment = UITextAlignmentCenter;
        
        CGPoint weekdayLabelCenter = self.weekdayLabel.center;
        self.datelabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
//        self.datelabel.frame = CGRectOffset(self.weekdayLabel.frame, 5.0f, 20.0f);
        self.datelabel.center = CGPointMake(weekdayLabelCenter.x, weekdayLabelCenter.y + (self.weekdayLabel.frame.size.height + self.datelabel.frame.size.height)/2);
        self.datelabel.font = [UIFont fontWithName:@"Courier-Bold" size:20.0f];


//        self.addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
//        [self.addButton addTarget:vc action:@selector(tapButton:event:) forControlEvents:UIControlEventTouchUpInside];
//        self.addButton.frame = CGRectMake(290.0f, 5.0f, 24.0f, 24.0f);
        
//        [self.contentView addSubview:self.addButton];
        [self.contentView addSubview:self.weekdayLabel];
        [self.contentView addSubview:self.datelabel];
    }
    return self;
}

- (void) setJArray:(NSMutableArray *)jArray
{
    if (_jArray == jArray) return;
    [_jArray release];
    _jArray = [jArray retain];
    
    for (int c = 0; c < [jArray count]; c++) {
        jCustomizedView * jView = [[jCustomizedView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 220.0f, 40.0f)];
        jView.frame = CGRectOffset(jView.frame, 90.0f , (c+1)*5 + c*40.0f);
        [jView setBackgroundColor:[UIColor whiteColor]];
        
        jView.locationLabel.text = [[[jArray objectAtIndex:c] objectForKey:@"place"] objectForKey:@"name"];
        
         NSDate * thedate = [NSDateFormatter shortStyleDateFromString:[NSDateFormatter shortStyleStringFromDate:[NSDateFormatter dateFromISO8601String:[[jArray objectAtIndex:c] objectForKey:@"created_time"]]]];
        jView.timestampLabel.text = [NSDateFormatter timestampStringFromeDate:thedate];
        
        jAgendaViewController * vc = (jAgendaViewController*)self.tableViewController;
 UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:vc action:@selector(tapTheView:event:)];
        [tapGesture setNumberOfTapsRequired:1];
        [jView addGestureRecognizer:tapGesture];
        [jView setTag:c];
        [self.contentView addSubview:jView];
    }
    
}

//- (void) add:(id)sender
//{
//    NSLog(@"tap!");
//}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
