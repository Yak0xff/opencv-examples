//
//  ViewController.m
//  DetectingFaces
//
//  Created by Robin on 2/26/16.
//  Copyright © 2016 Robin. All rights reserved.
//

#import "ViewController.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

using namespace cv;

@interface ViewController (){
    CascadeClassifier faceDetector;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //加载级联分类器数据
    NSString *cascadePath  = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt" ofType:@"xml"];
    faceDetector.load([cascadePath UTF8String]);
    
    //加载人像图片
    UIImage *image = [UIImage imageNamed:@"demo.jpg"];
    Mat faceImage;
    UIImageToMat(image, faceImage);
    
    //转换为灰度图片
    Mat gray;
    cvtColor(faceImage, gray, CV_BGR2GRAY);
    
    //人脸识别
    std::vector<cv::Rect> faces;
    faceDetector.detectMultiScale(gray, faces, 1.1, 2, 0|CV_HAAR_SCALE_IMAGE, cv::Size(30, 30));
    
    //绘制出所有识别到的人脸
    for (unsigned int i = 0; i < faces.size(); i++) {
        const cv::Rect& face = faces[i];
        //获取左上角和右下角圆角点
        cv::Point tl(face.x, face.y);
        cv::Point br = tl + cv::Point(face.width, face.height);
        
        //绘制出人脸矩形
        cv::Scalar magenta = cv::Scalar(255, 0, 255);
        cv::rectangle(faceImage, tl, br, magenta, 4, 8, 0);
    }
    
    //显示出最终结果图像
    _imageView.image = MatToUIImage(faceImage);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
