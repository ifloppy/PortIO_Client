rm -rf ./build
lazbuild --bm=Release_Windows64 PortIO_Client.lpr
lazbuild --bm=Release_Linux64 PortIO_Client.lpr
mkdir build
7z a -mx9 ./build/PortIO_Client_Windows64.7z ./target/PortIO_Client.exe ./required/windows_amd64/*
7z a -mx9 ./build/PortIO_Client_Linux64.7z ./target/PortIO_Client ./required/linux_amd64/*