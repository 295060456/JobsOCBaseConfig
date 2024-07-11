# iOS 横竖屏UI切换

[toc]

## 一、第三方支援

```ruby
pod 'HXRotationTool' # https://github.com/TheLittleBoy/HXRotationTool
```

## 二、xcode 设置

![image-20240702165235414](./assets/image-20240702165235414.png)

## 三、`Info.plist` 设置

* iPhone 应用

  ```xml
  <key>UISupportedInterfaceOrientations</key>
  <array>
      <string>UIInterfaceOrientationPortrait</string>
      <string>UIInterfaceOrientationPortraitUpsideDown</string>
      <string>UIInterfaceOrientationLandscapeLeft</string>
      <string>UIInterfaceOrientationLandscapeRight</string>
  </array>
  ```

* iPad 应用

  ```xml
  <key>UISupportedInterfaceOrientations~ipad</key>
  <array>
      <string>UIInterfaceOrientationPortrait</string>
      <string>UIInterfaceOrientationPortraitUpsideDown</string>
      <string>UIInterfaceOrientationLandscapeLeft</string>
      <string>UIInterfaceOrientationLandscapeRight</string>
  </array>
  ```

## 四、代码处理

* <font color=green>**相关枚举说明**</font>

  * `UIInterfaceOrientationMask`用于指定应用支持的界面方向的位掩码。它的值可以组合使用，以定义应用程序支持的方向

    ```objective-c
    typedef NS_OPTIONS(NSUInteger, UIInterfaceOrientationMask) {
        UIInterfaceOrientationMaskPortrait = (1 << UIInterfaceOrientationPortrait),/// 表示设备处于竖屏（Portrait）模式。
        UIInterfaceOrientationMaskLandscapeLeft = (1 << UIInterfaceOrientationLandscapeLeft),/// 表示设备处于左横屏（Landscape Left）模式。
        UIInterfaceOrientationMaskLandscapeRight = (1 << UIInterfaceOrientationLandscapeRight),/// 表示设备处于右横屏（Landscape Right）模式。
        UIInterfaceOrientationMaskPortraitUpsideDown = (1 << UIInterfaceOrientationPortraitUpsideDown),/// 表示设备处于倒竖屏（Portrait Upside Down）模式。
        UIInterfaceOrientationMaskLandscape = (UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight), /// 表示设备可以处于任意横屏（Landscape）模式，包括左横屏和右横屏。
        UIInterfaceOrientationMaskAll = (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown),/// 表示设备可以处于所有方向，包括竖屏、左横屏、右横屏和倒竖屏。
        UIInterfaceOrientationMaskAllButUpsideDown = (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight),/// 表示设备可以处于所有方向，但不包括倒竖屏。
    } API_UNAVAILABLE(tvos);
    ```

  * `UIInterfaceOrientation` 描述界面当前的方向，用于确定应用界面是如何显示的。其值包括：
    * 通常与 `UIInterfaceOrientationMask` 中定义的支持方向进行比较
    
    ```objective-c
    typedef NS_ENUM(NSInteger, UIInterfaceOrientation) {
        UIInterfaceOrientationUnknown            = UIDeviceOrientationUnknown, /// 界面方向未知或不确定。这通常用于初始化或错误状态
        UIInterfaceOrientationPortrait           = UIDeviceOrientationPortrait, /// 设备处于竖屏（Portrait）模式，即设备的顶部朝上
        UIInterfaceOrientationPortraitUpsideDown = UIDeviceOrientationPortraitUpsideDown,/// 设备处于倒竖屏（Portrait Upside Down）模式，即设备的顶部朝下
        UIInterfaceOrientationLandscapeLeft      = UIDeviceOrientationLandscapeRight, /// 设备处于左横屏（Landscape Left）模式。❤️注意，这个方向对应于设备顶部向右（而不是向左），这与其名称可能引起的直观理解不同❤️
        UIInterfaceOrientationLandscapeRight     = UIDeviceOrientationLandscapeLeft /// 设备处于右横屏（Landscape Right）模式。同样地，这个方向对应于设备顶部向左
    } API_UNAVAILABLE(tvos);
    ```

  * `UIDeviceOrientation` 描述<font color=red>**设备本身的物理方向**</font>，即设备如何被用户持握。其值包括：

    * 虽然它有时与 `UIInterfaceOrientation` 一致，但它们并不总是相同
    * 例如，在设备平放时（`UIDeviceOrientationFaceUp` 或 `UIDeviceOrientationFaceDown`）
    
    ```objective-c
    typedef NS_ENUM(NSInteger, UIDeviceOrientation) {
         UIDeviceOrientationUnknown, /// 设备方向未知或不确定。这通常用于初始化或错误状态
         UIDeviceOrientationPortrait,            /// 设备竖直放置，设备底部的 Home 键在底部（设备顶部朝上）
         UIDeviceOrientationPortraitUpsideDown,  /// 设备竖直放置，设备底部的 Home 键在顶部（设备顶部朝下）
         UIDeviceOrientationLandscapeLeft,       /// 设备水平放置，设备底部的 Home 键在右侧（设备顶部朝左）
         UIDeviceOrientationLandscapeRight,      /// 设备水平放置，设备底部的 Home 键在左侧（设备顶部朝右）
         UIDeviceOrientationFaceUp,              /// 设备平放，屏幕朝上
         UIDeviceOrientationFaceDown             /// 设备平放，屏幕朝下
    } API_UNAVAILABLE(tvos);
    ```
  
* <font color=blue>**代码示例**</font>

  * 在 `UITabBarController` 中适配横屏
  
    ```objective-c
    @interface MyTabBarController : UITabBarController
    @end
    
    @implementation MyTabBarController
    
    - (BOOL)shouldAutorotate {
        return [self.selectedViewController shouldAutorotate];
    }
    
    - (UIInterfaceOrientationMask)supportedInterfaceOrientations {
        return [self.selectedViewController supportedInterfaceOrientations];
    }
    
    @end
    ```
  
  * 在 `UINavigationController` 中适配横屏
  
    ```objective-c
    @interface MyNavigationController : UINavigationController
    @end
    
    @implementation MyNavigationController
    
    - (BOOL)shouldAutorotate {
        return [self.topViewController shouldAutorotate];
    }
    
    - (UIInterfaceOrientationMask)supportedInterfaceOrientations {
        return [self.topViewController supportedInterfaceOrientations];
    }
    
    @end
    ```
  
  * 确保所有子视图控制器正确实现了旋转方法
  
    ```objective-c
    @interface MyViewController : UIViewController
    @end
    
    @implementation MyViewController
    
    - (BOOL)shouldAutorotate {
        return YES;
    }
    
    - (UIInterfaceOrientationMask)supportedInterfaceOrientations {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    @end
    ```
  
  * 关键方法说明
  
    * 如果需要一进App就实现横屏转向，需要在`AppDelegate.m`里面实现：
  
      ```objective-c
      - (UIInterfaceOrientationMask)application:(UIApplication *)application 
        supportedInterfaceOrientationsForWindow:(UIWindow *)window {
          return UIInterfaceOrientationMaskLandscape;
      }
      ```
  
    * 在具体的子控制器里面实现，决定这个控制器页面是否横屏
  
      ```objective-c
      /// 决定当前界面是否开启自动转屏，如果返回NO，后面两个方法也不会被调用，只是会支持默认的方向
      - (BOOL)shouldAutorotate {
          return YES;
      }
      /// 当前控制器支持的屏幕旋转方向（在具体的控制器子类进行覆写）
      /// iPad设备上，默认返回值UIInterfaceOrientationMaskAllButUpSideDwon
      /// iPhone设备上，默认返回值是UIInterfaceOrientationMaskAll
      - (UIInterfaceOrientationMask)supportedInterfaceOrientations {
          return UIInterfaceOrientationMaskAll;
      }
      /// 设置进入界面默认支持的方向
      - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
          return [super preferredInterfaceOrientationForPresentation];
      }
      ```
  
  * 通知监听`UIDeviceOrientationDidChangeNotification`
  
    ```objective-c
    /// 设备方向
    JobsAddNotification(self,
                    selectorBlocks(^id _Nullable(id _Nullable weakSelf,
                                              id _Nullable arg){
        NSNotification *notification = (NSNotification *)arg;
        if([notification.object isKindOfClass:NSNumber.class]){
            NSNumber *b = notification.object;
            NSLog(@"SSS = %d",b.boolValue);
        }
        @jobs_strongify(self)
        NSLog(@"通知传递过来的 = %@",notification.object);
    
        switch (UIDevice.currentDevice.orientation) {
                // 处理竖屏方向的逻辑
            case UIDeviceOrientationPortrait:/// 设备竖直向上，Home 按钮在下方
                NSLog(@"系统通知：↓");
                break;
            case UIDeviceOrientationPortraitUpsideDown:/// 设备竖直向下，Home 按钮在上方
                NSLog(@"系统通知：↑");
                break;
                // 处理横屏方向的逻辑
            case UIDeviceOrientationLandscapeLeft:/// 设备水平，Home 按钮在右侧
                NSLog(@"系统通知：→");
                break;
            case UIDeviceOrientationLandscapeRight:/// 设备水平，Home 按钮在左侧
                NSLog(@"系统通知：←");
                break;
            default:
                break;
        }
    
        return nil;
    },nil, self),UIDeviceOrientationDidChangeNotification,nil);
    ```

## 五、屏幕上下倒立<font color=red>不可用</font>

* 技术上是可能的，但实际使用中可能受到限制
* 目前涉及的iPhone全面屏（包括:`刘海屏 `或者 `动态岛`）系列，不支持倒立（上下颠倒）屏幕方向。这是 Apple 的设计决定，主要基于以下几个原因：
  * 用户体验：刘海屏的设计使得倒立使用时，"刘海"或"动态岛"会位于屏幕底部，这可能会影响用户体验和交互
  * 硬件限制：前置摄像头、扬声器和各种传感器都集中在"刘海"区域，倒立使用可能会影响这些硬件的正常功能
  * 设计一致性：保持界面的一致性，避免在不同设备间出现使用差异
* 具体来说，以下 iPhone 型号不支持倒立屏幕：**iPhone X** 及之后的所有型号（包括 **iPhone XS**, **XR**, **11**, **12**, **13**, **14**, **15** 系列等）
* 对于应用开发，如果 App 特别需要支持倒立显示（例如，为了在某些特殊场景下方便查看内容），可能需要考虑实现自定义的界面旋转逻辑，而不是依赖系统的屏幕旋转

## 六、横竖屏检测·相关测评报告

```objective-c
DeviceOrientation d = self.getDeviceOrientation;
UIInterfaceOrientation s = self.getInterfaceOrientation;
UIDeviceOrientation f =  UIDevice.currentDevice.orientation;
NSLog(@"");
```

### 1、<font id=锚定`UIDevice.currentDevice.orientation`>锚定`UIDevice.currentDevice.orientation`</font>

* 不配置 `- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window ` 

  * 当前设备横屏

    |       `UIViewController`的生命周期方法       | 当前控制器为挂载到`UITabBarController`及其子类上的控制器 |           当前控制器为`UITabBarController`及其子类           |         当前控制器为普通的`UIViewController`及其子类         |
    | :------------------------------------------: | :------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
    |           - (**void**)viewDidLoad            |                UIDeviceOrientationUnknown                |                  UIDeviceOrientationUnknown                  | <font color=red>**UIDeviceOrientationLandscapeRight**</font> |
    | -(**void**)viewWillAppear:(**BOOL**)animated |                UIDeviceOrientationUnknown                |                  UIDeviceOrientationUnknown                  | <font color=red>**UIDeviceOrientationLandscapeRight**</font> |
    | -(**void**)viewDidAppear:(**BOOL**)animated  |                UIDeviceOrientationUnknown                | <font color=red>**UIDeviceOrientationLandscapeRight**</font> | <font color=red>**UIDeviceOrientationLandscapeRight**</font> |

  * 当前设备竖屏
  
    |       `UIViewController`的生命周期方法       | 当前控制器为挂载到`UITabBarController`及其子类上的控制器 |        当前控制器为`UITabBarController`及其子类        |      当前控制器为普通的`UIViewController`及其子类      |
    | :------------------------------------------: | :------------------------------------------------------: | :----------------------------------------------------: | :----------------------------------------------------: |
    |           - (**void**)viewDidLoad            |                UIDeviceOrientationUnknown                |               UIDeviceOrientationUnknown               | <font color=red>**UIDeviceOrientationPortrait**</font> |
    | -(**void**)viewWillAppear:(**BOOL**)animated |                UIDeviceOrientationUnknown                |               UIDeviceOrientationUnknown               | <font color=red>**UIDeviceOrientationPortrait**</font> |
    | -(**void**)viewDidAppear:(**BOOL**)animated  |                UIDeviceOrientationUnknown                | <font color=red>**UIDeviceOrientationPortrait**</font> | <font color=red>**UIDeviceOrientationPortrait**</font> |

* 配置 `- (UIInterfaceOrientationMask)application:(UIApplication *)application
  supportedInterfaceOrientationsForWindow:(UIWindow *)window`

  ```objective-c
  - (UIInterfaceOrientationMask)application:(UIApplication *)application
    supportedInterfaceOrientationsForWindow:(UIWindow *)window {
      return UIInterfaceOrientationMaskLandscape;
  }
  ```

  * 当前设备横屏
  
    |       `UIViewController`的生命周期方法       | 当前控制器为挂载到`UITabBarController`及其子类上的控制器 | 当前控制器为`UITabBarController`及其子类 |         当前控制器为普通的`UIViewController`及其子类         |
    | :------------------------------------------: | :------------------------------------------------------: | :--------------------------------------: | :----------------------------------------------------------: |
    |           - (**void**)viewDidLoad            |                UIDeviceOrientationUnknown                |        UIDeviceOrientationUnknown        | <font color=red>**UIDeviceOrientationLandscapeRight**</font> |
    | -(**void**)viewWillAppear:(**BOOL**)animated |                UIDeviceOrientationUnknown                |        UIDeviceOrientationUnknown        | <font color=red>**UIDeviceOrientationLandscapeRight**</font> |
    | -(**void**)viewDidAppear:(**BOOL**)animated  |                UIDeviceOrientationUnknown                |        UIDeviceOrientationUnknown        | <font color=red>**UIDeviceOrientationLandscapeRight**</font> |
  
  * 当前设备竖屏
  
    |       `UIViewController`的生命周期方法       | 当前控制器为挂载到`UITabBarController`及其子类上的控制器 | 当前控制器为`UITabBarController`及其子类 | 当前控制器为普通的`UIViewController`及其子类 |
    | :------------------------------------------: | :------------------------------------------------------: | :--------------------------------------: | :------------------------------------------: |
    |           - (**void**)viewDidLoad            |                UIDeviceOrientationUnknown                |        UIDeviceOrientationUnknown        |          UIDeviceOrientationUnknown          |
    | -(**void**)viewWillAppear:(**BOOL**)animated |                UIDeviceOrientationUnknown                |        UIDeviceOrientationUnknown        |          UIDeviceOrientationUnknown          |
    | -(**void**)viewDidAppear:(**BOOL**)animated  |                UIDeviceOrientationUnknown                |        UIDeviceOrientationUnknown        |          UIDeviceOrientationUnknown          |

### 2、<font id=锚定场景方向`UIInterfaceOrientation`>锚定场景方向`UIInterfaceOrientation`</font>

  ```objective-c
  -(UIInterfaceOrientation)getInterfaceOrientation{
      UIInterfaceOrientation __block currentOrientation = UIInterfaceOrientationUnknown;
      if (@available(iOS 13.0, *)) {
          [self getViewByBlock:^id _Nullable(ComponentType componentType,
                                             UIView * _Nullable data) {
              /// 获取当前窗口场景的界面方向
              currentOrientation = data.window.windowScene.interfaceOrientation;
              return nil;
          }];
      } else {
          SuppressWdeprecatedDeclarationsWarning(currentOrientation = UIApplication.sharedApplication.statusBarOrientation;);
      }return currentOrientation;
  }
  ```

* 不配置 `- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window ` 

  * 当前设备横屏

    |       `UIViewController`的生命周期方法       | 当前控制器为挂载到`UITabBarController`及其子类上的控制器 | 当前控制器为`UITabBarController`及其子类 | 当前控制器为普通的`UIViewController`及其子类 |
    | :------------------------------------------: | :------------------------------------------------------: | :--------------------------------------: | :------------------------------------------: |
    |           - (**void**)viewDidLoad            |              UIInterfaceOrientationUnknown               |      UIInterfaceOrientationUnknown       |        UIInterfaceOrientationUnknown         |
    | -(**void**)viewWillAppear:(**BOOL**)animated |              UIInterfaceOrientationUnknown               |      UIInterfaceOrientationUnknown       |        UIInterfaceOrientationUnknown         |
    | -(**void**)viewDidAppear:(**BOOL**)animated  |             UIInterfaceOrientationPortrait❌              |     UIInterfaceOrientationPortrait❌      |       UIInterfaceOrientationPortrait❌        |

  * 当前设备竖屏

    |       `UIViewController`的生命周期方法       | 当前控制器为挂载到`UITabBarController`及其子类上的控制器 | 当前控制器为`UITabBarController`及其子类 | 当前控制器为普通的`UIViewController`及其子类 |
    | :------------------------------------------: | :------------------------------------------------------: | :--------------------------------------: | :------------------------------------------: |
    |           - (**void**)viewDidLoad            |              UIInterfaceOrientationUnknown               |      UIInterfaceOrientationUnknown       |        UIInterfaceOrientationUnknown         |
    | -(**void**)viewWillAppear:(**BOOL**)animated |              UIInterfaceOrientationUnknown               |      UIInterfaceOrientationUnknown       |        UIInterfaceOrientationUnknown         |
    | -(**void**)viewDidAppear:(**BOOL**)animated  |              UIInterfaceOrientationPortrait              |      UIInterfaceOrientationPortrait      |        UIInterfaceOrientationPortrait        |

* 配置 `- (UIInterfaceOrientationMask)application:(UIApplication *)application
  supportedInterfaceOrientationsForWindow:(UIWindow *)window`

  ```objective-c
  - (UIInterfaceOrientationMask)application:(UIApplication *)application
    supportedInterfaceOrientationsForWindow:(UIWindow *)window {
      return UIInterfaceOrientationMaskLandscape;
  }
  ```

  * 当前设备横屏
  
    |       `UIViewController`的生命周期方法       |   当前控制器为挂载到`UITabBarController`及其子类上的控制器   |           当前控制器为`UITabBarController`及其子类           |         当前控制器为普通的`UIViewController`及其子类         |
    | :------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
    |           - (**void**)viewDidLoad            |                UIInterfaceOrientationUnknown                 |                UIInterfaceOrientationUnknown                 |                UIInterfaceOrientationUnknown                 |
    | -(**void**)viewWillAppear:(**BOOL**)animated |                UIInterfaceOrientationUnknown                 |                UIInterfaceOrientationUnknown                 |                UIInterfaceOrientationUnknown                 |
    | -(**void**)viewDidAppear:(**BOOL**)animated  | <font color=red>**UIInterfaceOrientationLandscapeRight**</font> | <font color=red>**UIInterfaceOrientationLandscapeRight**</font> | <font color=red>**UIInterfaceOrientationLandscapeRight**</font> |
  
  * 当前设备竖屏
  
    |       `UIViewController`的生命周期方法       |   当前控制器为挂载到`UITabBarController`及其子类上的控制器   |           当前控制器为`UITabBarController`及其子类           |         当前控制器为普通的`UIViewController`及其子类         |
    | :------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
    |           - (**void**)viewDidLoad            |                UIInterfaceOrientationUnknown                 |                UIInterfaceOrientationUnknown                 |                UIInterfaceOrientationUnknown                 |
    | -(**void**)viewWillAppear:(**BOOL**)animated |                UIInterfaceOrientationUnknown                 |                UIInterfaceOrientationUnknown                 |                UIInterfaceOrientationUnknown                 |
    | -(**void**)viewDidAppear:(**BOOL**)animated  | <font color=red>**UIInterfaceOrientationLandscapeRight**</font> | <font color=red>**UIInterfaceOrientationLandscapeRight**</font> | <font color=red>**UIInterfaceOrientationLandscapeRight**</font> |

### 3、<font id=锚定`view.traitCollection.verticalSizeClass`>锚定`view.traitCollection.verticalSizeClass`</font>

```objective-c
-(DeviceOrientation)getDeviceOrientation{
    UIView *view = self.getView;
    if(view){
        if(view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact){
            return DeviceOrientationLandscape;
        }else{
            return DeviceOrientationPortrait;
        }
    }else return DeviceOrientationUnknown;
}
```

```objective-c
-(UIView *_Nullable)getView{
    UIView *view = nil;
    if ([self isKindOfClass:UIView.class]) {
        view = (UIView *)self;
    }else if ([self isKindOfClass:UIViewController.class]){
        UIViewController *vc = (UIViewController *)self;
        view = vc.view;
    }return view;
}
```

```objective-c
/// 屏幕方向
#ifndef DeviceOrientation_typedef
#define DeviceOrientation_typedef
typedef NS_ENUM(NSInteger, DeviceOrientation) {
    DeviceOrientationUnknown, /// 未知方向
    DeviceOrientationPortrait,/// 竖屏
    DeviceOrientationLandscape /// 横屏
};
#endif /* DeviceOrientation_typedef */
```

* 不配置 `- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window ` 

  * 当前设备横屏

    |       `UIViewController`的生命周期方法       | 当前控制器为挂载到`UITabBarController`及其子类上的控制器 | 当前控制器为`UITabBarController`及其子类 | 当前控制器为普通的`UIViewController`及其子类 |
    | :------------------------------------------: | :------------------------------------------------------: | :--------------------------------------: | :------------------------------------------: |
    |           - (**void**)viewDidLoad            |                DeviceOrientationPortrait❌                |        DeviceOrientationPortrait❌        |          DeviceOrientationPortrait❌          |
    | -(**void**)viewWillAppear:(**BOOL**)animated |                DeviceOrientationPortrait❌                |        DeviceOrientationPortrait❌        |          DeviceOrientationPortrait❌          |
    | -(**void**)viewDidAppear:(**BOOL**)animated  |                DeviceOrientationPortrait❌                |        DeviceOrientationPortrait❌        |          DeviceOrientationPortrait❌          |

  * 当前设备竖屏

    |       `UIViewController`的生命周期方法       | 当前控制器为挂载到`UITabBarController`及其子类上的控制器 | 当前控制器为`UITabBarController`及其子类 | 当前控制器为普通的`UIViewController`及其子类 |
    | :------------------------------------------: | :------------------------------------------------------: | :--------------------------------------: | :------------------------------------------: |
    |           - (**void**)viewDidLoad            |                DeviceOrientationPortrait                 |        DeviceOrientationPortrait         |          DeviceOrientationPortrait           |
    | -(**void**)viewWillAppear:(**BOOL**)animated |                DeviceOrientationPortrait                 |        DeviceOrientationPortrait         |          DeviceOrientationPortrait           |
    | -(**void**)viewDidAppear:(**BOOL**)animated  |                DeviceOrientationPortrait                 |        DeviceOrientationPortrait         |          DeviceOrientationPortrait           |

* 配置 `- (UIInterfaceOrientationMask)application:(UIApplication *)application
  supportedInterfaceOrientationsForWindow:(UIWindow *)window`

  ```objective-c
  - (UIInterfaceOrientationMask)application:(UIApplication *)application
    supportedInterfaceOrientationsForWindow:(UIWindow *)window {
      return UIInterfaceOrientationMaskLandscape;
  }
  ```

  * 当前设备横屏
  
    |       `UIViewController`的生命周期方法       | 当前控制器为挂载到`UITabBarController`及其子类上的控制器 |       当前控制器为`UITabBarController`及其子类        |     当前控制器为普通的`UIViewController`及其子类      |
    | :------------------------------------------: | :------------------------------------------------------: | :---------------------------------------------------: | :---------------------------------------------------: |
    |           - (**void**)viewDidLoad            |                DeviceOrientationPortrait❌                |              DeviceOrientationPortrait❌               | <font color=red>**DeviceOrientationLandscape**</font> |
    | -(**void**)viewWillAppear:(**BOOL**)animated |                DeviceOrientationPortrait❌                |              DeviceOrientationPortrait❌               | <font color=red>**DeviceOrientationLandscape**</font> |
    | -(**void**)viewDidAppear:(**BOOL**)animated  |  <font color=red>**DeviceOrientationLandscape**</font>   | <font color=red>**DeviceOrientationLandscape**</font> | <font color=red>**DeviceOrientationLandscape**</font> |
  
  * 当前设备竖屏
  
    |       `UIViewController`的生命周期方法       | 当前控制器为挂载到`UITabBarController`及其子类上的控制器 | 当前控制器为`UITabBarController`及其子类 | 当前控制器为普通的`UIViewController`及其子类 |
    | :------------------------------------------: | :------------------------------------------------------: | :--------------------------------------: | :------------------------------------------: |
    |           - (**void**)viewDidLoad            |                DeviceOrientationPortrait❌                |        DeviceOrientationPortrait❌        |          DeviceOrientationPortrait❌          |
    | -(**void**)viewWillAppear:(**BOOL**)animated |                DeviceOrientationPortrait❌                |        DeviceOrientationPortrait❌        |          DeviceOrientationPortrait❌          |
    | -(**void**)viewDidAppear:(**BOOL**)animated  |  <font color=red>**DeviceOrientationLandscape**</font>   |        DeviceOrientationPortrait❌        |          DeviceOrientationPortrait❌          |

### 七、结论

* 系统通知`UIDeviceOrientationDidChangeNotification`也是需要服从界面UI的生命周期，否则取值不成功

* 其实系统有2个维度来读取是否横屏

  * 设备真实的方向（定义手机横卧为横屏）
  * 在`AppDelegate`里面，对`- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window`进行了配置。因为是强制性的横屏呈现，所以<font color=red>**优先级最高**</font>

* 如果配置了`- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window`为横屏模式（默认为竖屏模式），但是终值为竖屏，**则为错误读取**

* 如果不配置`- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window`为横屏模式（默认为竖屏模式），则以当前设备定位为准

* 对于页面，因为需要自适应调整，那么以靠后的生命周期读取值为准。比如在**viewController**里面`-(void)viewDidAppear:(BOOL)animated`的值为最终系统在综合各种因素后调整后的值。<font color=red>**不要去关心中间值，以终值为准，这样方便定位我们从何时调用方法为有效调用**</font>

* **一般的架构是将`UITabBarController`及其子类作为根控制器，那么在呈现页面的时候，内部会去调整UI适配横竖屏。所以，`UITabBarController`及其子类以及挂载在上面的子控制器，均是需要在页面生命周期走完以后（即，`-(void)viewDidAppear:(BOOL)animated`以后）才能获取到正确的值**

* [**如果锚定`UIDevice.currentDevice.orientation`**](#锚定`UIDevice.currentDevice.orientation`)

  * `UIDevice.currentDevice.orientation`不是总是有效。在应用启动时，设备方向信息有时可能还没有完全初始化，这可能导致得到 `UIDeviceOrientationUnknown`
  * <font color=red>不能配置 `- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window ` ，因为竖屏检测会失败</font>
  * 如果当前控制器为`UITabBarController`及其子类，`-(void)viewDidAppear:(BOOL)animated`生命周期以后（包含），方位数据才正常
  * 如果当前控制器为普通的`UIViewController`及其子类，则全部生命周期正常

* [**如果锚定场景方向`UIInterfaceOrientation`**](#锚定场景方向`UIInterfaceOrientation`)，则需要在相关控制器的`-(void)viewDidAppear:(BOOL)animated`生命周期（包含）以后，才会获取到真正的`UIInterfaceOrientation`

* [**如果锚定`view.traitCollection.verticalSizeClass`**](#锚定`view.traitCollection.verticalSizeClass`)，则需要配置 `- (UIInterfaceOrientationMask)application:(UIApplication *)application
  supportedInterfaceOrientationsForWindow:(UIWindow *)window`，方可正常检测横竖屏

