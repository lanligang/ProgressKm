//
//  LGProgresssView.m
//  ProgressDemo
//
//  Created by ios2 on 2018/7/31.
//  Copyright © 2018年 ios2. All rights reserved.
//

#import "LGProgresssView.h"

#import "UIView+LG_Frame.h"
#import "LGPopArrowView.h"

//最小高度
#define MINE_HEIGHT 35.0f
//最小宽度
#define MINE_WIDTH 200.0f

#define ITEM_WIDTH 35.0f

@implementation LGProgresssView{
	//开始的滑块
	UIView *_startItemView;
	//终点的滑块
	UIView *_endItemView;
	//中间的值
	UIView *_middleProgressView;
	LGPopArrowView*_startPopView;
	LGPopArrowView *_endPopView;
	//是否正在滑动
	BOOL _isSwiper;
}
-(instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_range = (LGRange){0,100};
		if (self.width<MINE_WIDTH) {
			self.width = MINE_WIDTH;
		}
		if (self.height<MINE_HEIGHT) {
			self.height = MINE_HEIGHT;
		}

		self.layer.masksToBounds = NO;
		self.backgroundColor =[UIColor greenColor];
		[self addItemView];
	}
	return self;
}

-(void)addItemView
{
	for (int i = 0; i<2; i++) {
		UIView *ItemView = [UIView new];
		ItemView.tag = 100+i;
		if (i==0) {
			ItemView.backgroundColor = [UIColor yellowColor];
			_startItemView = ItemView;
		}else{
			ItemView.backgroundColor = [UIColor redColor];
			_endItemView = ItemView;
		}

		ItemView.width = ITEM_WIDTH;
		ItemView.height =self.height;
		if (i==0) {
			ItemView.x = 0;
		}else{
			ItemView.x = self.width - ITEM_WIDTH;
		}
		ItemView.y = 0;
		[self addSubview:ItemView];
		UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onpan:)];
		[ItemView addGestureRecognizer:pan];
	}
	_middleProgressView = [UIView new];
	_middleProgressView.backgroundColor = [UIColor purpleColor];
	_middleProgressView.x = _startItemView.maxX;
	_middleProgressView.width = _endItemView.x - _startItemView.maxX;
	_middleProgressView.y = 0;
	_middleProgressView.height = self.height;
	[self addSubview:_middleProgressView];
	//开始的气泡
	{
	   LGPopArrowView *popView = [[LGPopArrowView alloc]initWithFrame:CGRectZero];
	   [self addSubview:popView];
	   popView.width = 45.0f;
	   popView.height = 35;
	   popView.centerX = _startItemView.centerX;
	   popView.y = _startItemView.y-35.0f;
	   _startPopView = popView;
	   popView.hidden = YES;
	   self.startPopStr = @"0";
	}
	//结束的气泡
	{
	   LGPopArrowView *popView = [[LGPopArrowView alloc]initWithFrame:CGRectZero];
	   popView.hidden = YES;
	   [self addSubview:popView];
	   popView.width = 45.0f;
	   popView.height = 35;
	   popView.centerX = _endItemView.centerX;
	   popView.y = _endItemView.y-35.0f;
	   _endPopView = popView;
	   self.endPopStr = @"100";
	}
}

#pragma mark 滑动手势
-(void)onpan:(UIPanGestureRecognizer *)pan
{
	UIView *panView = pan.view;
	if (panView.tag<100)return;
	BOOL isLeft = (panView.tag==100)?YES:NO;
	CGPoint point = [pan locationInView:self];
	if (pan.state==UIGestureRecognizerStateBegan) {
		_isSwiper = YES;
		if (self.delegate) {
			if ([self.delegate respondsToSelector:@selector(progressView:WillPan:)]) {
				[self.delegate progressView:self WillPan:_range];
			}
		}
		if (isLeft) {
			_endPopView.hidden = YES;
			_startPopView.hidden = NO;
			_startPopView.alpha = 0;
			[UIView animateWithDuration:0.2 animations:^{
				self->_startPopView.alpha = 1;
			}];
		}else{
			_endPopView.hidden = NO;
			_startPopView.hidden = YES;
			_endPopView.alpha = 0;
			[UIView animateWithDuration:0.2 animations:^{
				self->_endPopView.alpha = 1;
			}];
		}
	}else if (pan.state==UIGestureRecognizerStateChanged) {
		if (isLeft) {
             panView.x = point.x-panView.width;
			if (panView.x<=0) {
				panView.x = 0;
			}
		}else{
			panView.x = point.x;
			if ((panView.x+panView.width)>=self.width) {
				panView.x = self.width-panView.width;
			}
		}
		if (_startItemView.maxX>=_endItemView.x) {
			if (isLeft) {
				_startItemView.x = _endItemView.x-_startItemView.width;
			}else{
				_endItemView.x = _startItemView.maxX;
			}
		}
		_middleProgressView.width =  _endItemView.x - _startItemView.maxX;
		_middleProgressView.x = _startItemView.maxX;
		NSInteger start =((_middleProgressView.x-ITEM_WIDTH)/(self.width-ITEM_WIDTH*2.0f))*100;
		NSInteger end = ((_middleProgressView.maxX-ITEM_WIDTH)/(self.width-ITEM_WIDTH*2))*100;
         _startPopView.centerX = _startItemView.centerX;
		_endPopView.centerX = _endItemView.centerX;
		if ((start-end)>0) {
			start = end;
		}
		self.startPopStr = [NSString stringWithFormat:@"%ld 公里",(long)start];
		self.endPopStr = [NSString stringWithFormat:@"%ld 公里",(long)end];
		_range = (LGRange){start,end};
		if (self.delegate) {
			if ([self.delegate respondsToSelector:@selector(progressView:didChangedValue:)]) {
				[self.delegate progressView:self didChangedValue:_range];
			}
		}
	}else if(pan.state==UIGestureRecognizerStateEnded){
		_middleProgressView.width =  _endItemView.x - _startItemView.maxX;
		_middleProgressView.x = _startItemView.maxX;
		NSInteger start =((_middleProgressView.x-ITEM_WIDTH)/(self.width-ITEM_WIDTH*2.0f))*100;
		NSInteger end = ((_middleProgressView.maxX-ITEM_WIDTH)/(self.width-ITEM_WIDTH*2))*100;
		if ((start-end)>0) {
			start = end;
		}
		_range = (LGRange){start,end};
		if (self.delegate) {
			if ([self.delegate respondsToSelector:@selector(progressView:endPan:)]) {
				[self.delegate progressView:self endPan:_range];
			}
		}
		[UIView animateWithDuration:0.3 animations:^{
			self->_startPopView.alpha = 0;
			self->_endPopView.alpha = 0;
		}];
		_isSwiper = NO;
	}else if (pan.state==UIGestureRecognizerStateFailed){
		_isSwiper = NO;
	}
}
-(void)setRange:(LGRange)range
{
	_range = range;
}

-(void)setStartPopStr:(NSString *)startPopStr
{
	_startPopStr = startPopStr;
	_startPopView.textLable.text = startPopStr;
    CGFloat width = 	[_startPopView.textLable sizeThatFits:CGSizeMake(CGFLOAT_MAX, 10)].width+10.0f;
	if (width<35.0f) {
		width = 35.0f;
	}
	_startPopView.width = width;
	_startPopView.centerX = _startItemView.centerX;
	_endPopView.centerX = _endItemView.centerX;
}

-(void)setEndPopStr:(NSString *)endPopStr
{
	_endPopStr = endPopStr;
	_endPopView.textLable.text = endPopStr;
	CGFloat width = 	[_endPopView.textLable sizeThatFits:CGSizeMake(CGFLOAT_MAX, 10)].width+10.0f;
	if (width<35.0f) {
		width = 35.0f;
	}
	_endPopView.width = width;
	_startPopView.centerX = _startItemView.centerX;
	_endPopView.centerX = _endItemView.centerX;
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	self.layer.masksToBounds = NO;
	if (_range.lgStart==0&&_range.lgEnd==100) {
		_startItemView.width = ITEM_WIDTH;
		_startItemView.height =self.height;
		_startItemView.x = 0;
	     _startItemView.y = 0;
		_endItemView.width = ITEM_WIDTH;
		_endItemView.height =self.height;
		_endItemView.x = self.width - ITEM_WIDTH;
		_endItemView.y = 0;

		_startPopView.centerX = _startItemView.centerX;
		_endPopView.centerX = _endItemView.centerX;
		_middleProgressView.x = _startItemView.maxX;
		_middleProgressView.width = _endItemView.x - _startItemView.maxX;
		_middleProgressView.y = 0;
		_middleProgressView.height = self.height;
	}else{
		if (!_isSwiper) {
			//没有在滑动的时候
		   CGFloat gressWidth = 	self.width - ITEM_WIDTH*2.0f;
		   CGFloat a  = _range.lgStart*gressWidth/100.0f;
		  CGFloat b   = _range.lgEnd*gressWidth/100.0f;
			_startItemView.width = ITEM_WIDTH;
			_startItemView.height =self.height;
			_startItemView.x = a+ITEM_WIDTH;
			_startItemView.y = 0;
			_endItemView.width = ITEM_WIDTH;
			_endItemView.height =self.height;
			_endItemView.x = b + ITEM_WIDTH;
			_endItemView.y = 0;
			_startPopView.centerX = _startItemView.centerX;
			_endPopView.centerX = _endItemView.centerX;
			_middleProgressView.x = _startItemView.maxX;
			_middleProgressView.width = _endItemView.x - _startItemView.maxX;
			_middleProgressView.y = 0;
			_middleProgressView.height = self.height;
		}
	}
}

@end
