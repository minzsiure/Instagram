//
//  DetailViewController.m
//  Instagram
//
//  Created by Eva Xie on 7/7/21.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import <DateTools.h>
#import "Post.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.captionLabel.text = self.post[@"caption"];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    // Configure the input format to parse the date string
    formatter.dateFormat = @"EEE MMM  d HH:mm:ss yyyy";
    NSDate *date = self.post.createdAt;

    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString *fullDate = [formatter stringFromDate:date];

    self.dateLabel.text = fullDate;
    
    PFUser *user = self.post[@"author"];
    PFFileObject *profilePic = user[@"profilePic"];
    NSURL *profilePicURL = [NSURL URLWithString:profilePic.url];
    [self.profileImage setImageWithURL:profilePicURL];
    self.profileImage.layer.cornerRadius = 25;
    self.profileImage.clipsToBounds = YES;

    
    NSString *userID = self.post[@"userID"];
    if (userID != nil) {
        self.usernameLabel.text = userID;
    } else {
        self.usernameLabel.text = @"🤖";
    }
    
    PFFileObject *image = self.post[@"image"];
    NSURL *imageURL = [NSURL URLWithString:image.url];
    self.postImageLabel.image = nil;
    [self.postImageLabel setImageWithURL:imageURL];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
