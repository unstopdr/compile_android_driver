#!/bin/bash
set -e  # 遇到错误立即退出

# 进入 kade 同步好的内核源码目录
cd "${LYENV_HOME}/kernel" || exit 1

# 生成内核配置 (参考之前的 defconfig 合并)
make ARCH=arm64 O=out merge_config.sh \
  arch/arm64/configs/defconfig \
  arch/arm64/configs/xiaomi_defconfig \
  arch/arm64/configs/xiaomi_pissarro_defconfig

# 开启 SukiSU LKM 所需的内核配置选项 (如果 code/Makefile 未处理)
# echo "CONFIG_KSU_LKM=y" >> out/.config

# 编译内核和所有模块 (kade 会自动处理外部模块的链接)
make -j$(nproc) ARCH=arm64 O=out \
  CROSS_COMPILE=aarch64-linux-android- \
  CLANG_TRIPLE=aarch64-linux-gnu- \
  CC=clang \
  modules  # 编译所有模块，包括 SukiSU
