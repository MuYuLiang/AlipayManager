//
//  AlipayManager.h
//  AlipayManager
//
//  Created by wiseyep on 16/6/2.
//  Copyright © 2016年 wiseyep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlipayManager : NSObject

+ (instancetype)sharedInstance;
+ (void)destory;

- (void)alipayWithOrder_id:(NSString *)order_id title:(NSString *)title value:(NSString *)value price:(CGFloat)price;

@end
