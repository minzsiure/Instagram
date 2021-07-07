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

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.captionLabel.text = self.post[@"caption"];

    
    //date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    // Configure the input format to parse the date string
    formatter.dateFormat = @"EEE MMM  d HH:mm:ss yyyy";
    NSDate *date = self.post.createdAt;

    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString *fullDate = [formatter stringFromDate:date];

    // Convert Date to String
    //self.dateLabel.text = [date.shortTimeAgoSinceNow stringByAppendingString:@" ago"];
    self.dateLabel.text = fullDate;

    //
    NSString *userID = self.post[@"userID"];
    if (userID != nil) {
        // User found! update username label with username
        self.usernameLabel.text = userID;
    } else {
        // No user found, set default username
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
