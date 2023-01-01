FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04
# FROM nvidia/cuda:11.7.0-cudnn8-devel-ubuntu22.04
# FROM nvidia/cuda:11.4.1-devel-ubuntu20.04
# FROM nvidia/cuda:11.6.2-base-ubuntu20.04 

ARG DEBIAN_FRONTEND=noninteractive
ARG OPENCV_VERSION=4.7.0
# ARG OPENCV_VERSION=4.5.4

RUN apt-get update && apt-get upgrade -y &&\
    # Install build tools, build dependencies and python
    apt-get install -y --no-install-recommends \
        neofetch \ 
	    python3-pip \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        yasm \
        nano \
        pkg-config \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libavformat-dev \
        libpq-dev \
        libxine2-dev \
        libglew-dev \
        libtiff5-dev \
        zlib1g-dev \
        libjpeg-dev \
        libavcodec-dev \
        libavformat-dev \
        libavutil-dev \
        libpostproc-dev \
        libswscale-dev \
        libeigen3-dev \
        libtbb-dev \
        libgtk2.0-dev \
        pkg-config \
        ## Python
        python3-dev \
        python3-numpy \
        ## Related to X11 forwarding
        xauth \ 
        bzip2 \
        g++ \
        git \
        graphviz \
        libgl1-mesa-glx \
        libhdf5-dev \
        wget \
        python3-tk  \
        # get rid of some gtk error messages after running python/opencv
        libcanberra-gtk-module \ 
        libcanberra-gtk3-module \
    && rm -rf /var/lib/apt/lists/*

RUN cd /opt/ &&\
    # Download and unzip OpenCV and opencv_contrib and delte zip files
    wget https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip &&\
    unzip $OPENCV_VERSION.zip &&\
    rm $OPENCV_VERSION.zip &&\
    wget https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip &&\
    unzip ${OPENCV_VERSION}.zip &&\
    rm ${OPENCV_VERSION}.zip &&\
    # Create build folder and switch to it
    mkdir /opt/opencv-${OPENCV_VERSION}/build && cd /opt/opencv-${OPENCV_VERSION}/build &&\
    # Cmake configure
    cmake \
        -DOPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-${OPENCV_VERSION}/modules \
        -DWITH_CUDA=ON \
        -DWITH_CUDNN=ON \
        -DWITH_CUBLAS=ON \
        -DWITH_TBB=ON \
        -WITH_GDAL=ON \
        -WITH_FFMPEG=ON \
        -WITH_GTK=ON \
        -DWITH_QT=ON \
        -DWITH_IPP=ON \ 
        -DOPENCV_DNN_CUDA=ON \
        -DENABLE_FAST_MATH=ON \ 
        -DCUDA_FAST_MATH=ON \
        -DCPU_DISPATCH=AVX,AVX2 \
        -DOPENCV_ENABLE_NONFREE=ON \
        -DCUDA_ARCH_BIN=7.5,8.0,8.6 \
        -DCMAKE_BUILD_TYPE=RELEASE \
        -DBUILD_EXAMPLES=ON \
        -DINSTALL_PYTHON_EXAMPLES=ON \
        -DHAVE_opencv_python3=ON \
        -DBUILD_opencv_python3=ON \
        # Install path will be /usr/local/lib (lib is implicit)
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        .. &&\
    # Make
    make -j"$(nproc)" && \
    # Install to /usr/local/lib
    make install && \
    ldconfig 
    # Remove OpenCV sources and build folder (if you want to save disk space)
    # rm -rf /opt/opencv-${OPENCV_VERSION} && rm -rf /opt/opencv_contrib-${OPENCV_VERSION}

    # minimize image size
    RUN (apt-get autoremove -y; \
     apt-get autoclean -y)

    ENV QT_X11_NO_MITSHM=1 