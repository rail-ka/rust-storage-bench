#!/usr/bin/env nu

#
# CONFIG
#

let prefix = "ycsb"
let data_dir = ".data"
let seconds = 1 * 60
let cache_mib = 1
let value_size = 512
let db_size = 1_000_000

#
# BENCH
#

alias bench = cargo run -r --

let cache = $cache_mib * 1_024 * 1_024
let ks = $db_size / 1000;

export def main [...tasks: string] {

let tasks = if ($tasks | is-empty) {
    ["a", "b", "c"]
} else {
    $tasks
}

# ycsb task list
for task in $tasks {
    let prefix = [$prefix, $task, (($ks | into string) + "K")] | str join "_";

    for db in [
        "fjall", "sled", "canopydb"
    ] {
        let out = $prefix + "_" + $db + ".jsonl";
        print $out;
        RUST_LOG=error bench run --backend $db --cache-size $cache --data-dir $data_dir --seconds $seconds --sync --out $out ycsb --type $task --value-size $value_size --item-count $db_size
        sleep 100ms
    }

    # Print report name for the workload
    let report_file = ("report_" + $prefix + ".html")
    print $report_file;

    # bench report --out $report_file (($prefix + "_*.jsonl") | into glob)
    # google-chrome $report_file
}

}
