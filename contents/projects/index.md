---
title: Projects
author: marat
date: 2017-03-19
template: page.jade
comments: false
---

### Percolation simulation
[Simulation of percolation theory](/projects/percolation/) to find if there is a path
connecting left side of the grid to the right side via open pixels and to estimate
percolation threshold.
<img src="/projects/percolation_example.png" alt="Drawing" style="width: 300px; display: block; margin: 0 auto;" />

---

### Animated svg viewer
Simple [svg viewer](/projects/svgviewer/) which can load multiple svgs and animate them one after another

---

### C-bindings generator from Fortran
It was written to automate generation of C bindings for Fortran,
source code can be found [here](https://github.com/sharifmarat/fortran_to_c_headers).

``` Fortran
! Example of input Fortran90 code:
module SomeModule
  use iso_c_binding
  implicit none
  real*8, bind(c), parameter  :: dbl1 = 1.0d0
  type(c_ptr), bind(c, name="ptr1") :: ptr1
contains
  integer function SimpleFunction1() bind(c, name="SimpleFunction1")
    integer :: a
    integer b
    integer :: c
    !...
  end function SimpleFunction1
end module SomeModule
```

``` C++
// Generated C-bindings:
#ifdef __cplusplus
extern "C" {
#endif

typedef void* some_ptr_t;
typedef double val_t;
double dbl1;
void* ptr1;
int SimpleFunction1();
#ifdef __cplusplus
}
#endif
```

