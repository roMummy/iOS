# UI适配

按照比例适配，支持使用xib

## 用法 
* 代码 直接具体数值后面添加```.hscale```
```
  addSubview(contentLab).snp.makeConstraints { make in
      make.centerX.equalToSuperview(
      make.bottom.equalToSuperview().offset(-12.hscale)
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
