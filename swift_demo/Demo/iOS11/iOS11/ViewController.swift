//
//  ViewController.swift
//  iOS11
//
//  Created by TW on 2017/9/26.
//  Copyright © 2017年 TW. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "31312"
        self.navigationItem.title = "123123"
//        self.navigationItem.largeTitleDisplayMode = .always
        //开启大标题
//        self.navigationController?.navigationBar.prefersLargeTitles = true
      
      let web = WKWebView(frame: self.view.frame)
//      web.loadRequest(URLRequest(url: URL(string: "m.360kad.com")!))
      var request = URLRequest(url: URL(string: "https://m.360kad.com")!)
//      request.addValue("https://pay.360kad.com://", forHTTPHeaderField: "Referer")
      request.setValue("www.pay.360kad.com://", forHTTPHeaderField: "Referer")
//      request.httpMethod = "GET"
      web.navigationDelegate = self
      web.load(request)
      
      web.configuration.allowsInlineMediaPlayback = true
      self.view.addSubview(web)
      
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: WKNavigationDelegate {

  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
    let wxpayScheme = "www.pay.360kad.com://"    
    
    guard var curUrl = navigationAction.request.url else {
      decisionHandler(.cancel)
      return
    }
        
    if curUrl.absoluteString.hasPrefix("https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb") {
      if var comps = URLComponents(string: curUrl.absoluteString) {
        var needChange = false
        for (idx, item) in (comps.queryItems ?? []).enumerated() {
            if item.name == "redirect_url" && item.value != wxpayScheme {
                needChange = true
                comps.queryItems?.remove(at: idx)
                break
            }
        }
        if needChange {
            comps.queryItems?.append(URLQueryItem(name: "redirect_url", value: wxpayScheme))
            if let finalUrl = comps.url {
                // 给请求头加上Referer字段
                let mRequest = NSMutableURLRequest(url: finalUrl)
                mRequest.setValue(wxpayScheme, forHTTPHeaderField: "Referer")

                decisionHandler(WKNavigationActionPolicy.cancel)
                webView.load(mRequest as URLRequest)
                return
            }
        }
      }
    }
    
    if curUrl.absoluteString.hasPrefix(wxpayScheme) {
        // 进入空白页，强制后退
        decisionHandler(WKNavigationActionPolicy.cancel)
        webView.goBack()
        return
    }
    
    // 支付宝替换scheme 可以直接返回app
    if curUrl.absoluteString.hasPrefix("alipay://alipayclient/") {
      var decodePar = curUrl.query ?? ""
      decodePar = decodePar.urlDecoded()
      
      var decode = Json.fromJson(decodePar, toClass: ZFBRequest.self)
      decode?.fromAppUrlScheme = wxpayScheme
      
      let param = Json.toJson(fromObject: decode)
      
      if param != "null", !param.isEmpty {
        let finalStr = "alipay://alipayclient/?\(param.urlEncoded())"
        if let finalUrl = URL(string: finalStr) {
            curUrl = finalUrl
        }
      }
    }
    
    // 支付宝、微信 直接跳转浏览器
    if curUrl.absoluteString.hasPrefix("alipay://alipayclient/") || curUrl.absoluteString.hasPrefix("weixin://"){
      decisionHandler(WKNavigationActionPolicy.cancel)
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(curUrl, options: [:], completionHandler: nil)
      } else {
        UIApplication.shared.openURL(curUrl)
      }
      return
    }
    
    decisionHandler(WKNavigationActionPolicy.allow)

    
  }
  
  public struct Json {
     public static func fromJson<T:Decodable>(_ json:String, toClass:T.Type)->T? {
       let jsonDecoder = JSONDecoder();
      
      do {
        try jsonDecoder.decode(toClass, from: json.data(using: .utf8)!);
      } catch let error {
        print(error.localizedDescription)
      }
      
       return try? jsonDecoder.decode(toClass, from: json.data(using: .utf8)!);
     }
     
     public static func toJson<T:Encodable>(fromObject:T)->String {
       let encoder = JSONEncoder();
       return String(data: try! encoder.encode(fromObject), encoding: .utf8)!;
     }
   }
  struct ZFBRequest: Codable {
    var requestType: String?
    var fromAppUrlScheme: String?
    var dataString: String?
  }
}
extension String {
  //将原始的url编码为合法的url
  func urlEncoded() -> String {
      let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
          .urlQueryAllowed)
      return encodeUrlString ?? ""
  }
   
  //将编码后的url转换回原始的url
  func urlDecoded() -> String {
      return self.removingPercentEncoding ?? ""
  }
}
