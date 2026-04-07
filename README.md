# Hex2077 Agent - LazyCat 应用

Hex2077 AI助手 - 支持多平台接入的智能AI机器人

## 功能特性

- 支持多种AI模型：OpenAI、DeepSeek、Grok、Gemini
- 多平台聊天机器人集成：飞书、钉钉、QQ、微信公众号、企业微信
- 知识库管理功能
- Web界面管理

## 安装要求

- 懒猫微服系统版本 >= 1.3.8
- 必须配置AI API密钥

## 使用说明

1. 安装时填写AI API密钥（必填）
2. 可选择配置知识库密码（默认：admin123）
3. 根据需要启用各平台聊天机器人
4. 安装完成后访问应用页面即可使用

## 配置说明

### 必填配置
- **AI API Key**: 你的AI提供商API密钥

### 可选配置
- **AI Base URL**: API基础地址（默认OpenAI）
- **AI Model**: 模型名称（默认gpt-4o）
- **知识库密码**: 访问/knowledge的密码

### 平台集成配置
- 飞书、钉钉、QQ、微信公众号、企业微信等
- 详细配置请参考各平台官方文档

## 数据存储

应用数据存储在 `/lzcapp/var/data`，包括：
- 知识库数据
- 聊天记录
- WeChat机器人会话数据

## 构建和发布

```bash
# 构建应用
lzc-cli project build -o hex2077-agent.lpk

# 复制镜像到懒猫仓库（需要先登录）
lzc-cli appstore copy-image ghcr.io/justlovemaki/hex2077-agent:latest

# 发布应用
lzc-cli appstore publish hex2077-agent.lpk
```

## 更多信息

- 项目地址: https://github.com/justlovemaki/hex2077-agent
# hex2077-agent-lzcapp
# hex2077-agent-lzcapp
