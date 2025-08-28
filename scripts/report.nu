#!/usr/bin/env nu

#
# REPORT
#

alias bench = cargo run --

# ycsb task list
let prefix = "ycsb"
let db_size = 1_000_000
let ks = $db_size / 1000;

export def main [...tasks: string] {
    let tasks = if ($tasks | is-empty) {
        ["a", "b", "c"]
    } else {
        $tasks
    }

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
}
