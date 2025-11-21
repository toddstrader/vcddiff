#!/bin/bash
# Copyright (c) 1991-2004 Pragmatic C Software Corp.

set -e
set -x

if [[ "$(uname -s)" != MINGW* && "$(uname -s)" != MSYS* && "$(uname -s)" != CYGWIN* ]]; then
  FIFO_SUPPORTED=1
else
  FIFO_SUPPORTED=0
fi

! ./vcddiff examples/counter.vcd examples/counter.vcd | grep -q .
! ./vcddiff examples/counter.vcd examples/counter.time.no_diff.vcd | grep -q .
! ./vcddiff examples/counter.vcd examples/counter.change_reorder.no_diff.vcd | grep -q .
! ./vcddiff examples/counter.vcd examples/counter.var_reorder.no_diff.vcd | grep -q .
! ./vcddiff examples/counter.vcd examples/counter.identifier.no_diff.vcd | grep -q .
if [ "$FIFO_SUPPORTED" = "1" ]; then
  ! ./vcddiff <(cat examples/counter.vcd) <(cat examples/counter.vcd) | grep -q .
fi

./vcddiff examples/counter.vcd examples/counter.end_time.diff.vcd |
    grep "Files have different end times"
./vcddiff examples/counter.vcd examples/counter.edge_time.diff.vcd |
    grep "t.clk .* at time 20 next occurence at time 21"
./vcddiff examples/counter.vcd examples/counter.sig_name.diff.vcd |
    grep "not defined in both files"
./vcddiff examples/counter.vcd examples/counter.new_sig.diff.vcd |
    grep "Ignoring signal t.the_sub.new_sig .* - not defined in both files"
if [ "$FIFO_SUPPORTED" = "1" ]; then
  ./vcddiff <(cat examples/counter.vcd) <(cat examples/counter.end_time.diff.vcd) |
      grep "Files have different end times"
fi
