//
//  RKATableViewCell.m
//  receiptkitapp
//
//  Created by Richard Stelling on 25/04/2014.
//  Copyright (c) 2014 Empirical Magic Ltd. All rights reserved.
//

#import "RKATableViewCell.h"

@implementation RKATableViewCell

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
