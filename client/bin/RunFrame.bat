echo off
::����ĵ�һ����������ԴĿ¼
set ResourceDir=%1
::���ù��ÿ��Ŀ¼
set FrameDir=%2
::ȡ���̷�
set FrameDisk=%~d0

::ȡ��exeĿ¼
set ExeDir=%~dp0
::ȡ��exe�̷�
set ExeDisk=%~d0

echo ��ԴĿ¼ %ResourceDir%
echo ����exeĿ¼ %ExeDir%

%ExeDisk%
cd %ResourceDir%

::�����exe
start %ExeDir%/dragon.exe

