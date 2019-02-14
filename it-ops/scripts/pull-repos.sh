USER=d47zm3; PAGE=1
curl "https://api.github.com/users/$USER/repos?page=$PAGE&per_page=100" |
  grep -e "\"name" |
  cut -d \" -f 4 > repos.tmp

while read repo
do
git clone git@github.com:${USER}/${repo}.git
done < repos.tmp
rm repos.tmp
