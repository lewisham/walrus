echo off
echo ��ǰĿ¼ %cd%
::������ԴĿ¼
set ResourceDir=%cd%\assets
::���ù��ÿ��Ŀ¼
set FrameDir=%cd%\bin

call %FrameDir%/RunFrame.bat %ResourceDir% %FrameDir% -position 100,100  -console enable


