# AlipayManager
对支付宝SDK的一个简单的封装

支付宝的demo 一般的常见问题解决

1 No architecutures to compile for (ONLY_ACTIVE_ARCH = YES, active arch = x86_64,VALID_ARCHS = i386)

出现这样的问题一般是 将 64 位编译进去就能解决了（这个问题只要你下载的是最新的demo一般很少见了 ）

解决方案：

targets -> Architectures 下面的Valid Architectures 添加上 arm64

2 将支付宝的第三方添加到项目中的时候 有时 会出现 openssl 文件中的.h 文件报错 说此文件不能被找到

出现这样的问题是 的原因一般是添加的路径 不对

解决方案：

点击项目名称，点击“Build Settings”选项卡，在搜索框中，以关键字“search”搜索，对“Header Search Paths” 增加头文件路径：$(SRCROOT)/文件路径 设置一下路径 一般都能解决。

3  Cannot find interface declaration for "NSObject", supercalss of 'Base64'

解决方案   打开报错的文件，增加头文件

// #import <Foundation/Foundation.h>

基本上支付宝中的demo 里面的问题一般都会得到解决。然后 看着demo 跟实际的项目结合一下就ok 了
正式开始  支付宝教程：

1、生成RSA公钥私钥
打开终端输入：openssl
OpenSSL> genrsa -out rsa_private_key.pem 1024 生成私钥
OpenSSL> pkcs8 -topk8 -inform PEM -in rsa_private_key.pem -outform PEM -nocrypt  将私钥换成PKCS8格式  （加密需要用的）
OpenSSL> rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem  生成公钥
OpenSSL> exit  退出

上传公钥
登录b.alipay.com  -> 我的商家服务 -> 查询PID、Key -> 输入密码确认 -> 合作伙伴密钥管理（RSA加密－添加密钥－复制输入公钥）-> 确认上传

2、集成支付宝SDK
下载支付宝demo
将AlipaySDK.bundle、AlipaySDK.framework、libcrypto.a、libssl.a、openssl文件夹、Util文件夹、Order.h、Order.m拖入工程。
加入白名单
Info.plist  ->  LSApplicationQueriesSchemes  -><Array类型>  +  ->  alipay
添加静态库
Build Phases -> Link Binary With Libraries
CoreMotion.framework
AlipaySDK.framework
libssl.a
CFNetwork.framework
Foundation.framework
libcrypto.a
UIKit.framework
CoreGraphics.framework
CoreText.framework
QuartzCore.framework
CoreTelephony.framework
SystemConfiguration.framework
libz.tbd
libc++.tbd

适配iOS9.0
Info.plist -> NSAppTransportSecurity    添加 NSAllowsArbitraryLoads   Bool  true

添加Scheme
为了支付完之后跳回App
Info  -> URL Types  -> + -> URL Schemes  -> 输入我们自己设定的名称，如“ptealipay”
