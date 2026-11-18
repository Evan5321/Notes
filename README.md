# Notes

个人学习笔记仓库，记录我在**经济学、数学、历史、英语**上的整理，以及**编程**（C/C++、Java、MySQL、Maven）的代码示例与学习笔记。

笔记以 Markdown 和 LaTeX 为主，重要内容都提供了编译好的 PDF 成品；代码目录中的示例基本都可以直接编译运行。

---

## 📁 目录总览

```
Notes/
├── 经济/                          微观经济学讲义、题目摘编与配图（LaTeX）
├── 数学/                          高等数学：极限的定义与证明
├── 历史/                          高中历史「命题密码」专题
├── EN/                            英语词根词缀、词汇与错题
├── C_CodeBase/                    C/C++ 语法、算法与数据结构示例
├── Java/                          Java 语法示例与常用类代码库
├── Maven/                         Maven 学习笔记
├── MySQL/                         MySQL 学习笔记（9 个专题脚本）
└── duolingo_spanish_vocabulary.csv  Duolingo 西班牙语课程词汇表
```

---

## 📘 经济（微观经济学）

以 LaTeX 整理的微观经济学笔记，覆盖从消费者理论到市场结构的完整主线，并配有习题与示意图。

| 文件 | 内容 |
| --- | --- |
| `Notes.tex` / `Notes.pdf` | 主线讲义（约 650 行源码） |
| `题目摘编.tex` / `.pdf` | 第一章导论题库：名词解释、单选、多选、判断 |
| `图形.tex` / `.pdf` | 用 TikZ 绘制的预算线与无差异曲线（消费者均衡）示意图 |
| `消费者均衡公式2推导过程.md` | 消费者均衡公式的独立推导笔记 |
| `fig/` | 成本曲线、三条产量曲线、垄断企业收益曲线等配图 |

**`Notes.tex` 主要章节：**

- **需求价格弹性** —— 点弹性与弧弹性公式
- **【二级结论】消费者均衡公式推导** —— 从柯布-道格拉斯效用函数推导最优消费组合
- **最优消费组合类型题目** —— 柯布-道格拉斯（Cobb-Douglas）、完全替代品、完全互补品（Leontief）及其他类型
- **生产知识点 & 生产类题目** —— 三条产量曲线的关系、成本最小化与产量最大化
- **完全竞争市场** —— 成本曲线、基础公式与课堂例题
- **不完全竞争市场** —— 垄断（含基本知识点与例题）、垄断竞争、寡头、古诺模型、卡特尔

> 中文文档，使用 **XeLaTeX** 编译；`经济/.vscode/settings.json` 中已配置好 LaTeX Workshop 的编译 recipe。

---

## 📐 数学

- `极限的定义和证明.tex` / `.pdf` —— **极限的定义和证明题型**
  - 数列的极限：ε-N 定义、极限证明例题（含完整证明过程）
  - 函数的极限

同样使用 XeLaTeX + `elegantnote` 模板编译。

---

## 🏛️ 历史

- `历史命题密码-近代中国篇.md` / `.pdf` —— 约 750 行的高中历史「**命题密码**」专题笔记，按考点组织并附高考真题例题（含答案解析）。

> 注：文件名写作「近代中国篇」，但文件内容标题与实际考点均围绕**中国古代史**，实际覆盖：精耕细作、商品经济、重农抑商、商人地位、士农工商、中央集权与君主专制、宗族观念、郡国并行制、藩镇、刺史、人身关系、坞堡、赋税制度演变（租庸调到一条鞭法、摊丁入亩）、儒学与思想、血缘政治与官僚政治、法治与教化、区域经济、户籍制度、坊市制/草市/市镇经济、经济与文化重心南移、货币与白银、盐铁官营、雇佣经济、官营手工业、财政、土地兼并等。

---

## 🔤 英语（EN）

`EN/词根词缀/` 下按「词根 → 词缀 → 练习 → 词汇 → 错题」组织：

- `词根词缀（一）收集版.md` —— 以 `gn/gen`（生、生产）为代表的词根词族整理
- `拉丁-希腊后缀大全.md` —— `‑erate / ‑sis / ‑ius / ‑iture` 等后缀详解
- `拉丁-希腊后缀练习.md` —— 补全拼合、单选、同族辨析、归类、路径推导五种题型 + 答案解析
- `词汇.md` —— 日常词汇积累
- `错题本.md` —— 易混词辨析（如 preserve / conserve / reserve / deserve）

此外根目录的 `duolingo_spanish_vocabulary.csv` 是 Duolingo 西语课程的完整词汇表（约 7000 条，含 Skill / Spanish / English 三列），可用于背单词或自建抽认卡。

---

## 💻 C_CodeBase（C/C++）

面向初学者的 C/C++ 练习与算法实现合集，文件大多带有中文注释，适合当范例看。

- **语法基础**：数组、结构体、函数模板、头文件与 CPP 分离（`理解头文件和CPP文件的使用/`）
- **排序算法**：冒泡排序（含带注释版、多维数组版）、希尔排序、归并排序
- **递归与递推**：汉诺塔、递推与递归算法问题实例
- **高精度运算**：大整数阶乘、高精度加/乘、大整数最大因子
- **搜索算法**：DFS / BFS（农夫和牛、水洼地、数房子）
- **数据结构**：单链表、链表版成绩管理系统、二叉树、完整成绩管理系统
- **文件操作**：C 语言文件读写、二进制读写

编译方式：`g++ 文件名.cpp -o 文件名.exe`，VS Code 已配置 `g++.exe` 构建任务（`.vscode/tasks.json`）。

---

## ☕ Java

- `JavaCodeBase.md` —— **Java 常用 API 代码库**，共 11 篇专题：
  String 字符串处理、字符串一致性比较、Arrays、StringBuilder、Calendar、IO 文件读写、二进制文件读写、HttpURL 请求、InetAddress、线程池提交任务的三种方式、Future 的两种用法
- 可直接运行的单文件示例：`HelloWorld`、`InheritanceExample`、`ExceptionExample`、`FileIOStreamExample`、`MultiThreadExample`、`ThreadPoolExample`、`CalendarExample`、`DateExample`、`RandomExample`、`SystemExample`、`ClassSystemExample`

---

## 🔧 Maven

`Maven/Maven.md` —— Maven 实战速查笔记：

- 核心概念：仓库、生命周期
- 基础生命周期命令：`clean / compile / test / package / install / deploy`
- 组合命令与高频通用参数
- 依赖相关命令：依赖树排查、源码下载、清理失效缓存
- 快速生成 Maven 项目骨架

---

## 🗄️ MySQL

`MySQL/` 下为按主题拆分的 SQL 学习脚本，每个文件都带完整注释，可直接按顺序执行：

| 文件 | 主题 |
| --- | --- |
| `01_database_table.sql` | 数据库 / 数据表创建、删除、选择与常用数据类型 |
| `02_crud_operations.sql` | CRUD 操作 + WHERE / UPDATE / DELETE 详解 |
| `03_union_orderby.sql` | UNION 与 ORDER BY |
| `04_group_join.sql` | 分组（GROUP BY）与连接（JOIN） |
| `05_regexp.sql` | 正则表达式（REGEXP / RLIKE） |
| `06_transaction.sql` | 事务与 ACID 特性 |
| `07_alter.sql` | ALTER 修改表结构 |
| `08_index_temp_copy_meta.sql` | 索引、临时表、复制表、元数据 |
| `09_sequence_duplicate.sql` | 序列（AUTO_INCREMENT）与重复数据处理 |

---

## 🛠️ 如何编译 / 运行

```bash
# LaTeX（中文笔记，推荐 XeLaTeX）
xelatex Notes.tex          # 需要 TeX Live / MiKTeX，经济笔记还依赖 elegantnote 模板

# C/C++
g++ 文件名.cpp -o 文件名.exe

# Java
javac HelloWorld.java && java HelloWorld

# SQL
mysql -u 用户名 -p < MySQL/01_database_table.sql
```

---

## 说明

- 本仓库是**个人学习笔记**，以整理和复习为目的，内容会随学习进度持续更新。
- 仓库中的 PDF 为对应 `.tex` 的编译成品，方便直接阅读；Markdown 笔记中的 `[TOC]` 在支持该语法的编辑器（如 Typora / VS Code 插件）中可自动生成目录。
- 历史笔记文件名与实际内容存在「近代 / 古代」的表述差异，以文件内标题与考点为准。
