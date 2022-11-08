# UI适配

按照比例适配，支持使用xib，按照标准宽高(375/667)做比例适配

```
    /// 根据比例缩放
    public func scale(_ newValue: CGFloat) -> Double {
        let temp = Double(self)
        return temp * newValue
    }

    /// 横轴缩放
    public var hscale: Double {
        let scaleW = UIScreen.main.bounds.width / standardWidth
        return scale(scaleW)
    }

    /// 纵轴缩放
    public var vscale: Double {
        let scaleW = UIScreen.main.bounds.height / standardHeight
        return scale(scaleW)
    }
```

## 用法 
* 代码

直接具体数值后面添加```.hscale```或者```.vscale```

```
  addSubview(contentLab).snp.makeConstraints { make in
      make.centerX.equalToSuperview(
      make.bottom.equalToSuperview().offset(-12.hscale)
      make.top.equalToSuperview().offset(-12.vscale)
  }
```

* xib

> 可以在最底层的view上面设置```adapterScreenInAllSubviews```为```on```
> 
> 这会直接把所有子view的约束和字体按照比例去适配
> 
> 目前包括*UIButton*、*UILabel*、*UITextfield*、*UITextview*
> 
> 也可以单独设置(包括约束)
