#!/usr/bin/env bash

RTL_DEPS=()
TB_DEPS=()

# Add RTL deps only if they exist
for f in \
  rtl/common/pkg.sv \
  rtl/common/defines.sv
do
  [ -f "$f" ] && RTL_DEPS+=("$f")
done

# Add TB deps only if they exist
for f in \
  tb/global/uvm_pkg.sv
do
  [ -f "$f" ] && TB_DEPS+=("$f")
done
