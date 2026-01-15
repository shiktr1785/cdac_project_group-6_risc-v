#!/usr/bin/env bash
set -e

RTL_DEPS=()
TB_DEPS=()

# RTL dependencies (add only if file exists)
for f in \
  rtl/common/pkg.sv \
  rtl/common/defines.sv
do
  if [ -f "$f" ]; then
    RTL_DEPS+=("$f")
  fi
done

# TB dependencies
for f in \
  tb/global/uvm_pkg.sv
do
  if [ -f "$f" ]; then
    TB_DEPS+=("$f")
  fi
done

# Debug (temporary, remove later)
echo "RTL_DEPS = ${RTL_DEPS[@]}"
echo "TB_DEPS  = ${TB_DEPS[@]}"
