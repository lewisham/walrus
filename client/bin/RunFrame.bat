echo off
::传入的第一个参数是资源目录
set ResourceDir=%1
::设置公用框架目录
set FrameDir=%2
::取得盘符
set FrameDisk=%~d0

::取得exe目录
set ExeDir=%~dp0
::取得exe盘符
set ExeDisk=%~d0

echo 资源目录 %ResourceDir%
echo 共用exe目录 %ExeDir%

%ExeDisk%
cd %ResourceDir%

::最后开启exe
start %ExeDir%/dragon.exe

