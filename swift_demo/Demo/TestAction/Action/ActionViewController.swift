//
//  ActionViewController.swift
//  Action
//
//  Created by FSKJ on 2022/6/16.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    let desiredType = UTType.fileURL.identifier
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let items = extensionContext!.inputItems
//        // open the envelopes
        guard let extensionItem = items[0] as? NSExtensionItem else { return }
        guard let provider = extensionItem.attachments?.first else { return }
        guard provider.hasItemConformingToTypeIdentifier(desiredType) else { return }

        provider.loadItem(forTypeIdentifier: desiredType) { item, _ in
            DispatchQueue.main.async {
                if let url = item as? URL {
                    self.redirectToHostApp(path: url.path)
                }
            }
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    /// 打开主程序
    func redirectToHostApp(path: String) {
        // 共享域
        let shareUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Known.TestShare1")
        
        let fromPath = URL(fileURLWithPath: path)
        var toPath = shareUrl
        toPath?.appendPathComponent("test.\(fromPath.pathExtension)")
        // copy 到共享域
        try? FileManager.default.copyItem(at: fromPath, to: toPath!)
        
        let url = URL(string: "testaction://\(toPath?.path ?? "")")
        
        let selectorOpenURL = sel_registerName("openURL:")
        let context = NSExtensionContext()
        context.open(url! as URL, completionHandler: nil)

        var responder = self as UIResponder?

        while responder != nil {
            if responder?.responds(to: selectorOpenURL) == true {
                responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder!.next
        }

        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}
