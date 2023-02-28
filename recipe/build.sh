#!/bin/sh

# ParaView requires native binaries at build time, point to the build
# system to the binaries in the native ParaView package
if test "${CONDA_BUILD_CROSS_COMPILATION}" == "1"; then
    PV_TARGETS_FILE=$(find ${PREFIX}/lib/cmake -name ParaView-targets.cmake)
    cat ${RECIPE_DIR}/NativeParaViewBuildBinaries.cmake.in >> ${PV_TARGETS_FILE}
fi

cd src/cxx
cmake ${CMAKE_ARGS} CMakeLists.txt \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_SHARED_LIBS=ON \
      -DBUILD_TESTING=OFF \
      -DPython3_EXECUTABLE="$PYTHON" \
      -DOPENGL_opengl_LIBRARY=${BUILD_PREFIX}/${HOST}/sysroot/usr/lib64/libGL.so
cmake --build . --target install --config Release

cd ../..
${PYTHON} -m pip install --no-deps --ignore-installed .

# Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
# This will allow them to be run on environment activation.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done
