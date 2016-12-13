//
//  ViewController.m
//  ClipCorner
//
//  Created by caokun on 16/12/10.
//  Copyright © 2016年 caokun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIImageView *imageV1;
@property (strong, nonatomic) UIImageView *imageV2;
@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIButton *buttonCk;
@property (strong, nonatomic) UIButton *buttonCoreGraphics;
@property (strong, nonatomic) UIButton *buttonBezier;

@end

@implementation ViewController

- (UIImageView *)imageV1 {
    if (_imageV1 == nil) {
        _imageV1 = [[UIImageView alloc] init];
        _imageV1.contentMode = UIViewContentModeScaleAspectFit;
        _imageV1.layer.borderColor = [UIColor blackColor].CGColor;
        _imageV1.layer.borderWidth = 1.0;
        _imageV1.frame = CGRectMake(40, 55, 200, 200);
    }
    return _imageV1;
}

- (UIImageView *)imageV2 {
    if (_imageV2 == nil) {
        _imageV2 = [[UIImageView alloc] init];
        _imageV2.contentMode = UIViewContentModeScaleAspectFit;
        _imageV2.layer.borderColor = [UIColor blackColor].CGColor;
        _imageV2.layer.borderWidth = 1.0;
        _imageV2.frame = CGRectMake(40, 310, 200, 200);
    }
    return _imageV2;
}

- (UILabel *)label1 {
    if (_label1 == nil) {
        _label1 = [[UILabel alloc] init];
        _label1.text = @"原图";
        _label1.frame = CGRectMake(40, 30, 40, 20);
    }
    return _label1;
}

- (UILabel *)label2 {
    if (_label2 == nil) {
        _label2 = [[UILabel alloc] init];
        _label2.text = @"结果图";
        _label2.frame = CGRectMake(40, 280, 70, 20);
    }
    return _label2;
}

- (UIButton *)button {
    if (_button == nil) {
        _button = [[UIButton alloc] init];
        [_button setTitle:@"计算" forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor blueColor];
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _button.frame = CGRectMake(40, 530, 70, 30);
    }
    return _button;
}

- (UIButton *)buttonCk {
    if (_buttonCk == nil) {
        _buttonCk = [[UIButton alloc] init];
        [_buttonCk setTitle:@"my裁剪" forState:UIControlStateNormal];
        _buttonCk.backgroundColor = [UIColor blueColor];
        [_buttonCk addTarget:self action:@selector(buttonActionCk:) forControlEvents:UIControlEventTouchUpInside];
        _buttonCk.frame = CGRectMake(40, 580, 80, 30);
    }
    return _buttonCk;
}

- (UIButton *)buttonCoreGraphics {
    if (_buttonCoreGraphics == nil) {
        _buttonCoreGraphics = [[UIButton alloc] init];
        [_buttonCoreGraphics setTitle:@"CG裁剪" forState:UIControlStateNormal];
        _buttonCoreGraphics.backgroundColor = [UIColor blueColor];
        [_buttonCoreGraphics addTarget:self action:@selector(buttonActionCG:) forControlEvents:UIControlEventTouchUpInside];
        _buttonCoreGraphics.frame = CGRectMake(130, 580, 80, 30);
    }
    return _buttonCoreGraphics;
}

- (UIButton *)buttonBezier {
    if (_buttonBezier == nil) {
        _buttonBezier = [[UIButton alloc] init];
        [_buttonBezier setTitle:@"贝塞尔裁剪" forState:UIControlStateNormal];
        _buttonBezier.backgroundColor = [UIColor blueColor];
        [_buttonBezier addTarget:self action:@selector(buttonActionBe:) forControlEvents:UIControlEventTouchUpInside];
        _buttonBezier.frame = CGRectMake(220, 580, 100, 30);
    }
    return _buttonBezier;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.view addSubview:self.label1];
    [self.view addSubview:self.imageV1];
    [self.view addSubview:self.label2];
    [self.view addSubview:self.imageV2];
    [self.view addSubview:self.button];
    [self.view addSubview:self.buttonCk];
    [self.view addSubview:self.buttonCoreGraphics];
    [self.view addSubview:self.buttonBezier];
    
    UIImage *image = [UIImage imageNamed:@"lena"];
    self.imageV1.image = image;
}

- (void)buttonAction:(UIButton *)b {
    UIImage *image = [UIImage imageNamed:@"lena"];
    UIImage *img = [self dealImage:image cornerRadius:100];
    // 使用方法：只需把 - (UIImage *)dealImage:(UIImage *)img cornerRadius:(CGFloat)c;
    // 把这个方法的代码复制到对应项目中就可用了，暂时没封装成库，以后方法多起来会封装的。
    self.imageV2.image = img;
}

// ------------------ 以下是速度测试 ---------------------
static int count = 10000;               // 1万次调用测试
static NSString *imgName = @"lena";     // 512 * 512, RGBA 的实验图像
static CGFloat radius = 100;             // 圆角大小，单位是像素点

- (void)buttonActionCk:(UIButton *)b {
    UIImage *image = [UIImage imageNamed:imgName];
    
    NSLog(@"---start");
    time_t t1 = clock();
    for (int i=0; i<count; i++) {
        [self dealImage:image cornerRadius:radius];
    }
    time_t t2 = clock();
    NSLog(@"my裁剪用时：%.3f 秒", ((float)(t2 - t1)) / CLOCKS_PER_SEC);
}

- (void)buttonActionCG:(UIButton *)b {
    UIImage *image = [UIImage imageNamed:imgName];
    
    NSLog(@"---start");
    time_t t1 = clock();
    for (int i=0; i<count; i++) {
        [self CGContextClip:image cornerRadius:radius];
    }
    time_t t2 = clock();
    NSLog(@"CGContext裁剪用时：%.3f 秒", ((float)(t2 - t1)) / CLOCKS_PER_SEC);
}

- (void)buttonActionBe:(UIButton *)b {
    UIImage *image = [UIImage imageNamed:imgName];
    
    NSLog(@"---start");
    time_t t1 = clock();
    for (int i=0; i<count; i++) {
        [self UIBezierPathClip:image cornerRadius:radius];
    }
    time_t t2 = clock();
    NSLog(@"贝塞尔裁剪用时：%.3f 秒", ((float)(t2 - t1)) / CLOCKS_PER_SEC);
}

// CGContext 裁剪
- (UIImage *)CGContextClip:(UIImage *)img cornerRadius:(CGFloat)c {
    int w = img.size.width * img.scale;
    int h = img.size.height * img.scale;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, c);
    CGContextAddArcToPoint(context, 0, 0, c, 0, c);
    CGContextAddLineToPoint(context, w-c, 0);
    CGContextAddArcToPoint(context, w, 0, w, c, c);
    CGContextAddLineToPoint(context, w, h-c);
    CGContextAddArcToPoint(context, w, h, w-c, h, c);
    CGContextAddLineToPoint(context, c, h);
    CGContextAddArcToPoint(context, 0, h, 0, h-c, c);
    CGContextAddLineToPoint(context, 0, c);
    CGContextClosePath(context);
    
    CGContextClip(context);     // 先裁剪 context，再画图，就会在裁剪后的 path 中画
    [img drawInRect:CGRectMake(0, 0, w, h)];       // 画图
    CGContextDrawPath(context, kCGPathFill);
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return ret;
}

// UIBezierPath 裁剪
- (UIImage *)UIBezierPathClip:(UIImage *)img cornerRadius:(CGFloat)c {
    int w = img.size.width * img.scale;
    int h = img.size.height * img.scale;
    CGRect rect = CGRectMake(0, 0, w, h);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:c] addClip];
    [img drawInRect:rect];
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return ret;
}


// ------------------------------------------------------------------
// --------------------- 以下是自定义图像处理部分 -----------------------
// ------------------------------------------------------------------

// 自定义裁剪算法
- (UIImage *)dealImage:(UIImage *)img cornerRadius:(CGFloat)c {
    // 1.CGDataProviderRef 把 CGImage 转 二进制流
    CGDataProviderRef provider = CGImageGetDataProvider(img.CGImage);
    void *imgData = (void *)CFDataGetBytePtr(CGDataProviderCopyData(provider));
    int width = img.size.width * img.scale;
    int height = img.size.height * img.scale;
    
    // 2.处理 imgData
//    dealImage(imgData, width, height);
    cornerImage(imgData, width, height, c);
    
    // 3.CGDataProviderRef 把 二进制流 转 CGImage
    CGDataProviderRef pv = CGDataProviderCreateWithData(NULL, imgData, width * height * 4, releaseData);
    CGImageRef content = CGImageCreate(width , height, 8, 32, 4 * width, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast, pv, NULL, true, kCGRenderingIntentDefault);
    UIImage *result = [UIImage imageWithCGImage:content];
    free(imgData);      // 释放空间
    
    return result;
}

void releaseData(void *info, const void *data, size_t size) {
    free((void *)data);
}

// 在 img 上处理图片, 测试用
void dealImage(UInt32 *img, int w, int h) {
    int num = w * h;
    UInt32 *cur = img;
    for (int i=0; i<num; i++, cur++) {
        UInt8 *p = (UInt8 *)cur;
        // RGBA 排列
        // f(x) = 255 - g(x) 求负片
        p[0] = 255 - p[0];
        p[1] = 255 - p[1];
        p[2] = 255 - p[2];
        p[3] = 255;
    }
}

// 裁剪圆角
void cornerImage(UInt32 *const img, int w, int h, CGFloat cornerRadius) {
    CGFloat c = cornerRadius;
    CGFloat min = w > h ? h : w;
    
    if (c < 0) { c = 0; }
    if (c > min * 0.5) { c = min * 0.5; }
    
    // 左上 y:[0, c), x:[x, c-y)
    for (int y=0; y<c; y++) {
        for (int x=0; x<c-y; x++) {
            UInt32 *p = img + y * w + x;    // p 32位指针，RGBA排列，各8位
            if (isCircle(c, c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
    // 右上 y:[0, c), x:[w-c+y, w)
    int tmp = w-c;
    for (int y=0; y<c; y++) {
        for (int x=tmp+y; x<w; x++) {
            UInt32 *p = img + y * w + x;
            if (isCircle(w-c, c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
    // 左下 y:[h-c, h), x:[0, y-h+c)
    tmp = h-c;
    for (int y=h-c; y<h; y++) {
        for (int x=0; x<y-tmp; x++) {
            UInt32 *p = img + y * w + x;
            if (isCircle(c, h-c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
    // 右下 y~[h-c, h), x~[w-c+h-y, w)
    tmp = w-c+h;
    for (int y=h-c; y<h; y++) {
        for (int x=tmp-y; x<w; x++) {
            UInt32 *p = img + y * w + x;
            if (isCircle(w-c, h-c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
}

// 判断点 (px, py) 在不在圆心 (cx, cy) 半径 r 的圆内
static inline bool isCircle(float cx, float cy, float r, float px, float py) {
    if ((px-cx) * (px-cx) + (py-cy) * (py-cy) > r * r) {
        return false;
    }
    return true;
}

// 其他图像效果可以自己写函数，然后在 dealImage: 中调用 otherImage 即可
void otherImage(UInt32 *const img, int w, int h) {
    // 自定义处理
}

@end
