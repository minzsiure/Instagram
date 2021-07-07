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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HomeCell *cell = [self.postTableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    
    
    Post *post = self.arrayofPosts[indexPath.row];
    NSLog(@"%@", post[@"image"]);
    cell.homeLabel.text = post[@"caption"];
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