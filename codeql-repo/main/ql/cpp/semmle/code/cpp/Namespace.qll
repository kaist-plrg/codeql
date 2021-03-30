/**
 * Provides classes for modeling namespaces, `using` directives and `using` declarations.
 */

import semmle.code.cpp.Element
import semmle.code.cpp.Type
import semmle.code.cpp.metrics.MetricNamespace

/**
 * A C++ namespace.
 *
 * Note that namespaces are somewhat nebulous entities, as they do not in
 * general have a single well-defined location in the source code. The
 * related notion of a `NamespaceDeclarationEntry` is rather more concrete,
 * and should be used when a location is required. For example, the `std::`
 * namespace is particularly nebulous, as parts of it are defined across a
 * wide range of headers. As a more extreme example, the global namespace
 * is never explicitly declared, but might correspond to a large proportion
 * of the source code.
 */
class Namespace extends NameQualifyingElement, @cpp_namespace {
  /**
   * Gets the location of the namespace. Most namespaces do not have a
   * single well-defined source location, so a dummy location is returned,
   * unless the namespace has exactly one declaration entry.
   */
  override Location getLocation() {
    if strictcount(getADeclarationEntry()) = 1
    then result = getADeclarationEntry().getLocation()
    else result instanceof UnknownDefaultLocation
  }

  /** Gets the simple name of this namespace. */
  override string getName() { cpp_namespaces(underlyingElement(this), result) }

  /** Holds if this element is named `name`. */
  predicate hasName(string name) { name = this.getName() }

  /** Holds if this namespace is anonymous. */
  predicate isAnonymous() { hasName("(unnamed namespace)") }

  /** Gets the name of the parent namespace, if it exists. */
  private string getParentName() {
    result = this.getParentNamespace().getName() and
    result != ""
  }

  /** Gets the qualified name of this namespace. For example: `a::b`. */
  string getQualifiedName() {
    if exists(getParentName())
    then result = getParentNamespace().getQualifiedName() + "::" + getName()
    else result = getName()
  }

  /** Gets the parent namespace, if any. */
  Namespace getParentNamespace() {
    cpp_namespacembrs(unresolveElement(result), underlyingElement(this))
    or
    not cpp_namespacembrs(_, underlyingElement(this)) and result instanceof GlobalNamespace
  }

  /** Gets a child declaration of this namespace. */
  Declaration getADeclaration() { cpp_namespacembrs(underlyingElement(this), unresolveElement(result)) }

  /** Gets a child namespace of this namespace. */
  Namespace getAChildNamespace() {
    cpp_namespacembrs(underlyingElement(this), unresolveElement(result))
  }

  /** Holds if the namespace is inline. */
  predicate isInline() { cpp_namespace_inline(underlyingElement(this)) }

  /** Holds if this namespace may be from source. */
  override predicate fromSource() { this.getADeclaration().fromSource() }

  /**
   * Holds if this namespace is in a library.
   *
   * DEPRECATED: never holds.
   */
  deprecated override predicate fromLibrary() { not this.fromSource() }

  /** Gets the metric namespace. */
  MetricNamespace getMetrics() { result = this }

  /** Gets a version of the `QualifiedName` that is more suitable for display purposes. */
  string getFriendlyName() { result = this.getQualifiedName() }

  final override string toString() { result = getFriendlyName() }

  /** Gets a declaration of (part of) this namespace. */
  NamespaceDeclarationEntry getADeclarationEntry() { result.getNamespace() = this }

  /** Gets a file which declares (part of) this namespace. */
  File getAFile() { result = this.getADeclarationEntry().getLocation().getFile() }
}

/**
 * A declaration of (part of) a C++ namespace.
 *
 * This corresponds to a single `namespace N { ... }` occurrence in the
 * source code.
 */
class NamespaceDeclarationEntry extends Locatable, @cpp_namespace_decl {
  /**
   * Get the namespace that this declaration entry corresponds to.  There
   * is a one-to-many relationship between `Namespace` and
   * `NamespaceDeclarationEntry`.
   */
  Namespace getNamespace() {
    cpp_namespace_decls(underlyingElement(this), unresolveElement(result), _, _)
  }

  override string toString() { result = this.getNamespace().getFriendlyName() }

  /**
   * Gets the location of the token preceding the namespace declaration
   * entry's body.
   *
   * For named declarations, such as "namespace MyStuff { ... }", this will
   * give the "MyStuff" token.
   *
   * For anonymous declarations, such as "namespace { ... }", this will
   * give the "namespace" token.
   */
  override Location getLocation() { cpp_namespace_decls(underlyingElement(this), _, result, _) }

  /**
   * Gets the location of the namespace declaration entry's body. For
   * example: the "{ ... }" in "namespace N { ... }".
   */
  Location getBodyLocation() { cpp_namespace_decls(underlyingElement(this), _, _, result) }

  override string getAPrimaryQlClass() { result = "NamespaceDeclarationEntry" }
}

/**
 * A C++ `using` directive or `using` declaration.
 */
class UsingEntry extends Locatable, @cpp_using {
  override Location getLocation() { cpp_usings(underlyingElement(this), _, result) }
}

/**
 * A C++ `using` declaration. For example:
 *
 *   `using std::string;`
 */
class UsingDeclarationEntry extends UsingEntry {
  UsingDeclarationEntry() {
    not exists(Namespace n | cpp_usings(underlyingElement(this), unresolveElement(n), _))
  }

  /**
   * Gets the declaration that is referenced by this using declaration. For
   * example, `std::string` in `using std::string`.
   */
  Declaration getDeclaration() { cpp_usings(underlyingElement(this), unresolveElement(result), _) }

  override string toString() { result = "using " + this.getDeclaration().getDescription() }
}

/**
 * A C++ `using` directive. For example:
 *
 *   `using namespace std;`
 */
class UsingDirectiveEntry extends UsingEntry {
  UsingDirectiveEntry() {
    exists(Namespace n | cpp_usings(underlyingElement(this), unresolveElement(n), _))
  }

  /**
   * Gets the namespace that is referenced by this using directive. For
   * example, `std` in `using namespace std`.
   */
  Namespace getNamespace() { cpp_usings(underlyingElement(this), unresolveElement(result), _) }

  override string toString() { result = "using namespace " + this.getNamespace().getFriendlyName() }
}

/**
 * Holds if `g` is an instance of `GlobalNamespace`. This predicate
 * is used suppress a warning in `GlobalNamespace.getADeclaration()`
 * by providing a fake use of `this`.
 */
private predicate suppressWarningForUnused(GlobalNamespace g) { any() }

/**
 * The C/C++ global namespace.
 */
class GlobalNamespace extends Namespace {
  GlobalNamespace() { this.hasName("") }

  override Declaration getADeclaration() {
    suppressWarningForUnused(this) and
    result.isTopLevel() and
    not cpp_namespacembrs(_, unresolveElement(result))
  }

  /** Gets a child namespace of the global namespace. */
  override Namespace getAChildNamespace() {
    suppressWarningForUnused(this) and
    not cpp_namespacembrs(unresolveElement(result), _)
  }

  override Namespace getParentNamespace() { none() }

  /**
   * DEPRECATED: use `getName()`.
   */
  deprecated string getFullName() { result = this.getName() }

  override string getFriendlyName() { result = "(global namespace)" }
}

/**
 * The C++ `std::` namespace.
 */
class StdNamespace extends Namespace {
  StdNamespace() { this.hasName("std") and this.getParentNamespace() instanceof GlobalNamespace }
}
