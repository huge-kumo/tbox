#!/bin/bash

# code context
if [ "$1" == "code" ]; then
    # save mode
    if [ "$2" == "save" ]; then
        lab_path="$HOME/Laboratory"
        if [ ! -d "$lab_path" ]; then
            mkdir $lab_path
        fi
        
        dst_path=$lab_path/${PWD##*/}
        if [ -d "$dst_path" ]; then
            dst_path=$dst_path$(date +%s)
        fi
        mkdir $dst_path
        cp -R *  $dst_path
        exit 0
    fi

    # create temporary dir mode
    cmd_output=$(mktemp -d)
    # go type
    if [ "$2" == "go" ]; then
        touch $cmd_output/go_test.go
        (cd $cmd_output && go mod init golang_test)
        (cd $cmd_output && echo -e "package go_test\nimport \"testing\"\nfunc TestName(t *testing.T) {\n\n}" > go_test.go)
        (cd $cmd_output && go fmt .)
    fi

    code $cmd_output
fi

# weather context: $2 is city name
if [ "$1" == "weather" ]; then
    curl wttr.in/$2?m
fi

# http server: $2 is http port
if [ "$1" == "http" ]; then
    clear
    qrencode -m 2 -t utf8 <<< "http://$2:$3"

    source_code="cGFja2FnZSBtYWluCgppbXBvcnQgKAoJImZsYWciCgkiZm10IgoJImxvZyIKCSJuZXQvaHR0cCIKCSJvcyIKKQoKZnVuYyBtYWluKCkgewoJZmxhZy5QYXJzZSgpCglmcyA6PSBodHRwLkZpbGVTZXJ2ZXIoaHR0cC5EaXIob3MuQXJnc1syXSkpCglodHRwLkhhbmRsZSgiLyIsIGZzKQoJbG9nLlByaW50ZigiTGlzdGVuaW5nIG9uIDolcy4uLiIsIG9zLkFyZ3NbMV0pCglpZiBlcnIgOj0gaHR0cC5MaXN0ZW5BbmRTZXJ2ZShmbXQuU3ByaW50ZigiOiVzIiwgb3MuQXJnc1sxXSksIG5pbCk7IGVyciAhPSBuaWwgewoJCWxvZy5GYXRhbChlcnIpCgl9Cn0K"
    cmd_output=$(mktemp -d)
    current_path=$(pwd)
    touch $cmd_output/http.go
    (cd $cmd_output && echo -n $source_code | base64 --decode > http.go)
    (cd $cmd_output && go run http.go $3 $current_path)
fi
