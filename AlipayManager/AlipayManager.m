//
//  AlipayManager.m
//  AlipayManager
//
//  Created by wiseyep on 16/6/2.
//  Copyright © 2016年 wiseyep. All rights reserved.
//

#import "AlipayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

#define PrivateKey @""  //PKCS8格式私钥
#define PID @""    //开发者平台上商户PID
#define SellerID @""  //收款方支付宝账号

static AlipayManager *alipayManager = nil;

@implementation AlipayManager

+ (instancetype)sharedInstance {
    if (!alipayManager) {
        alipayManager = [[AlipayManager alloc] init];
    }
    return alipayManager;
}

- (instancetype)init {
    if (alipayManager) {
        return alipayManager;
    }
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)destory{
    alipayManager = nil;
}

//支付接口
- (void)alipayWithOrder_id:(NSString *)order_id title:(NSString *)title value:(NSString *)value price:(CGFloat)price {
    //创建订单
    Order *order = [[Order alloc] init];
    order.partner = PID;
    order.seller = SellerID;
    order.tradeNO = order_id;   //订单ID（商家自行定制）
    order.productName = title;            //商品标题
    order.productDescription = value;      //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",price]; //商品价格
    order.notifyURL = @""; //回调URL 填写支付宝付款后回调给服务器的地址
    
    //应用注册scheme,在Info.plist定义URL types
    NSString *appScheme = @"HPWCUserAlipay";
    
    //设置订单常量
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //拼接商品信息
    NSString *orderSpec = [order description];
    orderSpec = [orderSpec stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //对订单进行加密处理
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PrivateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        //判断是否安装支付宝客户端，也可以不判断，不判断如未安装客户端就调转网页支付
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
            NSLog(@"未安装支付宝客户端");
        }
        else {
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSString *resultString = resultDic[@"resultStatus"];
                if ([resultString isEqualToString:@"9000"]) {
                    //支付成功
                    
                }
                else {
                    //支付失败
                }
            }];
        }
    }
}

@end
