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

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *postTableView;
@property (strong, nonatomic) NSArray *arrayofPosts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //set up a refresh controller
    
    // Do any additional setup after loading the view.
    self.postTableView.delegate = self;
    self.postTableView.dataSource = self;
    //[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
    [self onTimer];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.postTableView insertSubview:refreshControl atIndex:0];
    
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self onTimer];

    // Tell the refreshControl to stop spinning
    [refreshControl endRefreshing];

}

- (IBAction)logout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        [self dismissViewControllerAnimated:YES completion:nil];
        
        //jump to login view
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [[UIApplication sharedApplication].keyWindow setRootViewController: loginViewController];
        
    }];
    
}

- (void)onTimer {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
//    [query whereKey:@"likesCount" greaterThan:@100];
    //[query includeKey:@"user"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"detailSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.postTableView indexPathForCell:tappedCell];
        Post *posts = self.arrayofPosts[indexPath.row];
    
        DetailViewController *detailViewController = [segue destinationViewController];
    //pass the cell that's tapped
        detailViewController.post = posts;
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HomeCell *cell = [self.postTableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    
    
    
    Post *post = self.arrayofPosts[indexPath.row];
    NSLog(@"%@", post);
    
    cell.homeLabel.text = post[@"caption"];

    
    //date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // Configure the input format to parse the date string
    formatter.dateFormat = @"EEE MMM  d HH:mm:ss yyyy";
    NSDate *date = post.createdAt;
    
    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    //NSString *fullDate = [formatter stringFromDate:date]; full date
    
    // Convert Date to String
    cell.dateLabel.text = [date.shortTimeAgoSinceNow stringByAppendingString:@" ago"];
    
    
    //
    NSString *userID = post[@"userID"];
    if (userID != nil) {
        // User found! update username label with username
        cell.usernameLabel.text = userID;
    } else {
        // No user found, set default username
        cell.usernameLabel.text = @"🤖";
    }
    
    PFFileObject *image = post[@"image"];
    NSURL *imageURL = [NSURL URLWithString:image.url];
    cell.homeImage.image = nil;
    [cell.homeImage setImageWithURL:imageURL];
    

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayofPosts.count;
}






@end
