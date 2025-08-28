#!/bin/nu

#
# CONFIG
#

let prefix = "queue";
let data_dir = ".data";
let seconds = 1 * 60;
let cache_mib = 16;
let value_size = 512;

#
# BENCH
#

alias bench = cargo run -r --

let cache = $cache_mib * 1_024 * 1_024

for db in ["fjall", "sled", "canopydb"] {
    rm -rf .data
    let out = $"($prefix)_($db).jsonl";
    print $out;
    RUST_BACKTRACE=full RUST_LOG=warn bench run --seconds $seconds --out $out --backend $db --data-dir $data_dir --cache-size $cache queue --backpressure --value-size $value_size
    sleep 500ms
}

# Print report name for the workload
let report_file = $"report_($prefix)($value_size).html";
print $report_file;

# bench report --out $report_file ($"($prefix)_*.jsonl" | into glob);
# google-chrome $report_file
