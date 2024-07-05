# iOS 多语言环境设置

[toc]

## 目标

* App语言跟随当前手机系统语言
* 用户主动切换当前App语言，即：App语言不同于手机系统语言

## 参考资料

* [**3分钟实现iOS语言本地化/国际化（图文详解）**](https://cloud.tencent.com/developer/article/1143302)
* [**iOS App内语言切换（国际化）**](https://blog.csdn.net/shanghaibao123/article/details/107323395)
* [**在iOS App内优雅的动态切换语言**](https://www.jianshu.com/p/b4288e5e6e4c)
* [**iOS国际化 （多语言）**](https://juejin.cn/post/6966232778987798558)
* [**Demos-LanguageSettingsDemo**](https://github.com/DarkAngel7/Demos-LanguageSettingsDemo/)
* [**iOS - 多语言本地化**](https://devma.cn/blog/2016/05/27/ios-duo-yu-yan-ben-di-hua/)

## 特别说明

* 经实践证明，如果配置多语言化，那么xcode将会刷新`Info.plist`，导致里面的注释消失。正确的做法是，对`Info.plist`进行备份，随时进行替换

## 配置流程

### xcode 中的配置

* 选中 **project** → **Info** → **Localizations**，然后点击"+"，添加需要国际化/本地化的语言

  * 默认勾选`Use Base Internationalization`
    ![image-20240701112537304](./assets/image-20240701112537304.png)
    
  * 如果不勾选`Use Base Internationalization`
    ![image-20240701112613068](./assets/image-20240701112613068.png)
    
  * 添加语言：简体中文/标准英语/菲律宾他加禄语言
    ![image-20240701114202890](./assets/image-20240701114202890.png)

  * `zh-Hans`和`zh-Hant`是简体中文和繁体中文的缩写。这是标准的缩写。H可大写也可小写。
    
  * 如果弹出如下对话框，直接点击finish
    ![image-20240701112459992](./assets/image-20240701112459992.png)
### 应用名称本地化/国际化（`InfoPlist.strings`）
* 是指同一个App的名称，在不同的语言环境下（也就是手机设备的语言设置）显示不同的名称；
  比如，微信在简体中文环境下App名称显示为**微信**，在英语环境下显示为**weChat**
  * 新建 **`Strings File`** 文件
    ![image-20240701124321212](./assets/image-20240701124321212.png)
  * <font color=red>**保存的文件名`InfoPlist.strings`为系统所需，不可更改**</font>
    ![image-20240701124832755](./assets/image-20240701124832755.png)
  * 新生成的`InfoPlist.strings`在<u>当前电脑上的实际路径</u>，其实是在`en.lproj`文件夹下。其中`en.lproj`和此工程项目的`Info.plist `处于同一文件层级；
    ![image-20240701132729019](./assets/image-20240701132729019.png)
  * 但是，<u>在xcode目录索引中</u>，新生成的`InfoPlist.strings` 必须和 此工程项目的`Info.plist `处于同一文件层级。<font color=red>**否则，无法被正常检出读取**</font>
  * 当删除磁盘上的语言包`*.lproj`文件夹，项目工程xcode目录索引还有引用，也需要一并删除。在xcode右侧的文件选项卡中，移除勾选。弹出框选择`Remove`
  * ![image-20240701141622517](./assets/image-20240701141622517.png)
  * <font id=Localize color=blue>**Localize流程**</font>：选中新生成的`InfoPlist.strings`，在xcode的File inspection（xcode右侧文件检查器）中点击Localize，目的是选择我们需要本地化的语言
  * 点击Localize后，会弹出一个对话框，展开对话框列表，发现下拉列表所展示的语言正是我们在上面配置的需要国际化的语言，选择我们需要本地化的语言，然后点击对话框的Localize按钮
    ![image-20240701125902632](./assets/image-20240701125902632.png)
    ![image-20240701125953191](./assets/image-20240701125953191.png)
  * <font color=red>注意：如果我们没有在 PROJECT 中配置需要国际化的语言（**project** → **Info** → **Localizations**，然后点击"+"），上图下拉列表中将只会出现`Base`和`English`选项，English语言是系统默认的语言，其他需要国际化的语言（例如中文简体、法语）必须通过上面的**配置本地化语言**那一步手动添加。</font>
  * 添加了`InfoPlist.strings`在 **project** → **Info** → **Localizations** 下可以看到有文件被检测到关联：
    ![image-20240701130958012](./assets/image-20240701130958012.png)
  * <font color=red>**如果项目曾经有做过过多语言化的处理，则右侧选项卡不会`Localize`按钮，也不会弹出`Do you want to localize this file`对话框**</font>
  * <font id=在xcode右侧选项卡进行点选>**对`InfoPlist.strings`在 xcode 右侧选项卡进行点选**</font>：
    `InfoPlist.strings`会化身为一个大的文件夹，下面包含各种语言包的子`InfoPlist.strings`     <font color=red>点一个加入一个</font>
    ![image-20240701133346486](./assets/image-20240701133346486.png)
  
* 对`Info.plist`的修改：

  * 向下兼容：

    ```xml
    <key>LSHasLocalizedDisplayName</key>
    <true/>
    ```

    ![image-20240701133957265](./assets/image-20240701133957265.png)

### 代码中字符串的本地化（`Localizable.strings`）

* 指App内的字符串在不同的语言环境下显示不同的内容；

* <font color=red>**保存的文件名`Localizable.strings`为系统所需，不可更改**</font>

* 像创建 `InfoPlist.strings` 一样，新建 `Localizable.strings` 文件，包括[**Localize流程**](#Localize)；

* 新生成的`Localizable.strings`文件，位于`en.lproj`文件夹之下，和`InfoPlist.strings`平行；
  ![image-20240701135711515](./assets/image-20240701135711515.png)
  
* 对新生成的`Localizable.strings`文件，在xcode右侧选项卡进行点选，[**和`InfoPlist.strings`的操作一样**](#在xcode右侧选项卡进行点选)；

* 枚举映射语言字符串

  ```objective-c
  /// 系统支持语言
  #ifndef APP_LANGUAGE_ENUM_DEFINED
  #define APP_LANGUAGE_ENUM_DEFINED
  typedef NS_ENUM(NSInteger, AppLanguage) {
      AppLanguageBySys,/// App语言跟随当前系统
      AppLanguageChineseSimplified, /// zh-Hans：简体中文
      AppLanguageChineseTraditional,/// zh-Hant：繁体中文
      AppLanguageEnglish,           /// en：标准英语
      AppLanguageTagalog            /// tl：菲律宾他加禄语
  };
  #endif/* APP_LANGUAGE_ENUM_DEFINED */
  ```

* 关注实现类：[**@interface JobsLanguageManager : NSObject**]()

  * 获取当前语言

    ```objective-c
    /// 获取和设置当前语言
    @property(class,nonatomic,assign)AppLanguage language;
    /// 语言包路径
    + (NSBundle *)bundle;
    /// 枚举和语言字符串的转换
    + (NSString *)languageCodeForAppLanguage:(AppLanguage)language;
    /// 通过key取值对应的语言
    + (NSString *)localStringWithKey:(NSString *_Nonnull)key;
    ```

* 以宏的方式进行封装。<font color=red>**最上层使用`JobsInternationalization(@"")`**</font>

  关注实现类：[**`MacroDef_String.h`**](https://github.com/295060456/JobsOCBaseConfigDemo/blob/main/JobsOCBaseConfigDemo/OCBaseConfig/%E5%90%84%E9%A1%B9%E5%85%A8%E5%B1%80%E5%AE%9A%E4%B9%89/%E5%90%84%E9%A1%B9%E5%AE%8F%E5%AE%9A%E4%B9%89/MacroDef_Func/MacroDef_String.h)

  ```objective-c
  #pragma mark —— 国际化
  static inline NSString *_Nonnull JobsInternationalization(NSString *_Nonnull text){
      return [JobsLanguageManager localStringWithKey:text];
  }
  ```

  关注实现类：[**@interface** NSObject (Extras)](https://github.com/295060456/JobsOCBaseConfigDemo/tree/main/JobsOCBaseConfigDemo/JobsOCBaseCustomizeUIKitCore/NSObject/NSObject%2BCategory/NSObject%2BExtras)

  ```objective-c
  /// App 国际化相关系统宏二次封装 + 设置缺省值
  +(NSString *_Nullable)localStringWithKey:(nonnull NSString *)key{
      return NSLocalizedString(key, nil);
  }
  
  +(NSString *_Nullable)localizedString:(nonnull NSString *)key
                              fromTable:(nullable NSString *)tableName{
      return NSLocalizedStringFromTable(key,
                                        tableName,
                                        nil);
  }
  
  +(NSString *_Nullable)localizedString:(nonnull NSString *)key
                              fromTable:(nullable NSString *)tableName
                               inBundle:(nullable NSBundle *)bundle{
      return NSLocalizedStringFromTableInBundle(key,
                                                tableName,
                                                bundle ? : NSBundle.mainBundle,
                                                nil);
  }
  
  +(NSString *_Nullable)localizedString:(nonnull NSString *)key
                              fromTable:(nullable NSString *)tableName
                               inBundle:(nullable NSBundle *)bundle
                           defaultValue:(nullable NSString *)defaultValue{
      return NSLocalizedStringWithDefaultValue(key,
                                               tableName,
                                               bundle ? : NSBundle.mainBundle,
                                               defaultValue,
                                               nil);
  }
  ```

* 每一次切换语言环境，都必须重塑数据源。即，重新运行一次`JobsInternationalization`相关的代码。否则效果无法展示

* 语言环境切换的时候，对通知的使用

  ```objective-c
  #ifndef LanguageSwitchNotification_defined
  #define LanguageSwitchNotification_defined
  NSString *const JobsLanguageSwitchNotification = @"JobsLanguageSwitchNotification";// 语言切换
  #endif /* LanguageSwitchNotification_defined */
  ```

  ```objective-c
  @jobs_weakify(self)
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
      return nil;
  },nil, self),JobsLanguageSwitchNotification,nil);
  ```

### 图片本地化

* 方式一：和本地化代码中的字符串一样，通过`NSLocalizedString(key,comment)`来获取相应的字符串，然后根据这个字符串再获取图片。
  ```objective-c
  NSString *imageName = NSLocalizedString(@"icon", nil);
  UIImage *image = [UIImage imageNamed:imageName];
  self.imageView.image = image;
  ```

* 方式二：

### 第三方支援

*JobsLanguageManager.h*

```objective-c
//
//  JobsLanguageManager.h
//  JobsOCBaseConfigDemo
//
//  Created by User on 7/5/24.
//

#import <Foundation/Foundation.h>
#import "MacroDef_UserDefault.h"
/// 系统支持语言
#ifndef APP_LANGUAGE_ENUM_DEFINED
#define APP_LANGUAGE_ENUM_DEFINED
typedef NS_ENUM(NSInteger, AppLanguage) {
    AppLanguageBySys,/// App语言跟随当前系统
    AppLanguageChineseSimplified, /// zh-Hans：简体中文
    AppLanguageChineseTraditional,/// zh-Hant：繁体中文
    AppLanguageEnglish,           /// en：标准英语
    AppLanguageTagalog            /// tl：菲律宾他加禄语
};
#endif/* APP_LANGUAGE_ENUM_DEFINED */
FOUNDATION_EXTERN NSString * _Nonnull const JobsLanguageKey;
NS_ASSUME_NONNULL_BEGIN

@interface JobsLanguageManager : NSObject
/// 获取和设置当前语言
@property(class,nonatomic,assign)AppLanguage language;
/// 语言包路径
+ (NSBundle *)bundle;
/// 枚举和语言字符串的转换
+ (NSString *)languageCodeForAppLanguage:(AppLanguage)language;
/// 通过key取值对应的语言
+ (NSString *)localStringWithKey:(NSString *_Nonnull)key;

@end

NS_ASSUME_NONNULL_END
```

*JobsLanguageManager.m*

```objective-c
//
//  JobsLanguageManager.m
//  JobsOCBaseConfigDemo
//
//  Created by User on 7/5/24.
//

#import "JobsLanguageManager.h"

NSString *const JobsLanguageKey = @"JobsLanguageKey";
@implementation JobsLanguageManager

static NSBundle *bundle = nil;
static AppLanguage _language = AppLanguageBySys;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /// 读取存储的语言设置
        [self setLanguage:JobsGetUserDefaultIntegerForKey(JobsLanguageKey)];
    });
}
/// 语言包路径
+ (NSBundle *)bundle {
    return bundle;
}
/// 获取当前语言
+ (AppLanguage)language {
    return _language;
}
/// 设置当前语言
+ (void)setLanguage:(AppLanguage)language {
    _language = language;
    NSString *languageCode = [self languageCodeForAppLanguage:language];
    NSString *path = [NSBundle.mainBundle pathForResource:languageCode ofType:@"lproj"];
    if (path) {
        bundle = [NSBundle bundleWithPath:path];
    } else {
        bundle = NSBundle.mainBundle;
    }
    /// 存储当前语言设置
    JobsSetUserDefaultKeyWithInteger(JobsLanguageKey, language);
    JobsUserDefaultSynchronize;
}
/// 枚举和语言字符串的转换
+ (NSString *)languageCodeForAppLanguage:(AppLanguage)language {
    switch (language) {
        case AppLanguageChineseSimplified:
            return @"zh-Hans";
        case AppLanguageChineseTraditional:
            return @"zh-Hant";
        case AppLanguageEnglish:
            return @"en";
        case AppLanguageTagalog:
            return [NSBundle.mainBundle pathForResource:@"fil" ofType:@"lproj"] ? @"fil" : @"fil-PH";
        default:
            return NSLocale.preferredLanguages.firstObject;
    }
}
/// 通过key取值对应的语言
+ (NSString *)localStringWithKey:(NSString *_Nonnull)key {
    return [self localizedString:key 
                       fromTable:nil
                        inBundle:self.bundle];
}

@end
```

### 相关调用

* 原理：应用启动时，首先会读取**NSUserDefaults**中的key为`JobsLanguageKey`对应的value，该value是一个String数组。也就是说，我们访问这个名为`JobsLanguageKey`的key可以返回一个string数组，该数组存储着APP支持的语言列表，数组的第一项为APP当前默认的语言。

  ```objective-c
  + (void)initialize {
      static dispatch_once_t onceToken;
      dispatch_once(&onceToken, ^{
          /// 读取存储的语言设置
          [self setLanguage:JobsGetUserDefaultIntegerForKey(JobsLanguageKey)];
      });
  }
  ```

* 同理，既然我们可以通过`JobsLanguageKey`这个key从**NSUserDefaults**中取出语言数组，那么我们也可以给`JobsLanguageKey`这个key赋值来达到切换本地语言的效果，从此以后，我们就无需频繁的去模拟器的**设置**→**通用**→**语言与地区** 中切换语言。

  ```objective-c
  - (void)tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
      /// 当前点选的Cell
      UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  
      for (UITableViewCell *acell in tableView.visibleCells) {
          acell.accessoryType = acell == cell ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
      }
      [self setAppLanguageAtAppLanguage:self.dataMutArr[indexPath.row].appLanguage];/// 设置App语言环境并发送全局通知JobsLanguageSwitchNotification
      [self changeTabBarItemTitle:indexPath];///【App语言国际化】更改UITabBarItem的标题
      /// 重塑数据源
      [self.dataMutArr removeAllObjects];
      _dataMutArr = nil;
      /// 刷新本界面
      [self.tableView.mj_header beginRefreshing];
      @jobs_weakify(self)
      /// 2秒后退出本页面
  //    DispathdDelaySth(2.0, [weak_self backBtnClickEvent:nil]);
  }
  ```


### 总结

* 其实是操作语言包文件夹`*.lproj`内的`InfoPlist.strings`和`Localizable.strings`。所以一定确保这两个文件一定是包含在工程文件里（需要进入编译期）

* 语言包文件夹`*.lproj`的名字，就是每个语言对应的索引；

* `InfoPlist.strings`：App**名字**的多语言化；

* `Localizable.strings`：App**内容**的多语言化；

* <font color=red>**如果当前的key是锚定的中文，那么在`Localizable.strings(Chinese,Simplified)`文件中可以不写。因为当通过key检索不到内容时，这个时候key就是内容**</font>；

  * **Localizable.strings (English)** 

    ```objective-c
    "App国际化之应用内部切换语言" = "App language switch";
    "跟随系统" = "By System";
    "中文" = "Chinese";
    "英文" = "English";
    "他加禄语" = "Tagalog";
    ```

  * **Localizable.strings (Filipino)**  和 **Localizable.strings (Filipino (Philippines))** 

    ```objective-c
    "App国际化之应用内部切换语言" = "Paglipat ng wika ng app";
    "跟随系统" = "Sundin ang sistema";
    "中文" = "Intsik";
    "英文" = "Ingles";
    "他加禄语" = "Tagalog";
    ```

  * **Localizable.strings (Chinese,Simplified)** 

    ```objective-c
    /// 如果当前的key是锚定的中文，那么在`Localizable.strings(Chinese,Simplified)`文件中可以不写
    ```
