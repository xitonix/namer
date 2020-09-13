param($version,$binary)

If ( ! ( Test-Path Env:wix ) ) {
    Write-Error 'WiX not installed; cannot find %wix%.'
    exit 1
}

$filename="$binary_v${version}_amd64.msi"
$wixVersion="0.0.0"
$wixVersionMatch=[regex]::Match($version, '^([0-9]+\.[0-9]+\.[0-9]+)')
If ( $wixVersionMatch.success ) {
    $wixVersion=$wixVersionMatch.captures.groups[1].value
} Elseif ( $version -ne 'dev' ) {
    Write-Error "Invalid version $version"
    exit 1
}

.\build.ps1 `
  -version $version `
  -binary $binary

& "${env:wix}bin\candle.exe" `
  -nologo `
  -arch x64 `
  "-dAppVersion=$version" `
  "-dWixVersion=$wixVersion" `
  "-dBinary=$binary" `
  release.wxs
If ( $LastExitCode -ne 0 ) {
    exit $LastExitCode
}
& "${env:wix}bin\light.exe" `
  -nologo `
  -dcl:high `
  -ext WixUIExtension `
  -ext WixUtilExtension `
  release.wixobj `
  -o $filename
If ( $LastExitCode -ne 0 ) {
    exit $LastExitCode
}
Write-Output "::set-output name=file::${filename}"