#!/bin/bash

# Install / Update go tools:

curl -sSfL https://golangci-lint.run/install.sh | sh -s -- -b $(go env GOPATH)/bin v2.8.0
go install golang.org/x/vuln/cmd/govulncheck@latest

cat <<TEXT

It is recommended to add the function below to your .bashrc and call it before each commit to go repositories:

goch() {
    local targetDirectory="\${1:-.}"

    (
        cd "$targetDirectory"

        go mod tidy
        govulncheck -test ./...

        golangci-lint fmt
        golangci-lint run --fix
    )
}
TEXT
