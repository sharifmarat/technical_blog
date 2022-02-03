---
Title: Projects
---

## Dockerized email

Managing my own email server with the following setup.
[Read here](/articles/dockerized_email/) for more details.

Source of the docker image is on [GitHub](https://github.com/sharifmarat/docker-email).

## Web 1.0 version of Wordle/Lingo

Web 1.0 (no react and fancy stuff) clone of wordle/lingo supporting 4 languages: 
- English
- Dutch
- Russian
- Tatar

[**Play here**](https://ifnull.org/wordnl/?lang=en) or [**here**](https://sharifmarat.github.io/lingo/?lang=en).

Sources are on [GitHub](https://github.com/sharifmarat/lingo).

Auto solver is part of the game:
- When the field is empty, click 3 times on DEL, followed by 3 clicks on ENTER.
- Or execute solve() in browser console.

## LongWarn
A tiny shell script to fail a job and trigger a notification if a cronjob takes longer than desired.

If a job takes longer than expected, for example a backup job usually takes a few seconds, 
For example a backup job usually runs under 1 minute.
If you want to get notified when this job runs longer, just add it to crontab:

```shell
MAILTO=monitoring@example.com
11 11 * * * longwarn 60 backup.sh
```

How to install:
```shell
wget https://raw.githubusercontent.com/sharifmarat/longwarn/master/longwarn -O /usr/local/bin/longwarn
```

[GitHub for more details](https://github.com/sharifmarat/longwarn).

---

## Flickr roulette
See a random (not completely random) photo on the [Flickr roulette](/projects/flickr_roulette/).

[For more details](/articles/flickr_roulette/).

---

## Site percolation
[Simulation of percolation theory](/projects/percolation/) to find if there is a path
connecting left side of the grid to the right side via open pixels and to estimate
percolation threshold (site percolation).

<img src="/projects/percolation_example.png" alt="Drawing" style="width: 300px; display: block; margin: 0 auto;" />

[For more details](/articles/percolation/).

---

## Animated svg viewer
Simple [svg viewer](/projects/svgviewer/) which can load multiple svgs and animate them one after another

---

## C-bindings generator from Fortran
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

