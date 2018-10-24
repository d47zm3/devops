vegeta attack -duration=3m -rate 1000 -workers 100 -targets=targets.txt
echo "GET https://google.com/" | vegeta attack -duration=3m -rate 1000 | tee results.bin | vegeta report
