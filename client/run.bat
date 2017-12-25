echo off
echo 当前目录 %cd%
::设置资源目录
set ResourceDir=%cd%\assets
::设置公用框架目录
set FrameDir=%cd%\bin

call %FrameDir%/RunFrame.bat %ResourceDir% %FrameDir% -position 100,100  -console enable


