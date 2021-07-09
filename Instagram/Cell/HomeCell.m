//
//  HomeCell.m
//  Instagram
//
//  Created by Eva Xie on 7/6/21.
//

#import "HomeCell.h"

@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *profileTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(didTapProfile:)];
    [self.profileImage setUserInteractionEnabled:YES];
    [self.profileImage addGestureRecognizer:profileTap];
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
