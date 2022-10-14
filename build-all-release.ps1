$7zip = "C:\Program Files\7-Zip\7z.exe"

New-Item -Type Directory .\builds\
New-Item -Type Directory .\builds\crossplatform\

###
## Cross platform (no bundled runtime)
###

dotnet publish --self-contained false --configuration Release

###
## Not self contained (no bundled runtime)
###

# Windows
dotnet publish -r win-x64 --self-contained false --configuration Release
dotnet publish -r win-x86 --self-contained false --configuration Release
dotnet publish -r win-arm --self-contained false --configuration Release
dotnet publish -r win-arm64 --self-contained false --configuration Release

# Linux
dotnet publish -r linux-x64 --self-contained false --configuration Release
dotnet publish -r linux-arm --self-contained false --configuration Release
dotnet publish -r linux-arm64 --self-contained false --configuration Release

# Mac
dotnet publish -r osx-x64 --self-contained false --configuration Release
dotnet publish -r osx.11.0-arm64 --self-contained false --configuration Release

$platforms = @("win-x64", "win-x86", "win-arm", "win-arm64", "linux-arm", "linux-arm64", "linux-arm", "osx-x64", "osx.11.0-arm64")

## Make a zip archive of each build using 7zip
foreach ($platform in $platforms) {
    & $7zip a -tzip .\builds\$platform.zip .\bin\Release\net6.0\$platform\publish\
}

## Copy cross platform build and make a zip archive of it using 7zip
Get-ChildItem -File .\bin\Release\net6.0\publish\ | ForEach-Object -Process { Copy-Item $_ .\builds\crossplatform\ }
& $7zip a -tzip .\builds\crossplatform.zip .\builds\crossplatform\