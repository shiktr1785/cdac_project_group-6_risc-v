#!/usr/bin/env bash
set -e

RTL_DEPS=()
TB_DEPS=()

RTL_INC_DIRS=()
TB_INC_DIRS=()

# RTL include directories
[ -d rtl/common ] && RTL_INC_DIRS+=("rtl/common")

# TB include directories
[ -d tb/global ] && TB_INC_DIRS+=("tb/global")

# RTL compilation units (only .sv, never .svh)
for f in \
  rtl/common/pkg.sv \
  rtl/common/defines.sv
do
  [ -f "$f" ] && RTL_DEPS+=("$f")
done

# TB compilation units
for f in \
  tb/global/uvm_pkg.sv
do
  [ -f "$f" ] && TB_DEPS+=("$f")
done
