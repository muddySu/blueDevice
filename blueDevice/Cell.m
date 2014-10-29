//
//  Cell.m
//  UIPopoverListViewDemo
//
//  Created by 苏小龙 on 14-1-6.
//  Copyright (c) 2014年 su xinde. All rights reserved.
//

#import "Cell.h"

@implementation Cell
@synthesize devoiceNameLabel;
@synthesize connectLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        devoiceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 195, 30)];
        devoiceNameLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
        connectLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 120, 30)];
        connectLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
        [self.contentView addSubview:devoiceNameLabel];
        [self.contentView addSubview:connectLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
