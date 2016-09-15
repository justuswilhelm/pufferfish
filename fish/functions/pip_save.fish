function pip_save
    set -l reqs "requirements.txt"
    pip install $argv[1]
    set freeze (pip freeze | grep $argv[1])
    set tfile (mktemp)
    cp $reqs $tfile
    echo $freeze >>$tfile
    uniq $tfile | sort -o $reqs
end
