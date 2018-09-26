//
//  LGProgresssView.h
//  ProgressDemo
//
//  Created by ios2 on 2018/7/31.
//  Copyright © 2018年 ios2. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct LGProgressRange {
	NSInteger lgStart;
	NSInteger lgEnd;
} LGRange;

@class LGProgresssView;

@protocol LGProgresssViewDelegate <NSObject>
@optional

//已经滑动起来的代理
-(void)progressView:(LGProgresssView *)progressView didChangedValue:(LGRange)range;

//开始滑动的代理
-(void)progressView:(LGProgresssView *)progressView WillPan:(LGRange)range;

//结束滑动的代理
-(void)progressView:(LGProgresssView *)progressView endPan:(LGRange)range;


@end

@interface LGProgresssView : UIView
/*
 * 1~100
 */
@property(nonatomic,assign)LGRange range;

@property(nonatomic,weak)id <LGProgresssViewDelegate>delegate;

//开始的
@property (nonatomic,strong)NSString *startPopStr;
//结束的
@property (nonatomic,strong)NSString *endPopStr;


@end
