param($binary,$version='')

$buildTime = (Get-Date).ToUniversalTime() | Get-Date -UFormat '%Y-%m-%dT%TZ'
$env:GOOS = "windows"
$env:GOARCH = "amd64"
go build -o $out.exe -ldflags="-s -w -X main.version=v$version -X main.commit=$env:GITHUB_SHA -X 'main.built=$buildTime'" github.com/xitonix/$binary