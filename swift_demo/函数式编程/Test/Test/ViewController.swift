//
//  ViewController.swift
//  Test
//
//  Created by Max on 17/8/13.
//  Copyright © 2017年 lml. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        let t = test()
        
        super.viewDidLoad()
        //获取文件夹路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        print(path ?? "nil")
        
        
        //拼加文件
        let filePath = path?.appending("/The Chainsmokers - Something Just Like This.lrc")
        //文件管理器
        let fm = FileManager.default
        //检查文件是否存在
        guard fm.fileExists(atPath: filePath!) else{
            fatalError("file nil")
        }
        do {
            //获取文件夹下的所有文件
            let subPaths = try fm.subpathsOfDirectory(atPath: path!)
            let lrc = try String(contentsOfFile: filePath!, encoding: String.Encoding.utf8)
            print(lrc)
            print(subPaths)
        }
        catch {
            fatalError()
        }
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

