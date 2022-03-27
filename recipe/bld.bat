cd src\cxx
cmake %CMAKE_ARGS% CMakeLists.txt ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
      -DCMAKE_INSTALL_LIBDIR="Library/lib" ^
      -DCMAKE_INSTALL_BINDIR="Library/bin" ^
      -DCMAKE_INSTALL_INCLUDEDIR="Library/include" ^
      -DCMAKE_INSTALL_PREFIX="%PREFIX%" ^
      -DBUILD_SHARED_LIBS=ON ^
      -DBUILD_TESTING=OFF ^
      -DPython3_FIND_STRATEGY=LOCATION ^
      -DPython3_ROOT_DIR="%PREFIX%" ^
      -DLZMA_LIBRARY="%LIBRARY_PREFIX%/lib/liblzma.lib" ^
      -DCMAKE_CXX_FLAGS="-I%LIBRARY_PREFIX%/include" ^
      -G "NMake Makefiles"
if errorlevel 1 exit 1

cmake --build . --target install --config Release
if errorlevel 1 exit 1

cd ..\..
"%PYTHON%" -m pip install --no-deps --ignore-installed .
if errorlevel 1 exit 1

mkdir "%PREFIX%\etc\conda\activate.d"
copy "%RECIPE_DIR%\activate.bat" "%PREFIX%\etc\conda\activate.d\%PKG_NAME%_activate.bat"

mkdir "%PREFIX%\etc\conda\deactivate.d"
copy "%RECIPE_DIR%\deactivate.bat" "%PREFIX%\etc\conda\deactivate.d\%PKG_NAME%_deactivate.bat"
