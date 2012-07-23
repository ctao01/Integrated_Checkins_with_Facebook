//
//  jCustomizedView.m
//  jCalendarView
//
//  Created by Joy Tao on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "jCustomizedView.h"

@implementation jCustomizedView
@synthesize locationLabel , timestampLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.timestampLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f , 18.0f)];
        self.timestampLabel.frame = CGRectOffset(self.timestampLabel.frame, 2.0f, 2.0f);
//        self.timestampLabel.textColor = [UIColor darkGrayColor];
        self.timestampLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
        self.timestampLabel.textColor = [UIColor purpleColor];
        self.timestampLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.timestampLabel.numberOfLines = 0;
        
        self.locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 133.0f, 36.0f)];
        self.locationLabel.frame = CGRectOffset(self.locationLabel.frame, 65.0f , 2.0f);
        self.locationLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
        self.locationLabel.textColor = [UIColor darkGrayColor];
//        self.locationLabel.backgroundColor = [UIColor lightGrayColor];
        self.locationLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.locationLabel.numberOfLines = 0;
        
        UIButton * addButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        addButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
        
        CGRect labelFrame = self.locationLabel.frame;
        CGRect buttonFrame = addButton.frame;
//        CGRect viewFrame = self.frame;
        addButton.center = CGPointMake(
                                       self.locationLabel.center.x + 2 + (labelFrame.size.width + buttonFrame.size.width)/2, 
                                       self.locationLabel.center.y);
//        addButton.frame = CGRectOffset(addButton.frame, viewFrame.size.width - buttonFrame.size.width -2 , 2.0f);
        [self addSubview:addButton];
        
        [self addSubview:self.timestampLabel];
        [self addSubview:self.locationLabel];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
