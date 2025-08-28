#!/bin/nu

#
# REPORT
#

alias bench = cargo run --

# ycsb task list
let prefix = "ycsb"
let tasks = $env.args | default ["a", "b", "c"]
let db_size = 1_000_000
let ks = $db_size / 1000;

for task in $tasks {
    let prefix = [$prefix, $task, (($ks | into string) + "K")] | str join "_";

    # Generate report for the workload
    let report_file = ("report_" + $prefix + ".html")
    print $report_file;

    bench report --out $report_file (($prefix + "_*.jsonl") | into glob)
    google-chrome $report_file
}

let prefix = "queue"
let value_size = 128;
let report_file = $"report_($prefix)($value_size).html";
print $report_file;
bench report --out $report_file ($"($prefix)_*.jsonl" | into glob);
google-chrome $report_file
