//
//  ButtonActionCell.m
//  CSchedule2.0
//
//  Created by Zoro Vu on 6/27/14.
//  Copyright (c) 2014 郭 晨. All rights reserved.
//

#import "ButtonActionCell.h"

@implementation ButtonActionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
