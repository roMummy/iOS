//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by TW on 2018/5/7.
//  Copyright © 2018年 TW. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  
  let dispostBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    //监听事件
    let button = UIButton.init(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    button.backgroundColor = .green
    button.rx.controlEvent(.touchUpInside).subscribe(onNext: {
      print("按钮被点击")
    }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: dispostBag)
    view.addSubview(button)
    
    //检测值的改变
    let magicNumberVariable = BehaviorRelay(value: 10)
    magicNumberVariable.asObservable().subscribe(onNext: { (value) in
      print(value)
    }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: dispostBag)
    
    //zip 合并 同时变化才会响应
    let stringSubject = PublishSubject<String>()
    let intSubject = PublishSubject<Int>()
    
    Observable.zip(stringSubject, intSubject) {
      "\($0), \($1)"
    }.subscribe(onNext: {
      print($0)
    }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: dispostBag)
    stringSubject.onNext("aaa")
    stringSubject.onNext("bbb")
    intSubject.onNext(111)
    intSubject.onNext(222)
    
    //Transform 转换数据
    Observable.of(1,2,3)
      .map{$0 * $0}
      .subscribe(onNext: {print($0)})
      .disposed(by: dispostBag)
    
    //publish 普通的观察者不会触发
    let myObservable = Observable<Int>.interval(1, scheduler: MainScheduler.instance).publish().refCount()
    let mySubscription = myObservable.subscribe(onNext: {
      print("next: -> \($0)")
    })
    mySubscription.dispose()
    
    myObservable.subscribe(onNext: {
      print("next: \($0)")
    }).dispose()
    
    
    cacheLocally().subscribe {
      print("suc")
    } onError: { (error) in
      print(error.localizedDescription)
    }.disposed(by: dispostBag)

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func cacheLocally() -> Completable {
    return Completable.create { (observer) -> Disposable in
      
      observer(.completed)
      
      return Disposables.create()
      
    }
  }
  
  func generateString() -> Maybe<String> {
    return Maybe<String>.create { (observer) -> Disposable in
      observer(.success("suc"))
      return Disposables.create()
    }
  }
  
}

