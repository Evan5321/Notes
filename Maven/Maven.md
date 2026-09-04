# Maven

## Maven的一些概念
### 仓库
在Maven中有仓库的概念，仓库是存放jar包的地方，Maven有三种仓库：
1. 本地仓库（Local Repository）：默认路径为 `C:\Users\用户名\.m2\repository`，在Linux/MacOS上则是HOME目录下的.m2/repository。它们用来存放本机下载的jar包。
2. 中央仓库（Central Repository）：Maven官方提供的远程仓库，存放了大量开源jar包。
3. 私服仓库（Private Repository）：公司内部搭建的Maven仓库，用于存放公司内部的jar包。

### 生命周期
Maven的生命周期包含多个阶段，每个阶段对应一个任务，生命周期执行顺序为：
1. clean：清理
2. validate：验证
3. compile：编译
4. package：打包
5. verify：验证
6. install：安装到本地仓库
7. site：生成项目文档
8. deploy: 发布到远程仓库


## 一、基础生命周期命令（执行顺序：clean → compile → test → package → install → deploy）
### 1. mvn clean 清理
删除 `target` 编译输出目录
```bash
# 基础清理
mvn clean
# 清理并跳过测试
mvn clean -DskipTests
```

### 2. mvn compile 编译源码
只编译 `src/main/java` 业务代码，不执行测试
```bash
mvn compile
# 强制重新下载依赖、编译
mvn compile -U
```

### 3. mvn test 执行单元测试
运行 `src/test/java` 下所有JUnit测试
```bash
# 完整测试
mvn test
# 跳过所有测试（编译不执行测试）
mvn test -DskipTests
# 只执行指定测试类
mvn test -Dtest=UserTest
```

### 4. mvn package 打包（最常用）
编译+测试，输出 jar/war 包到 target
```bash
# 默认打包，执行测试
mvn package
# 打包并跳过测试（开发快速打包）
mvn package -DskipTests
# 强制更新依赖打包
mvn package -U -DskipTests
```

### 5. mvn install 安装到本地仓库
打包后把 jar 存入本机 `.m2` 仓库，其他项目可依赖
```bash
mvn install -DskipTests
```

### 6. mvn deploy 发布到远程私服（公司内网仓库）
需在pom配置 distributionManagement 私服地址
```bash
mvn deploy -DskipTests
```

## 二、组合链式命令（一次执行多个生命周期）
```bash
# 清理 → 编译 → 打包（跳过测试）
mvn clean package -DskipTests

# 清理 → 打包 → 安装到本地仓库
mvn clean install -DskipTests

# 清理+发布私服
mvn clean deploy -DskipTests
```

## 三、高频通用参数（所有mvn命令都可追加）
| 参数 | 作用 |
|------|------|
| `-DskipTests` | 跳过单元测试，不执行测试代码 |
| `-Dmaven.test.skip=true` | 彻底跳过测试（连测试代码都不编译） |
| `-U` / `--update-snapshots` | 强制远程拉取快照依赖，修复依赖缺失/缓存损坏 |
| `-X` | 开启完整调试日志，排查依赖下载报错 |
| `-e` | 打印完整异常堆栈 |
| `-Pxxx` | 激活指定环境配置（如 `-Pprod` 生产环境） |
| `-Dmaven.compiler.source=17` | 临时指定编译JDK版本 |

示例：调试依赖下载失败
```bash
mvn clean compile -U -X
```

## 四、依赖相关专用命令
### 1. 查看项目依赖树（排查包冲突）
```bash
# 打印完整依赖树
mvn dependency:tree
# 只过滤mysql相关依赖
mvn dependency:tree | findstr mysql
```
### 2. 下载缺失源码/文档
```bash
mvn dependency:sources
mvn dependency:resolve -Dclassifier=javadoc
```
### 3. 清理本地仓库失效缓存
```bash
mvn dependency:purge-local-repository
```

## 五、创建Maven Java项目（快速生成骨架）
### 普通Java标准项目
```bash
mvn archetype:generate \
-DgroupId=com.Esliby \
-DartifactId=TCPWebChatroom \
-Dversion=1.0-SNAPSHOT \
-DarchetypeArtifactId=maven-archetype-quickstart \
-DinteractiveMode=false
```
参数说明：
- groupId：公司/组织包名
- artifactId：项目名
- version：版本号
- archetypeArtifactId：项目骨架模板
