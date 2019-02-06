echo "START $(date)"
./run.sh -h
sleep 10
./run.sh -m scan -t http://172.17.0.1/
sleep 10
./run.sh -m source -t src-javascript-example
sleep 10
./run.sh -m secrets -t https://github.com/d47zm3/git-scan.git
sleep 10
./run.sh -m secrets -t https://github.com/sskorc/repos-node.git
echo "END $(date)"
