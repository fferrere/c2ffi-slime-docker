# C2FFI-Slime-Docker

Dockerfile to build docker image with c2ffi and cl-autowrap for slime-docker.

See :
- <https://github.com/rpav/c2ffi>
- <https://github.com/cl-docker-images/slime-docker>


## Build docker image
```
git clone https://github.com//c2ffi-slime-docker
cd c2ffi-slime-docker
docker build . -t cl-devel-c2ffi
```

## Configure emacs
Assuming :
- you have created cl-devel directory to persist configuration changes and fasl caches
- you have unpacked the default config
- your lisp projects are in the common-lisp directory in your homedir.
- your C sources files are in the src directory in your homedir.

Add the following lines into your emacs init.el file.

```
;; Slime Docker
(require 'use-package)
(use-package slime-docker
             :custom
             (slime-docker-program "sbcl")
             (slime-docker-image-name "cl-devel-c2ffi")
             (slime-docker-mounts `(((,(expand-file-name "~/cl-devel/") . "/home/cl/"))
                                    ((,(expand-file-name "~/src/") . "/home/cl/src"))
                                    ((,(expand-file-name "~/common-lisp/") . "/home/cl/common-lisp/"))))
```

## Usage
- Start emacs
- Launch docker image : M-x slime-docker
- Use cl-autowrap to generate spec files 

## Example
Generate spec files for libsgutils <https://sg.danny.cz/sg/sg3_utils.html>

- Create directories for the project
```
mkdir ~/common-lisp/sgutils
mkdir ~/common-lisp/sgutils/spec
```

- Create an include file /home/cl/common-lisp/sgutils/spec/libsgutils.h :
```
#include "/home/cl/src/sg3_utils-1.47/include/sg_lib.h"
#include "/home/cl/src/sg3_utils-1.47/include/sg_pt.h"
#include "/home/cl/src/sg3_utils-1.47/include/sg_cmds_basic.h"
```

- Generate spec files from REPL
```

(autowrap:c-include "/home/cl/common-lisp/sgutils/spec/libsgutils.h"
                    :spec-path #P"/home/cl/common-lisp/sgutils/spec/"
                    :exclude-definitions ("remove"))
```

## Author

* Frédéric FERRERE (frederic.ferrere@gmail.com)

## Licence

Apache-2.0 (https://www.apache.org/licenses/LICENSE-2.0)


