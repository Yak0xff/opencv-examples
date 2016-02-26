//
//  ViewController.m
//  LinkingOpenCV
//
//  Created by Robin on 2/25/16.
//  Copyright © 2016 Robin. All rights reserved.
//

#import "ViewController.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

using namespace cv;

@interface ViewController (){
    
    Mat cvImage;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 图片载入和转换方式
    UIImage *image = [UIImage imageNamed:@"animal.jpg"];
    //将UIImage* 转换为 cv::Mat
    UIImageToMat(image, cvImage);
    
    if (!cvImage.empty()) {
        Mat gray;
        //将图像转换为灰度图
        cvtColor(cvImage, gray, CV_RGB2GRAY);
        //利用高斯滤波清除边缘
        GaussianBlur(gray, gray, cv::Size(5, 5), 1.2, 1.2);
        //利用Canny算法计算边缘
        Mat edges;
        Canny(gray, edges, 0, 50);
        //使用白色填充图像(图像背景色)
        cvImage.setTo(Scalar::all(255));
        //改变边缘颜色
        cvImage.setTo(Scalar(0, 128, 255, 255), edges);
        
        //将cv::Mat转换为UIImage *
        _imageView.image = MatToUIImage(cvImage);
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
