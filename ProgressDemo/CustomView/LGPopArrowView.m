//
//  LGPopArrowView.m
//  ProgressDemo
//
//  Created by ios2 on 2018/7/31.
//  Copyright © 2018年 ios2. All rights reserved.
//

#import "LGPopArrowView.h"
#import "UIView+LG_Frame.h"

@implementation LGPopArrowView{
	CAShapeLayer *_aMaskLayer;
	UIBezierPath *_maskPath;
	CGFloat  _radius;
	//角的宽高
	CGFloat _arrowWidth;
	CGFloat _arrwHeight;
}

-(instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_maskPath = [UIBezierPath bezierPath];
		_aMaskLayer =[CAShapeLayer layer];
		_aMaskLayer.strokeColor = [UIColor clearColor].CGColor;
		_aMaskLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f].CGColor;
		_aMaskLayer.path = _maskPath.CGPath;
		[self.layer insertSublayer:_aMaskLayer atIndex:0];
		//设置为4
		_arrowWidth = 10;
		_arrwHeight = 8;
		_radius = 4.0f;

		[self addSubview:self.textLable];
		
	}
	return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	CGFloat height = self.height;
	CGFloat width = self.width;
	[_maskPath removeAllPoints];

	CGPoint point0 = (CGPoint){_radius,0};
	CGPoint point1 = (CGPoint){width - _radius,0};
	CGPoint point2 = (CGPoint){width ,_radius};
	//加转角
   CGPoint point3 = (CGPoint){width ,height -_radius-_arrwHeight};
   CGPoint point4 = (CGPoint){width-_radius ,height -_arrwHeight};
  //加转角

	//箭头第一点
    CGPoint point5 = (CGPoint){width/2.0f+_arrowWidth/2.0f ,height -_arrwHeight};
    CGPoint point6 = (CGPoint){width/2.0f ,height };
	CGPoint point7 = (CGPoint){width/2.0f-_arrowWidth/2.0f ,height -_arrwHeight};
	//箭头结束

   CGPoint point8 = (CGPoint){_radius ,height -_arrwHeight};
   CGPoint point9 = (CGPoint){0 ,height -_arrwHeight-_radius};

	//点 10
	CGPoint point10 = (CGPoint){0 ,_radius};

	[_maskPath moveToPoint:point0];
	[_maskPath addLineToPoint:point1];
	[_maskPath addArcWithCenter:CGPointMake(point1.x, point2.y) radius:_radius startAngle:-M_PI*3/2.0f endAngle:0 clockwise:YES];

	[_maskPath addLineToPoint:point3];
	[_maskPath addArcWithCenter:CGPointMake(point4.x, point3.y) radius:_radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [_maskPath addLineToPoint:point5];
    [_maskPath addLineToPoint:point6];
	[_maskPath addLineToPoint:point7];
    [_maskPath addLineToPoint:point8];
	[_maskPath addArcWithCenter:CGPointMake(point8.x, point9.y) radius:_radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [_maskPath addLineToPoint:point10];
    [_maskPath addArcWithCenter:CGPointMake(point0.x, point10.y) radius:_radius startAngle:M_PI endAngle:M_PI*3/2.0f clockwise:YES];
   _aMaskLayer.path = _maskPath.CGPath;

	_textLable.width = width;
	_textLable.height =(height-_arrwHeight);
	_textLable.centerY = (height-_arrwHeight)/2.0f;
	_textLable.centerX = width/2.0f;
	
}

-(UILabel *)textLable
{
	if (!_textLable)
	 {
		_textLable = [[UILabel alloc]init];
		_textLable.textAlignment = NSTextAlignmentCenter;
		_textLable.text = @"123";
		_textLable.textColor = [UIColor whiteColor];
		_textLable.font = [UIFont systemFontOfSize:12.0f];
	 }
	return _textLable;
}




@end
