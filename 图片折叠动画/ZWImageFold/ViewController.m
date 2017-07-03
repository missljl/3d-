//
//  ViewController.m
//  ZWImageFold
//
//  Created by 郑亚伟 on 2016/12/27.
//  Copyright © 2016年 郑亚伟. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *topImageV;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageV;
@property (weak, nonatomic) IBOutlet UIView *clearView;

@property(nonatomic,weak)CAGradientLayer *gradient;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //原本是正方形图片，设置图片的宽度是高度的2倍，这样才能保证图片拉动后的效果比例协调
    self.topImageV.bounds = CGRectMake(0, 0, 300, 150);
    self.topImageV.center = self.view.center;
    self.bottomImageV.bounds = CGRectMake(0, 0, 300, 150);
    self.bottomImageV.center = self.view.center;
    self.clearView.bounds = CGRectMake(0, 0, 300, 300);
    self.clearView.center = self.view.center;
    
    
    //上部分图片只显示上半部
    //x,y,宽,高的取值为0---1，是按照图片百分比计算的
    self.topImageV.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    self.topImageV.layer.anchorPoint = CGPointMake(0.5, 1);
    self.topImageV.userInteractionEnabled = YES;
    
    //下部分图片只显示下半部
    self.bottomImageV.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
    self.bottomImageV.layer.anchorPoint = CGPointMake(0.5, 0);
    self.bottomImageV.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.clearView addGestureRecognizer:pan];
    
    //底部图片添加渐变
    //这个是渐变层
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor];
    gradient.frame = self.bottomImageV.bounds;
    //设置不透明度
    gradient.opacity = 0;
    self.gradient = gradient;
     [self.bottomImageV.layer addSublayer:gradient];
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        //设置立体效果，近大远小
        CATransform3D transform = CATransform3DIdentity;
        //值越大，距离近的时候图像也越大。具体为什么使用m34不是很懂？？？？
        transform.m34 = -1 / 400.0;
        
        //拖动的距离
        CGPoint transP = [pan translationInView:self.clearView];
        //300是clearView的高度，即可以拉动的范围  -1是为了防止覆盖掉下半部分的图片
        CGFloat angle = transP.y * (M_PI-1) / 300.0;
        //上半部分图片做旋转
        self.topImageV.layer.transform = CATransform3DRotate(transform, -angle, 1, 0, 0);
        
        //设置不透明度  300是clearView的高度，即可以拉动的范围
        self.gradient.opacity = transP.y * M_PI / 300.0;

    }else if(pan.state == UIGestureRecognizerStateEnded){
        self.gradient.opacity = 0;
        
        //Damping是弹性系数，值越小，弹得越厉害
        //
        //弹簧动画
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.25 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            //让上部分图片反弹回去
            self.topImageV.layer.transform = CATransform3DIdentity;

        } completion:^(BOOL finished) {
            
        }];
    }
}


/*********************************************/
//渐变层知识点讲解
- (void)myGradient{
    //底部图片添加渐变
    //这个是渐变层
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = @[(id)[UIColor redColor].CGColor,(id)[UIColor greenColor].CGColor,(id)[UIColor blueColor].CGColor];
    gradient.frame = self.bottomImageV.bounds;
    //设置横的方向偏移
    /*
     对角渐变：
     gradient.startPoint = CGPointMake(0, 0);
     gradient.endPoint = CGPointMake(1, 0);
     */
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    //从哪一个位置渐变到下一个颜色
    gradient.locations = @[@0.2,@0.8];
    
    [self.bottomImageV.layer addSublayer:gradient];
}

@end
