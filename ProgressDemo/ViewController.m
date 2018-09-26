//
//  ViewController.m
//  ProgressDemo
//
//  Created by ios2 on 2018/7/31.
//  Copyright © 2018年 ios2. All rights reserved.
//

#import "ViewController.h"
#import "LGProgresssView.h"

#import "Masonry.h"

@interface ViewController ()<LGProgresssViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	LGProgresssView *progressView = [[LGProgresssView alloc]initWithFrame:CGRectZero];
	progressView.delegate = self;
	[self.view addSubview:progressView];
	[progressView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(0);
		make.centerY.mas_equalTo(0);
		make.left.mas_equalTo(20.0f);
		make.right.mas_equalTo(-20.0f);
		make.height.mas_equalTo(40.0f);
	}];

}
	//已经滑动起来的代理
-(void)progressView:(LGProgresssView *)progressView didChangedValue:(LGRange)range
{
	NSLog(@" 开始  %@  ,  结束  %@",@(range.lgStart),@(range.lgEnd));
}
//开始滑动的代理
-(void)progressView:(LGProgresssView *)progressView WillPan:(LGRange)range
{
	NSLog(@" 开始  %@  ,  结束  %@",@(range.lgStart),@(range.lgEnd));
}

//结束滑动的代理
-(void)progressView:(LGProgresssView *)progressView endPan:(LGRange)range
{
	NSLog(@" 开始  %@  ,  结束  %@",@(range.lgStart),@(range.lgEnd));
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
