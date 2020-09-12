param($out,$version='')

$buildTime = (Get-Date).ToUniversalTime() | Get-Date -UFormat '%Y-%m-%dT%TZ'
$env:GOOS = "windows"
$env:GOARCH = "amd64"
go build -o $out -ldflags="-X main.version=v$version -X main.commit=$env:GITHUB_SHA -X main.built=$buildTime" *.go