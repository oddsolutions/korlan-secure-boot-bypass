<?php
# https://3v4l.org/Z5dm4
define("_SPI_NAND_PAGE_SIZE_2KBYTE", 0x0800);
define("_SPI_NAND_PAGE_SIZE_4KBYTE", 0x1000);
define("_SPI_NAND_CHIP_SIZE_1GBIT", 0x08000000);
define("_SPI_NAND_ERASESIZE", 0x200000);
define("CONFIG_TPL_SIZE_PER_COPY", 0x200000);
define("CONFIG_TPL_COPY_NUM", 4);
define("BOOT_TOTAL_PAGES", 1024);
define("NAND_RSV_BLOCK_NUM", 48);
define("SZ_1M", 0x00100000);
define("SZ_128K", 0x00020000);


$parts = [
    ["name" => "bootloader", "offset" => 0, "size" => BOOT_TOTAL_PAGES * _SPI_NAND_PAGE_SIZE_2KBYTE],
    ["name" => "tpl", "offset" => 0, "size" => CONFIG_TPL_SIZE_PER_COPY * CONFIG_TPL_COPY_NUM],
    ["name" => "fts", "offset" => 0, "size" => 1 * SZ_1M],
    ["name" => "factory", "offset" => 0, "size" => 4 * SZ_1M],
    ["name" => "recovery", "offset" => 0, "size" => 12 * SZ_1M],
    ["name" => "boot", "offset" => 0, "size" => 12 * SZ_1M],
    ["name" => "system", "offset" => 0, "size" => 30 * SZ_1M],
    ["name" => "cache", "offset" => -1, "size" => 0],
];
$offset = 0;
foreach ($parts as $part) {
    if ($part['name'] == "bootloader") {
        echo "dd if=nand_MT29F1G01_0.bin of=split/".$part['name'].".bin bs=1 count=".$part['size']."\n";
        $offset += $part['size'] + (NAND_RSV_BLOCK_NUM * SZ_128K);
    } else {
        $size = $part['size'];
        if ($part['name'] == "cache") {
            $size = _SPI_NAND_CHIP_SIZE_1GBIT - $offset;
        }
        if ($size % SZ_128K) {
            $size += $size % SZ_128K;
        }
        echo "dd if=nand_MT29F1G01_0.bin of=split/".$part['name'].".bin bs=1 skip=".$offset." count=".$size."\n";
        $offset += $size;
    }
    
    echo "OFFSET: ".$offset."\n";
    
}

echo "\n\n";
echo "bootloader size: ".(0x1500000 - $parts[3]['size'] - $parts[2]['size'] - $parts[1]['size']).", offset:0 \n";
echo "tpl size: ".$parts[1]['size'].", offset: ".(0x1500000 - $parts[3]['size'] - $parts[2]['size'] - $parts[1]['size'])."\n";
echo "fts size: ".$parts[2]['size'].", offset: ".(0x1500000 - $parts[3]['size'] - $parts[2]['size'])."\n";
echo "factory size: ".$parts[3]['size'].", offset: ".(0x1500000 - $parts[3]['size'])."\n";
echo "recovery size: ".$parts[4]['size'].", offset: ".(0x1500000)."\n";
echo "boot size: ".(0x2100000 - 0x1500000).", offset: ".(0x2100000)."\n";
echo "system size: ".$parts[6]['size'].", offset: ".(0x2100000 + $parts[5]['size'])."\n";
echo "cache size: "._SPI_NAND_CHIP_SIZE_1GBIT - (0x2100000 + $parts[5]['size'] + $parts[6]['size']).", offset: ".(0x2100000 + $parts[5]['size'] + $parts[6]['size'])."\n";