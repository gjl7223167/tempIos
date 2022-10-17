# LBCommonComponents
项目中用到的让开发更快速的一些UI宏定义（如界面的安全区域）、函数宏（比如weak）、系统宏（比如系统版本），以及MethodSwizzling、类型安全、NSArray超界插入nil防crash、字典插入nil防crash、取最上层ViewController、UIButton的blockHandle、图片修改颜色（减小项目容量）、UIView的深拷贝、时间换算工具、UIView布局属性获取，以及UINavigationBar外观一键设置（比如透明，去掉下划线、修改字体颜色等）等.
#导入
```ruby
pod 'LBCommonComponents'
```

#如导航栏一键设置外观用法
```Objc
[self setNavigationBarAppearanceStyle:LBNavigationBarTransparent tintColor:[UIColor whiteColor]];
```


