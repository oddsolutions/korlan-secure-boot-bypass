#!/bin/bash

dd if=nand_MT29F1G01_0.bin of=split2/bootloader.bin bs=1 count=2097152
dd if=nand_MT29F1G01_0.bin of=split2/junk.bin bs=1 skip=2097152 count=6291456
dd if=nand_MT29F1G01_0.bin of=split2/tpl.bin bs=1 skip=8388608 count=8388608
dd if=nand_MT29F1G01_0.bin of=split2/fts.bin bs=1 skip=16777216 count=1048576
dd if=nand_MT29F1G01_0.bin of=split2/factory.bin bs=1 skip=17825792 count=4194304
dd if=nand_MT29F1G01_0.bin of=split2/recovery.bin bs=1 skip=22020096 count=12582912
dd if=nand_MT29F1G01_0.bin of=split2/boot.bin bs=1 skip=34603008 count=12582912
dd if=nand_MT29F1G01_0.bin of=split2/system.bin bs=1 skip=47185920 count=31457280
dd if=nand_MT29F1G01_0.bin of=split2/cache.bin bs=1 skip=78643200 count=55574528
