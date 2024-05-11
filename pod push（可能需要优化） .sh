#!/bin/bash

# Git 远程仓库地址
remote_repo="https://github.com/295060456/JobsBaseConfig.git"

# 提示用户输入 commit 文字
read -p "请输入 commit 文字（回车即为空提交）: " commit_message

# 如果用户没有输入 commit 文字，默认使用空字符串
if [ -z "$commit_message" ]; then
  commit_message="Empty commit"
fi

# 添加所有更改到暂存区
git add .

# 提交更改
git commit -m "$commit_message"

# 推送到远程仓库
git push origin master
