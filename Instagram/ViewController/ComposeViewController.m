//
//  ComposeViewController.m
//  Instagram
//
//  Created by Eva Xie on 7/6/21.
//

#import "ComposeViewController.h"
#import <Parse/Parse.h>
#import "Post.h"



@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *composePhoto;
@property (weak, nonatomic) IBOutlet UITextField *composeCaption;
@property (strong, nonatomic) UIImage *resizedImage;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Instantiate a UIImagePickerController
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

// Implement the delegate method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    //call resize
    self.resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(300, 300)];

    // Do something with the images (based on your use case)
    [self.composePhoto setImage:self.resizedImage];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

// resize a UIImage
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)onTapCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)onTapShare:(id)sender {
    //send post to server
    
    [Post postUserImage:self.resizedImage withCaption:self.composeCaption.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            self.composeCaption.text = @"";
            NSLog(@"The message was saved!");
            
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
    
    
    //dismiss
    [self dismissViewControllerAnimated:true completion:nil];
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
