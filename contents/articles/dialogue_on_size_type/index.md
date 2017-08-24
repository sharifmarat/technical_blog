---
title: Dialogues on size_type vs size_t
author: marat
date: 2017-08-24
template: article.jade
comments: true
---

It all began, as usual, with a simple yes or no question on how to loop in C++.
Which led to `size_type` vs `size_t` discussion and ended with a joke and a bit of assembly.

<span class="more"></span>

**M:**  Assuming type of x is known and the code is not inside a template function or class, 1 or 2?
``` c++
// 1
const size_t n = x.size();
for (size_t i = n + 1; ....

// OR

// 2
const auto n = x.size();
for (std::decay<decltype(n)>::type i = n + 1; ....
```

**AL:** Is it a joke?

**M:** No. Why?

**AL:** Then the 1<sup>st</sup>. How can anyone pick the 2<sup>nd</sup>? No templates, more difficult to read.

**M:** More generic?

**AL:** Yeah... Potentially generic, but readability is much worse. But let's ask **AR**, he loves generic code.

**AR:** First of all, you don't care about `x`. You only care about type deduction on `x.size()`. Further in the second option
you don't need `decay`, `auto` will simply work. So I vote for the third option (if we agree that ranges/iterators are out of the scope):
``` c++
const auto n = x.size();
for (auto i = n + 1; ....
```
But the first option is also fine for every-day code. But not for STL or library code.

**AL:** Type of `x` itself is not necessary to know, but it is good to know that it is not a template.

**AR:** But what does it change?

**AL:** Anyway, does not matter. Your 3<sup>rd</sup> option is the best. But I was also fine with the 1<sup>st</sup> one.

**AR:** Not for STL.

**AL:** Why?

**AR:** Type of `size()` is not `size_t`, but `typename decltype(x)::size_type`.

**AL:** That's what I'm saying, if type of `x` is known then it should not matter.

**AR:** But it does not mean that `size()` returns `size_t`. In standard library it returns `size_type` even if a container is known.
`size_type` is implementation defined. Anyway, these are details.

**AL:** If it's known that `x` is `vector<int>` then `vector<int>::size_type` is equivalent to `size_t`.

**AR:** Nope. `size_type` is implementation defined.

**AL:** Are you saying that `vector<int>::size_type` does not always resolve to `size_t`? The elements of a vector are stored contiguously.
And it is guaranteed that `size_t` can address anything in memory.

**AR:** [Ha!!!111](http://en.cppreference.com/w/cpp/header/vector):
``` c++
template <.....> class vector {
  typedef /*implementation defined*/ size_type;
  size_type size() const;
  //...
```

**AL:** Can it be smaller than `size_t`? It cannot be wider. It must be equivalent to `size_t`. But technically you are right.

**AR:** We have to deal with what standard says. It's a law!

**AL:** I can prove that `vector<int>::size_type` is equivalent to `size_t`. Otherwise it cannot be. But in general it is not known, indeed.
Can you provide a single example where `vector<int>::size_type` is not equivalent to `size_t`.

**AR:** You can probably find a platform where `sizeof(size_type) != sizeof(size_t)`.

**AL:** Can you provide an example of such platform? I think I could show that it is impossible. It's guaranteed that 
`vector<X>::size_type` cannot be smaller than a pointer. And I think it could not be larger than a pointer. Let me think...

**AR:** Standard explicitly states that it is implementation defined. Why would I break it anyway? Just because I cannot find an example?

**AL:** I think I found a mistake in my "proof". `&x[n]` does not have to be a pointer. It's just `vector<T>::reference_type`.

**AR:** It's more safer just to listen to what the standard says to avoid potential UB.

**AL:** But if you prove that `size_type` is equivalent to `size_t` then you could just start using it.

**AR:** Until the next standard.

**M:** Google says that it's quite easy to make an allocator with `sizeof(size_type) > sizeof(size_t)`. It will map container's memory to bigger than system's memory storage.

**AR:** Yes, you could make such allocator. But what would be `vector<T, A>::reference_type` then?

**AL:** Any type with `operator.`? Which we could not overload yet. Anyway, we all agree that **AR**'s option `auto i = n + 1` was the best.

**M:** What if `0` is used instead of `n + 1`? Should it be like this `auto i = decltype(x.size())0;` then?

**AR:** Better would be `auto i = decltype(x.size())();`.

**AL:** `auto i = (n - n);`

That's C++, you cannot just write `auto i = 0`. Instead you should do either `auto i = decltype(x.size())();` or `auto i = x.size() - x.size();`.
Although the latter looks funny, it is identical to the former (based on optimized assembly from gcc-4.9).
