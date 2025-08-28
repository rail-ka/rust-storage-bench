export RUST_LOG=${RUST_LOG:-warn}
sleep=10
minutes=2

for vsize in 512; do
    for db in fjall redb sled canopydb; do
        cargo run --release -- --out task_h_rand_${db}_${vsize}v.jsonl --workload task-h --backend ${db} --minutes ${minutes} --value-size ${vsize} --items 10000 --random
        rm -rf .data
        sleep ${sleep}
    done
done

for vsize in 512; do
    for db in fjall redb sled canopydb; do
        cargo run --release -- --out task_h_seq_${db}_${vsize}v.jsonl --workload task-h --backend ${db} --minutes ${minutes} --value-size ${vsize} --items 10000
        rm -rf .data
        sleep ${sleep}
    done
done

for vsize in 20000; do
    for db in fjall canopydb sled redb; do
        cargo run --release -- --out task_h_large_rand_${db}_${vsize}v.jsonl --workload task-h --backend ${db} --minutes ${minutes} --value-size ${vsize} --items 150000 --random
        rm -rf .data
        sleep ${sleep}
    done
done

for vsize in 512; do
    for db in canopydb fjall sled; do
        cargo run --release -- --out task_h_large_rand_${db}_${vsize}v.jsonl --workload task-h --backend ${db} --minutes ${minutes} --value-size ${vsize} --items 5000000 --random
        rm -rf .data
        sleep ${sleep}
    done
done

minutes=1

# using workload g as heed panics on h
for vsize in 512; do
    for db in heed fjall redb sled canopydb ; do
        cargo run --release -- --out task_g_sync_rand_${db}_${vsize}v.jsonl --workload task-g --backend ${db} --minutes ${minutes} --value-size ${vsize} --items 10000 --random --fsync
        rm -rf .data
        sleep ${sleep}
    done
done
