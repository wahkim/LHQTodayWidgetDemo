@[toc](Today Extension)
# 前言
前段时间采用`WidgetKit`、`SwiftUI`写了哥支持iOS 14及以上的小组件，那么iOS 14 以下无法支持，Xcode的版本也是在12.2的版本，没办法创建`Today Extension`, 怎么办呢？

重新下了支持`Today Extension`的扩展的Xcode 11。

其实`Today Extension`在iOS 8的时候就已经出现了，在iOS 10的时候才逐渐进入视野，相比iOS 14的小组件，内容也更加丰富，骚操作更多的扩展。

# 样图
![在这里插入图片描述](https://img-blog.csdnimg.cn/2021022216325783.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0hRX0xJTg==,size_16,color_FFFFFF,t_70#pic_center)

# 创建
1. 首先创建一个新的Target: New->Target，选择Today Extension，命名为`TodayExtension`:
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210222163554122.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0hRX0xJTg==,size_16,color_FFFFFF,t_70#pic_center)
2. 工程目录下会出现`TodayExtension`的文件夹：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210222164014816.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0hRX0xJTg==,size_16,color_FFFFFF,t_70#pic_center)
# 布局
- 默认使用 `interface builder`的布局方式
修改了默认的storyboard，只需要将NSExtensionMainStoryboard的value修改成相应的storyboard名字。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210222164759622.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0hRX0xJTg==,size_16,color_FFFFFF,t_70#pic_center)


- 使用`Coding`的方式：
首先将`NSExtensionMainStoryboard`替换成`NSExtensionPrincipalClass`，value为主控制器的类名即可。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210222164706193.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0hRX0xJTg==,size_16,color_FFFFFF,t_70#pic_center)

# TodayViewControler
根据名字就可以知道，这个是个控制器，生命周期还是和原先的一样，有稍稍点区别，即遵循的`NCWidgetProviding`协议实现的方法在`viewWillAppear:`之前。

## `NCWidgetProviding`协议
```java
typedef NS_ENUM(NSUInteger, NCUpdateResult) {
    NCUpdateResultNewData, // 有新数据
    NCUpdateResultNoData, // 无数据
    NCUpdateResultFailed // 更新失败
} NS_ENUM_AVAILABLE_IOS(8_0);
```

修改窗口缩进(该方法在iOS 10 被废弃)
```java
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets API_DEPRECATED("This method will not be called on widgets linked against iOS versions 10.0 and later.", ios(8.0, 10.0));
```

窗口大小设置

从iOS10开始，苹果提供了NCWidgetDisplayMode展示模式，通过设置该模式来支持对widget进行折叠和展开。在这里，preferredContentSize就用到了。这个是用来设置widget的尺寸的。苹果对widget的尺寸有自己的标准，width为maxSize.width，height取值范围`[110, maxSize.height]`。这个maxSize可以在扩展协议<NCWidgetProviding>的协议方法也即widgetActiveDisplayModeDidChange:withMaximumSize中获取:，可以发现每一种机型maxSize不一样。
```java
// 调用该方法使窗口可展开
self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    
    /**
     8p : {348, 672}, {348, 105}
     se : {321, 616}, {321, 110}
     */
    
    if (activeDisplayMode == NCWidgetDisplayModeCompact) { // 折叠
        self.preferredContentSize = maxSize;
    } else { // 展开
        self.preferredContentSize = CGSizeMake(maxSize.width, 672);
    }
}
```

数据更新
```
//当数据更新时调用的方法，系统会定期更新扩展
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    //获取共享的数据，根据判断回调对应的block
    // NCUpdateResultNewData,
    // NCUpdateResultNoData,
    / /NCUpdateResultFailed
    
    completionHandler(NCUpdateResultNoData);
}
```


# 数据共享
 1.  在应用和扩展的`Taget`，添加`App Groups`。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210222165311488.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0hRX0xJTg==,size_16,color_FFFFFF,t_70#pic_center)
>==Note==: 发布应用时，需要在开发者网站添加该`App Groups`。

2.  数据传递添加` URL Types`:
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210222165736640.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0hRX0xJTg==,size_16,color_FFFFFF,t_70#pic_center)

- 	`UserDefaults`方式
```java
// object-C     
// 存
 NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.LHQ.TodayWidgetDemo"];
[userDefault setValue:@"test" forKey:@"xxx"];
[userDefault synchronize];
// 取
NSString *str = [userDefault objectForKey:@"xxx"];

 // swift
 // 存
 UserDefaults(suiteName:"group.LHQ.TodayWidgetDemo").set(mObject, forKey: "xxx")
 // 取
 let userDefault = UserDefaults(suiteName: "group.LHQ.TodayWidgetDemo")
 var title : String = userDefault?.value(forKey: "xxx") as! String
```

- `FileManager`方式
```java
// 存储数据
NSFileManager *fileManager = [NSFileManager defaultManager];
NSURL *baseURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:@"group.LHQ.TodayWidgetDemo"];
NSURL *filePath = [baseURL URLByAppendingPathComponent:@"file"];
NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@"xxx" requiringSecureCoding:NO error:nil];
[data writeToURL:filePath atomically:YES];
// 获取数据
NSFileManager *fileManager = [NSFileManager defaultManager];
NSURL *baseURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:@"group.LHQ.TodayWidgetDemo"];
NSURL *filePath = [baseURL URLByAppendingPathComponent:@"file"];
NSData *data = [NSData dataWithContentsOfURL:filePath];
```

# 交互方式
这就涉及到上面添加的`URL Types`，我们这边`URL Schemes` 设置为`LHQWidget`
在`TodayViewController`通过:
```java
NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"LHQWidget://copy"]];
[self.extensionContext openURL:url completionHandler:^(BOOL success) {
        NSLog(@"copy success");
}];
```
在`AppDelegate`中该方法响应:
```java
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ([url.scheme isEqualToString:@"LHQWidget"]) {
		/// 执行你想要的操作
    }
    return NO;
}
```
>==Note==: 当你的应用存在`SceneDelegate`时，可以在`scene: openURLContexts:`函数接收该响应，但是会出现一个问题，当应用程序被杀掉的情况下，触发小组件按钮只会唤醒App，不会执行该方法。
>
## 例子源码
[Demo](https://github.com/wahkim/LHQWidgetTestDemo)


## 其他
[iOS 14-Widget小组件1—初识](https://blog.csdn.net/HQ_LIN/article/details/112941344)
[iOS 14-Widget小组件2—实现]https://blog.csdn.net/HQ_LIN/article/details/112967381)
[iOS 14-Widget小组件3—动态配置](https://blog.csdn.net/HQ_LIN/article/details/112993229)

## 参考
[Todat Extension](https://www.dazhuanlan.com/2020/02/27/5e5745f4e7e67/)

