# JENS碳积分游戏化系统

一个基于运动监测数据的碳积分游戏化系统，通过记录用户运动数据，计算碳减排量，奖励碳积分，并提供积分兑换功能，鼓励用户参与低碳环保活动。

## 系统功能

### 运动数据监测
- 模拟手表传感器，精准监测用户运动数据
- 记录心率、GPS位置、步数等多维度数据
- 实时更新运动数据，提高用户参与感

### 碳积分奖励
- 根据运动数据自动计算碳减排量
- 将碳减排量转换为碳积分
- 提供积分获取明细和汇总信息

### 奖品兑换
- 丰富的奖品选择，包括虚拟权益和实物奖励
- 便捷的兑换流程，提升用户体验
- 完整的兑换记录管理

### 成就系统
- 多样化的成就设定，增强游戏化体验
- 成就达成自动奖励积分
- 成就进度实时展示

## 技术架构

本项目采用前后端分离架构：

### 前端
- 框架：Vue3 + TypeScript
- UI组件库：Element Plus
- 状态管理：Pinia
- 路由：Vue Router
- HTTP客户端：Axios
- 图表库：ECharts

### 后端
- 框架：Spring Boot 2.7.x (JDK 17)
- ORM框架：MyBatis-Plus
- 数据库：MySQL 9.2.0
- 安全框架：Spring Security + JWT
- API文档：Swagger/OpenAPI

## 项目结构

```
JENS-green-u/
├── docs/                  # 文档目录
│   ├── JENS_db_design.md  # 数据库设计文档
│   ├── JENS_api_design.md # API接口设计文档
│   └── JENS_system_architecture.md # 系统架构设计文档
│
├── jens-backend/          # 后端项目目录
│   ├── src/               # 源码目录
│   ├── pom.xml            # Maven配置
│   └── README.md          # 后端说明文档
│
├── jens-frontend/         # 前端项目目录
│   ├── src/               # 源码目录
│   ├── package.json       # NPM配置
│   └── README.md          # 前端说明文档
│
├── image/                 # 图片资源目录
│   ├── Prize/             # 奖品图片
│   ├── login.png          # 登录界面
│   ├── register.png       # 注册界面
│   └── logo.png           # 系统LOGO
│
├── update.md              # 项目更新日志
└── README.md              # 项目说明
```

## 开发环境

- 操作系统：Windows 10专业版22H2
- JDK版本：17
- Node.js版本：16+
- MySQL版本：9.2.0
- 数据库连接：localhost:3306，用户名：root，密码：root

## 使用说明

### 后端启动
```bash
cd jens-backend
mvn spring-boot:run
```

### 前端启动
```bash
cd jens-frontend
npm install
npm run serve
```

## 作者信息

- 作者：jenkenssq
- GitHub: https://github.com/jenkenssq
- Email: jenkens@qq.com

## 许可证

本项目采用 MIT 许可证 