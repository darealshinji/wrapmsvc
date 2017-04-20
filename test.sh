#!/bin/sh
set -e
set -x

HOST="HostX64"
TARGET="x64"

MSVC_TOOLS="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.10.25017"
WINKITS_INC="C:\Program Files (x86)\Windows Kits\10\Include\10.0.15063.0"
WINKITS_LIB="C:\Program Files (x86)\Windows Kits\10\Lib\10.0.15063.0"

export CL_CMD="$MSVC_TOOLS\bin\\$HOST\\$TARGET\cl.exe"
export LINK_CMD="$MSVC_TOOLS\bin\\$HOST\\$TARGET\link.exe"

cat <<EOF> test.cpp
#include <iostream>
int main(){ std::wcout << "SUCCESS" << std::endl; return 0; }
EOF
cat <<EOF> test.c
#include <stdio.h>
#include <wchar.h>
wchar_t *wch = L"SUCCESS";
int main(){ fprintf(stdout, "%ls\n", wch); return 0; }
EOF

for file in "test.c" "test.cpp" ; do
./cl.exe -Ox -EHsc $file \
    -I "$MSVC_TOOLS\include" \
    -I "$WINKITS_INC\shared" \
    -I "$WINKITS_INC\ucrt" \
    -I "$WINKITS_INC\um" \
  -link \
    -out:"${file}.exe" \
    -libpath:"$WINKITS_LIB\ucrt\\$TARGET" \
    -libpath:"$WINKITS_LIB\um\\$TARGET" \
    -libpath:"$MSVC_TOOLS\lib\\$TARGET"
done

echo "=== Testing test.c.exe ==="
./test.c.exe
echo "=== Testing test.cpp.exe ==="
./test.cpp.exe
rm -f test.c test.cpp test.obj test.*.exe

