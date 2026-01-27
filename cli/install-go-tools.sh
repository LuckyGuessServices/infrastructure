#!/bin/bash

# Install / Update go tools:

go install -n golang.org/x/vuln/cmd/govulncheck@latest
go install -n github.com/Antonboom/testifylint@latest
# See https://github.com/mvdan/gofumpt?tab=readme-ov-file#installation
go install -n mvdan.cc/gofumpt@latest

cat <<TEXT

It is recommended to add the function below to your .bashrc and call it before each commit to go repositories:

goch() {
    local targetDirectory="\${1:-.}"

    (
        cd "\$targetDirectory";
        go mod tidy;
        govulncheck -test ./...;
        testifylint --enable-all ./...;
        go vet ./...;
    )
}
TEXT
