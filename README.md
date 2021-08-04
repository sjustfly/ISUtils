# ISUtils
project utils

流程  
1，修改代码  
2，修改 ISUtils.podspec 版本号  
3，打tag推送到服务器  
4，本地验证  
5，发布  
6, 引用本工程的地方安装 pod install --repo-update   


### 发布的工具不能使用目录区分 ###

### 本地验证 pod lib lint ISUtils.podspec --verbose --allow-warnings ###
### 远程严重 pod spec lint ISUtils.podspec --verbose --allow-warnings ###
### 发布 pod trunk push ISUtils.podspec --allow-warnings ###
