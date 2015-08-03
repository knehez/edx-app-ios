//
//  OEXDownloadTableCell.m
//  edXVideoLocker
//
//  Created by Jotiram Bhagat on 30/06/14.
//  Copyright (c) 2014 edX. All rights reserved.
//

#import "OEXDownloadTableCell.h"

@implementation OEXDownloadTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [self.lbl_title setTextAlignment:NSTextAlignmentNatural];
    [self.lbl_time setTextAlignment:NSTextAlignmentNatural];
    [self.lbl_totalSize setTextAlignment:NSTextAlignmentNatural];
    
    [self setAccessibilityLabels];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString *)accessibilityLabel {
    return self.lbl_title.text;
}

- (void) setAccessibilityLabels {
    [self.lbl_title accessibilityActivate];
    [self.lbl_title setAccessibilityLabel:self.lbl_title.text];
    [self.lbl_time setAccessibilityLabel:self.lbl_time.text];
    [self.lbl_totalSize setAccessibilityLabel:self.lbl_totalSize.text];
}


@end
