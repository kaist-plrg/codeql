import semmle.code.cpp.Type

/** For upgraded databases without mangled name info. */
pragma[noinline]
private string getTopLevelClassName(@cpp_usertype c) {
  not cpp_mangled_name(_, _) and
  isClass(c) and
  cpp_usertypes(c, result, _) and
  not cpp_namespacembrs(_, c) and // not in a namespace
  not cpp_member(_, _, c) and // not in some structure
  not cpp_class_instantiation(c, _) // not a template instantiation
}

/**
 * For upgraded databases without mangled name info.
 * Holds if `d` is a unique complete class named `name`.
 */
pragma[noinline]
private predicate existsCompleteWithName(string name, @cpp_usertype d) {
  not cpp_mangled_name(_, _) and
  cpp_is_complete(d) and
  name = getTopLevelClassName(d) and
  onlyOneCompleteClassExistsWithName(name)
}

/** For upgraded databases without mangled name info. */
pragma[noinline]
private predicate onlyOneCompleteClassExistsWithName(string name) {
  not cpp_mangled_name(_, _) and
  strictcount(@cpp_usertype c | cpp_is_complete(c) and getTopLevelClassName(c) = name) = 1
}

/**
 * For upgraded databases without mangled name info.
 * Holds if `c` is an incomplete class named `name`.
 */
pragma[noinline]
private predicate existsIncompleteWithName(string name, @cpp_usertype c) {
  not cpp_mangled_name(_, _) and
  not cpp_is_complete(c) and
  name = getTopLevelClassName(c)
}

/**
 * For upgraded databases without mangled name info.
 * Holds if `c` is an incomplete class, and there exists a unique complete class `d`
 * with the same name.
 */
private predicate oldHasCompleteTwin(@cpp_usertype c, @cpp_usertype d) {
  not cpp_mangled_name(_, _) and
  exists(string name |
    existsIncompleteWithName(name, c) and
    existsCompleteWithName(name, d)
  )
}

pragma[noinline]
private @cpp_mangledname getClassMangledName(@cpp_usertype c) {
  isClass(c) and
  cpp_mangled_name(c, result)
}

/** Holds if `d` is a unique complete class named `name`. */
pragma[noinline]
private predicate existsCompleteWithMangledName(@cpp_mangledname name, @cpp_usertype d) {
  cpp_is_complete(d) and
  name = getClassMangledName(d) and
  onlyOneCompleteClassExistsWithMangledName(name)
}

pragma[noinline]
private predicate onlyOneCompleteClassExistsWithMangledName(@cpp_mangledname name) {
  strictcount(@cpp_usertype c | cpp_is_complete(c) and getClassMangledName(c) = name) = 1
}

/** Holds if `c` is an incomplete class named `name`. */
pragma[noinline]
private predicate existsIncompleteWithMangledName(@cpp_mangledname name, @cpp_usertype c) {
  not cpp_is_complete(c) and
  name = getClassMangledName(c)
}

/**
 * Holds if `c` is an incomplete class, and there exists a unique complete class `d`
 * with the same name.
 */
private predicate hasCompleteTwin(@cpp_usertype c, @cpp_usertype d) {
  exists(@cpp_mangledname name |
    existsIncompleteWithMangledName(name, c) and
    existsCompleteWithMangledName(name, d)
  )
}

import Cached

cached
private module Cached {
  /**
   * If `c` is incomplete, and there exists a unique complete class with the same name,
   * then the result is that complete class. Otherwise, the result is `c`.
   */
  cached
  @cpp_usertype resolveClass(@cpp_usertype c) {
    hasCompleteTwin(c, result)
    or
    oldHasCompleteTwin(c, result)
    or
    not hasCompleteTwin(c, _) and
    not oldHasCompleteTwin(c, _) and
    result = c
  }

  /**
   * Holds if `t` is a struct, class, union, or template.
   */
  cached
  predicate isClass(@cpp_usertype t) {
    (
      cpp_usertypes(t, _, 1) or
      cpp_usertypes(t, _, 2) or
      cpp_usertypes(t, _, 3) or
      cpp_usertypes(t, _, 6) or
      cpp_usertypes(t, _, 10) or
      cpp_usertypes(t, _, 11) or
      cpp_usertypes(t, _, 12)
    )
  }

  cached
  predicate isType(@cpp_type t) {
    not isClass(t)
    or
    t = resolveClass(_)
  }
}
