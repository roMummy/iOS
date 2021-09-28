//
//  ViewController.swift
//  SignAppleDemo
//
//  Created by FSKJ on 2021/8/24.
//

import AuthenticationServices
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.frame = CGRect(x: 20, y: 300, width: 200, height: 50)
        button.addTarget(self, action: #selector(appleAction), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc func appleAction() {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        // 创建新的AppleID授权请求
        let request = appleIDProvider.createRequest()
        // 所需要请求的联系信息
        request.requestedScopes = [.fullName, .email]
        // 管理授权请求的控制器
        let controller = ASAuthorizationController(authorizationRequests: [request])
        // 授权成功或者失败的代理
        controller.delegate = self
        // 显示上下文的代理, 系统可以在上下文中向用户展示授权页面
        controller.presentationContextProvider = self
        // 在控制器初始化期间启动授权流
        controller.performRequests()
    }
}

extension ViewController: ASAuthorizationControllerDelegate {
    /// 授权成功
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("授权成功")
        if let appleIdCreden = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIdCreden.user
            let fullname = appleIdCreden.fullName
            let email = appleIdCreden.email

            // 存储
            // ...
        } else if let passwdCreden = authorization.credential as? ASPasswordCredential {
            // 密码凭证用户的唯一标识
            let userIdentifiler = passwdCreden.user
            // 密码凭证的密码
            let password = passwdCreden.password

            // 显示相关信息
            let message = "APP已经收到您选择的秘钥凭证\nUsername: \(userIdentifiler)\n Password: \(password)"
            print(message)
        } else {
        }
    }

    /// 授权失败
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("授权失败 - \(error.localizedDescription)")
        var showText = ""
        if let authError = error as? ASAuthorizationError {
            let code = authError.code
            switch code {
            case .canceled:
                showText = "用户取消了授权请求"
            case .failed:
                showText = "授权请求失败"
            case .invalidResponse:
                showText = "授权请求响应无效"
            case .notHandled:
                showText = "未能处理授权请求"
            case .unknown:
                showText = "授权请求失败, 未知的错误原因"
            default:
                showText = "其他未知的错误原因"
            }
        }
        print(showText)
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    /// 展示授权页面
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
