/**
 * Provides classes for modeling user-defined types such as classes, typedefs
 * and enums.
 */

import semmle.code.cpp.Declaration
import semmle.code.cpp.Type
import semmle.code.cpp.Function
private import semmle.code.cpp.internal.ResolveClass

/**
 * A C/C++ user-defined type. Examples include `class`, `struct`, `union`,
 * `enum` and `typedef` types.
 * ```
 * enum e1 { val1, val2 } b;
 * enum class e2: short { val3, val4 } c;
 * typedef int my_int;
 * class C { int a, b; };
 * ```
 */
class UserType extends Type, Declaration, NameQualifyingElement, AccessHolder, @cpp_usertype {
  /**
   * Gets the name of this type.
   */
  override string getName() { cpp_usertypes(underlyingElement(this), result, _) }

  override string getAPrimaryQlClass() { result = "UserType" }

  /**
   * Gets the simple name of this type, without any template parameters.  For example
   * if the name of the type is `"myType<int>"`, the simple name is just `"myType"`.
   */
  string getSimpleName() { result = getName().regexpReplaceAll("<.*", "") }

  override predicate hasName(string name) { cpp_usertypes(underlyingElement(this), name, _) }

  /** Holds if this type is anonymous. */
  predicate isAnonymous() { getName().matches("(unnamed%") }

  override predicate hasSpecifier(string s) { Type.super.hasSpecifier(s) }

  override Specifier getASpecifier() { result = Type.super.getASpecifier() }

  override Location getLocation() {
    if hasDefinition()
    then result = this.getDefinitionLocation()
    else result = this.getADeclarationLocation()
  }

  override TypeDeclarationEntry getADeclarationEntry() {
    if cpp_type_decls(_, underlyingElement(this), _)
    then cpp_type_decls(unresolveElement(result), underlyingElement(this), _)
    else exists(Class t | this.(Class).isConstructedFrom(t) and result = t.getADeclarationEntry())
  }

  override Location getADeclarationLocation() { result = getADeclarationEntry().getLocation() }

  override TypeDeclarationEntry getDefinition() {
    result = getADeclarationEntry() and
    result.isDefinition()
  }

  override Location getDefinitionLocation() {
    if exists(getDefinition())
    then result = getDefinition().getLocation()
    else
      exists(Class t |
        this.(Class).isConstructedFrom(t) and result = t.getDefinition().getLocation()
      )
  }

  /**
   * Gets the function that directly encloses this type (if any).
   */
  Function getEnclosingFunction() {
    cpp_enclosingfunction(underlyingElement(this), unresolveElement(result))
  }

  /**
   * Holds if this is a local type (that is, a type that has a directly-enclosing
   * function).
   */
  predicate isLocal() { exists(getEnclosingFunction()) }

  /*
   * Dummy implementations of inherited methods. This class must not be
   * made abstract, because it is important that it captures the @cpp_usertype
   * type exactly - but this is not apparent from its subclasses
   */

  /**
   * Gets a child declaration within this user-defined type.
   */
  Declaration getADeclaration() { none() }

  override string explain() { result = this.getName() }

  // further overridden in LocalClass
  override AccessHolder getEnclosingAccessHolder() { result = this.getDeclaringType() }
}

/**
 * A particular definition or forward declaration of a C/C++ user-defined type.
 * ```
 * class C;
 * typedef int ti;
 * ```
 */
class TypeDeclarationEntry extends DeclarationEntry, @cpp_type_decl {
  override UserType getDeclaration() { result = getType() }

  override string getName() { result = getType().getName() }

  override string getAPrimaryQlClass() { result = "TypeDeclarationEntry" }

  /**
   * The type which is being declared or defined.
   */
  override Type getType() { cpp_type_decls(underlyingElement(this), unresolveElement(result), _) }

  override Location getLocation() { cpp_type_decls(underlyingElement(this), _, result) }

  override predicate isDefinition() { cpp_type_def(underlyingElement(this)) }

  override string getASpecifier() { none() }

  /**
   * A top level type declaration entry is not declared within a function, function declaration,
   * class or typedef.
   */
  predicate isTopLevel() { cpp_type_decl_top(underlyingElement(this)) }
}
