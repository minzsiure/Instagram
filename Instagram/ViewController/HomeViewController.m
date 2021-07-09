//
//  HomeViewController.m
//  Instagram
//
//  Created by Eva Xie on 7/6/21.
//

#import "HomeViewController.h"
#import <Parse/Parse.h>
#import "HomeCell.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"
#import <DateTools.h>
#import "LoginViewController.h"
#import "DetailViewController.h"
#import "OtherUserViewController.h"

//Add protocol delegate
@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *postTableView;
@property (strong, nonatomic) NSArray *arrayofPosts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;


@end

@implementation HomeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.postTableView.delegate = self;
    self.postTableView.dataSource = self;
    [self onTimer];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.postTableView insertSubview:refreshControl atIndex:0];
    
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self onTimer];
    [refreshControl endRefreshing];

}

- (IBAction)logout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [[UIApplication sharedApplication].keyWindow setRootViewController: loginViewController];
        
    }];
    
}

- (void)onTimer {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayofPosts = posts;
            [self.postTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"detailSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.postTableView indexPathForCell:tappedCell];
        Post *posts = self.arrayofPosts[indexPath.row];
    
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.post = posts;
    }

}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HomeCell *cell = [self.postTableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    
    
    Post *post = self.arrayofPosts[indexPath.row];
    NSLog(@"%@", post);
    cell.homeLabel.text = post[@"caption"];
    
    PFUser *user = post[@"author"];
    PFFileObject *profilePic = user[@"profilePic"];
    NSURL *profilePicURL = [NSURL URLWithString:profilePic.url];
    [cell.profileImage setImageWithURL:profilePicURL];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // Configure the input format to parse the date string
    formatter.dateFormat = @"EEE MMM  d HH:mm:ss yyyy";
    NSDate *date = post.createdAt;
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    cell.dateLabel.text = [date.shortTimeAgoSinceNow stringByAppendingString:@" ago"];
    
    NSString *userID = post[@"userID"];
    if (userID != nil) {
        cell.usernameLabel.text = userID;
    } else {
        cell.usernameLabel.text = @"🤖";
    }
    
    PFFileObject *image = post[@"image"];
    NSURL *imageURL = [NSURL URLWithString:image.url];
    cell.homeImage.image = nil;
    [cell.homeImage setImageWithURL:imageURL];
    cell.profileImage.layer.cornerRadius = 25;
    cell.profileImage.clipsToBounds = YES;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayofPosts.count;
}






@end
