FROM clfoundation/cl-devel
USER root
RUN sudo apt-get update && sudo apt-get install -y llvm-11 clang-11 libclang-11-dev libclang-cpp11-dev python3-pip
RUN pip3 install --upgrade cmake

# Create dir to mount at runtime
RUN mkdir /home/cl/common-lisp
RUN mkdir /home/cl/src

# Clone c2ffi source from github into the Docker container
RUN cd / && git clone --branch llvm-11.0.0 https://github.com/rpav/c2ffi.git
WORKDIR /c2ffi

# Build c2ffi
RUN cd /c2ffi && \
        rm -rf build && mkdir -p build && cd build && \
        CXX=clang++-11 cmake -DBUILD_CONFIG=Release .. && make

# As a sanity check, make sure the binary we built can be executed
RUN /c2ffi/build/bin/c2ffi --help

# Copy c2ffi binary to "default" binary directory
RUN cp /c2ffi/build/bin/c2ffi /usr/local/bin

RUN su cl -c "sbcl --eval \"(ql:quickload \\\"cl-autowrap\\\")\" --eval \"(quit)\""