//
//  HomeCell.h
//  Instagram
//
//  Created by Eva Xie on 7/6/21.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *homeImage;
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;


@end

NS_ASSUME_NONNULL_END
