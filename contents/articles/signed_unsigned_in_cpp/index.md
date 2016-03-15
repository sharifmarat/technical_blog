---
title: Why you should avoid unsigned types in C++
author: marat
date: 2015-03-15
template: article.jade
comments: true
---

C++ offers signed and unsigned integer types.
This article explains why you should avoid using unsigned types in C++.

<span class="more"></span>

### Introduction

Arithmetic operations on integer types cause implicit type conversions if operands have different types.
From C++ standard:

> If the operand that has unsigned integer type has rank greater than or equal to the rank of the type of the other operand,
> the operand with signed integer type shall be converted to the type of the operand with unsigned integer type.

> If the type of the operand with signed integer type can represent all of the values of the type of the operand
> with unsigned integer type, the operand with unsigned integer type shall be converted 
> to the type of the operand with signed integer type. 

> Otherwise, both operands shall be converted to the unsigned integer type corresponding 
> to the type of the operand with signed integer type.

### Example

If you do not understand it fully it could cause big issues in the code.
Imagine the following function:
``` C++
//! \return mean of some variable which is always positive.
//! The result is always positive.
int32_t GetMean();
```

Then a new developer comes and thinks: "Why does this function return signed integer if comments says that it cannot be negative?"
And he changes this function to return unsigned integer:
``` C++
uint32_t GetMean();
```

Looks like it is not a big deal. But then the program starts producing wrong results under certain circumstances.
It even crashes sometimes.

Why did it stop working properly? To answer this question, imagine the code which uses `GetMean` function:
``` C++
double weightedDeviationFromMean = (GetMean() - 4) / 6.0;
```

Let's say that `GetMean()` returns 1. Then we can evaluate how would the result of `weightedDeviationFromMean` change
``` C++
int32_t GetMean() { return 1; }
double weightedDeviationFromMean = (GetMean() - 4) / 6.0;
// weightedDeviationFromMean = -0.5
```

``` C++
uint32_t GetMean() { return 1; }
double weightedDeviationFromMean = (GetMean() - 4) / 6.0;
// weightedDeviationFromMean = 7.15828e+08
```

As you can see the result is significantly different (and wrong)
after changing the return type of `GetMean` function to unsigned integer.
The reason is that the compiler implicitly converts 4 to unsigned integer because of `GetMean` return type.
And it expands expression inside parenthesis to `1u - 4u` which is equal to `4294967293u` due to integer underflow.

Such small change caused lots of problems in different part of the code.
And if you have many developers submitting changes to the code base it would not be easy to track this bug.

Better not to use unsigned integers in C++ to avoid such troubles. 
Or at least try to think of possible consequences of unsigned types.

