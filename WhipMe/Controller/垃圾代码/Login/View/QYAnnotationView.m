//
//  QYAnnotationView.m
//  青云房产地图
//
//  Created by newqingyun on 15/11/14.
//  Copyright (c) 2015年 qingyun. All rights reserved.
//

#import "QYAnnotationView.h"
#import "MapResult.h"
//#import "NSString+StringSize.h"

@interface QYAnnotationView ()

{
    UIImage *image1;
    UIImage *image2;
}

@end
@implementation QYAnnotationView
//初始化QYAnnotationView
-(instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        //当为YES时，view被选中时会弹出气泡，annotation必须实现了title这个方法
        self.canShowCallout = NO;
        
        //[self setSelected:YES animated:YES];
        //self.calloutOffset = CGPointMake(0, 45);
        image1 = [UIImage imageNamed:@"快递员翻转前"];
        image2 = [UIImage imageNamed:@"快递员翻转后"];
        
    }
    return self;
}
//选中AnnotationView
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.image = [self getAnnotationImageTitle:_annotationData.title isSelcted:selected];
    
    //[self setPaopao];
    [self startAnimation];
    
}
//设置AnnotationView的annotationData，以及设置它的image
-(void)setAnnotationData:(MapResult *)annotationData
{
    _annotationData = annotationData;
 
    self.image = [self getAnnotationImageTitle:annotationData.title isSelcted:NO];
    
}

//根据标题、选中状态返回annotationView的image
-(UIImage *)getAnnotationImageTitle:(NSString *)title isSelcted:(BOOL)selected
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 87, 87)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.frame];
    
    [view addSubview:imageView];
    
    [self setImage:imageView andSelected:selected];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 70, 20)];
    label.text = [NSString stringWithFormat:@"%@",title];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:24];
    [view addSubview:label];
    
    
    return [self getImageFormView:view];
}

-(UIImage *)getImageFormView:(UIView *)view
{
    //创建一个跟view相同大小的上下文
    UIGraphicsBeginImageContext(view.bounds.size);
    //把view中的layer绘制到上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //返回一个基于当前上下文的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setPaopao
{
    UIView * myPaopaoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
   
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 70, 20)];
    label.text = [NSString stringWithFormat:@"12套"];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:12];
    [myPaopaoView addSubview:label];
    
    [myPaopaoView setBackgroundColor:[UIColor yellowColor]];
    
    BMKActionPaopaoView * paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:myPaopaoView];
   
    [self setPaopaoView:paopaoView];
    
    return;
}

-(void)startAnimation{
    
    [self performSelector:@selector(ActionRoate) withObject:nil afterDelay:1.5];
    //[self performSelector:@selector(otherAnimation) withObject:nil afterDelay:1.5];
    
}

-(void)otherAnimation{
    
    [UIView animateWithDuration:1.0 animations:^{
        //self.transform = CGAffineTransformRotate(self.transform, M_PI_4);
        //self.transform = CGAffineTransformScale(self.transform, 1.5, 1.5);
        //self.transform = CGAffineTransformTranslate(self.transform, 0, -10);
        
    }];
}

-(IBAction)ActionRoate{
    //获取当前画图的设备上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //开始准备动画
    [UIView beginAnimations:nil context:context];
    //设置动画曲线，翻译不准，见苹果官方文档
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //设置动画持续时间
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationDelay:1.0];
    //设置重复次数
    //[UIView setAnimationRepeatCount:10];
    
    //因为没给viewController类添加成员变量，所以用下面方法得到viewDidLoad添加的子视图
    //UIView *parentView = [self viewWithTag:1000];
    //设置动画效果
    //从上向下
    //[UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView:self cache:YES];
    //从下向上
    //[UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:self cache:YES];
    //从左向右
    
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    //从右向左
    //[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
    //设置动画委托
    [UIView setAnimationDelegate:self];
    //当动画执行结束，执行animationFinished方法
    //[UIView setAnimationDidStopSelector:@selector(animationFinished)];

    [self setImage:(UIImageView *)self andSelected:(self.image == image1)];
    
    //self.image = [UIImage imageNamed:@"快递员翻转后"];
    //提交动画
    [UIView commitAnimations];

}

- (void)animationFinished
{
    //[self startAnimation];
}

- (void)setImage:(UIImageView *)imageView andSelected:(BOOL)selected
{
    if (selected) {
        imageView.image = image2;
    }else{
        imageView.image = image1;
    }
}

@end
