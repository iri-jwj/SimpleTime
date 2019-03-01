#!/usr/bin/env bash
#首先清理已生成的路由
flutter packages pub run build_runner clean
#重建路由
flutter packages pub run build_runner build --delete-conflicting-outputs