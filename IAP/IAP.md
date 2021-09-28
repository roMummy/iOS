# IAP

#### 资料

- 内购流程：https://help.apple.com/app-store-connect/#/devb57be10e7
- 三方库： https://github.com/bizz84/SwiftyStoreKit
- 内购：https://developer.apple.com/in-app-purchase/
- xcode内测测试：https://www.appcoda.com.tw/storekit-testing/

#### 内购流程

1. 程序向服务器发送请求，获得一份产品列表。
2. 服务器返回包含产品标识符的列表。
3. 程序向App Store发送请求，得到产品的信息。
4. App Store返回产品信息。
5. 程序把返回的产品信息显示给用户（App的store界面）
6. 用户选择某个产品
7. 程序向App Store发送支付请求
8. App Store处理支付请求并返回交易完成信息。
9. 程序从信息中获得数据，并发送至服务器。
10. 服务器纪录数据，并进行审(我们的)查。
11. 服务器将数据发给App Store来验证该交易的有效性。
12. App Store对收到的数据进行解析，返回该数据和说明其是否有效的标识。
13. 服务器读取返回的数据，确定用户购买的内容。
14. 服务器将购买的内容传递给程序。



