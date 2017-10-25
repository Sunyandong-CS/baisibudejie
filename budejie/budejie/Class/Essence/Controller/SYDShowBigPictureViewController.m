//
//  SYDShowBigPictureViewController.m
//  budejie
//
//  Created by 孙艳东 on 2017/10/21.
//  Copyright © 2017年 com.xididan. All rights reserved.
//
#import <Photos/Photos.h>
#import "SYDShowBigPictureViewController.h"
#import <UIImageView+WebCache.h>
#import "UIView+frame.h"
#import "SYDTopicModel.h"
#import <SVProgressHUD.h>

@interface SYDShowBigPictureViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
/* 设置scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/* 设置imageView */
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation SYDShowBigPictureViewController

- (PHAssetCollection *)createdCollection {
    // 0.获取应用名称
    NSString *title = [NSBundle mainBundle].infoDictionary[(__bridge NSString*)kCFBundleNameKey];
    // 1.获取所有自定义相册
   PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 2.判断是否创建过相册
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    
    /** 当前APP相册没有被创建过 **/
    // 3.创建一个自定义相册
    NSError *error = nil;
    __block NSString *createdCollectionId = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) return nil;
    
    // 4.根据唯一标识符获取创建的应用相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionId] options:nil].firstObject;
}

- (PHFetchResult<PHAsset *> *) createdAsset {
    
    NSError *error = nil;
    __block NSString *assetId = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetId = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    
    if (error) {
        return nil;
    }
    
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil];
}


- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)savePicture:(UIButton *)sender {
    
    // C代码保存图片到相册，但无法创建相册
    // UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    /* 使用photos框架 */
//    PHAuthorizationStatusNotDetermined = 0, // User has not yet made a choice with regards to this application
//    PHAuthorizationStatusRestricted,        // This application is not authorized to access photo data.
//    // The user cannot change this application’s status, possibly due to active restrictions
//    //   such as parental controls being in place.
//    PHAuthorizationStatusDenied,            // User has explicitly denied this application access to photos data.
//    PHAuthorizationStatusAuthorized         // User has authorized this application to access photos data.
    /* 0.相册权限判断 */
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusDenied) { // 用户拒绝App访问相册
                NSLog(@"请到通用中打开权限");
            } else if(status == PHAuthorizationStatusAuthorized) {
                [self saveImageToAlbum];
            } else if (status == PHAuthorizationStatusRestricted) {
                [SVProgressHUD showErrorWithStatus:@"由于系统原因m,无法访问相册"];
            }
        });
    }];
    
}

- (void) saveImageToAlbum {
    // 1.获取要保存到album图片
    PHFetchResult<PHAsset *> *createAssets = [self createdAsset];
    if (createAssets == nil) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败！"];
        return ;
    }
    // 2.获取或创建应用相册
    PHAssetCollection *createdCollection = [self createdCollection];
    if (createdCollection == nil) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败！"];
        return ;
    }
    
    // 3.添加保存的图片到[应用自定义相册]
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 创建一个请求改变对象
        PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        
        // 插入图片
        [changeRequest insertAssets:createAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
        
    } error:&error];
    
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败！"];
    }else {
        [SVProgressHUD showSuccessWithStatus:@"保存图片成功！"];
    }
    
    
}




//- (void)image:(UIImage *)image
//        didFinishSavingWithError:(NSError *)error
//        contextInfo:(void *)contextInfo {
//    if (error) {
//        [SVProgressHUD showErrorWithStatus:@"保存失败!"];
//    } else {
//        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    //    scrollView.frame = self.view.bounds;
    //    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.frame = [UIScreen mainScreen].bounds;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToBack)]];
    [self.view insertSubview:scrollView atIndex:0];
    self.scrollView = scrollView;
    
    // imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
        self.saveButton.enabled = YES;
    }];
    imageView.width = scrollView.width;
    imageView.height = imageView.width * self.topic.height / self.topic.width;
    imageView.x = 0;
    if (imageView.height > [UIScreen mainScreen].bounds.size.height) { // 超过一个屏幕
        imageView.y = 0;
        scrollView.contentSize = CGSizeMake(0, imageView.height);
    } else {
        imageView.centerY = scrollView.height * 0.5;
    }
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    // 添加缩放手势
    CGFloat maxScale = self.topic.width / scrollView.width;
    if (maxScale > 1) {
        scrollView.maximumZoomScale = maxScale;
        scrollView.delegate = self;
    }
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.imageView;
}


- (void)tapToBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
