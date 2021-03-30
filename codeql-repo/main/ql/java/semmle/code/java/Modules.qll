/**
 * Provides classes for working with Java modules.
 */

import CompilationUnit

/**
 * A module.
 */
class Module extends @java_module {
  Module() { java_modules(this, _) }

  /**
   * Gets the name of this module.
   */
  string getName() { java_modules(this, result) }

  /**
   * Holds if this module is an `open` module, that is,
   * it grants access _at run time_ to types in all its packages,
   * as if all packages had been exported.
   */
  predicate isOpen() { java_isOpen(this) }

  /**
   * Gets a directive of this module.
   */
  Directive getADirective() { java_directives(this, result) }

  /**
   * Gets a compilation unit associated with this module.
   */
  CompilationUnit getACompilationUnit() { java_cumodule(result, this) }

  /** Gets a textual representation of this module. */
  string toString() { java_modules(this, result) }
}

/**
 * A directive in a module declaration.
 */
abstract class Directive extends @java_directive {
  /** Gets a textual representation of this directive. */
  abstract string toString();
}

/**
 * A `requires` directive in a module declaration.
 */
class RequiresDirective extends Directive, @java_requires {
  RequiresDirective() { java_requires(this, _) }

  /**
   * Holds if this `requires` directive is `transitive`,
   * that is, any module that depends on this module
   * has an implicitly declared dependency on the
   * module specified in this `requires` directive.
   */
  predicate isTransitive() { java_isTransitive(this) }

  /**
   * Holds if this `requires` directive is `static`,
   * that is, the dependence specified by this `requires`
   * directive is only mandatory at compile time but
   * optional at run time.
   */
  predicate isStatic() { java_isStatic(this) }

  /**
   * Gets the module on which this module depends.
   */
  Module getTargetModule() { java_requires(this, result) }

  override string toString() {
    exists(string transitive, string static |
      (if isTransitive() then transitive = "transitive " else transitive = "") and
      (if isStatic() then static = "static " else static = "")
    |
      result = "requires " + transitive + static + getTargetModule() + ";"
    )
  }
}

/**
 * An `exports` directive in a module declaration.
 */
class ExportsDirective extends Directive, @java_exports {
  ExportsDirective() { java_exports(this, _) }

  /**
   * Gets the package exported by this `exports` directive.
   */
  Package getExportedPackage() { java_exports(this, result) }

  /**
   * Holds if this `exports` directive is qualified, that is,
   * it contains a `to` clause.
   *
   * For qualified `exports` directives, exported types and members
   * are accessible only to code in the specified modules.
   * For unqualified `exports` directives, they are accessible
   * to code in any module.
   */
  predicate isQualified() { java_exportsTo(this, _) }

  /**
   * Gets a module specified in the `to` clause of this
   * `exports` directive, if any.
   */
  Module getATargetModule() { java_exportsTo(this, result) }

  override string toString() {
    exists(string toClause |
      if isQualified()
      then toClause = (" to " + concat(getATargetModule().getName(), ", "))
      else toClause = ""
    |
      result = "exports " + getExportedPackage() + toClause + ";"
    )
  }
}

/**
 * An `opens` directive in a module declaration.
 */
class OpensDirective extends Directive, @java_opens {
  OpensDirective() { java_opens(this, _) }

  /**
   * Gets the package opened by this `opens` directive.
   */
  Package getOpenedPackage() { java_opens(this, result) }

  /**
   * Holds if this `opens` directive is qualified, that is,
   * it contains a `to` clause.
   *
   * For qualified `opens` directives, opened types and members
   * are accessible only to code in the specified modules.
   * For unqualified `opens` directives, they are accessible
   * to code in any module.
   */
  predicate isQualified() { java_opensTo(this, _) }

  /**
   * Gets a module specified in the `to` clause of this
   * `exports` directive, if any.
   */
  Module getATargetModule() { java_opensTo(this, result) }

  override string toString() {
    exists(string toClause |
      if isQualified()
      then toClause = (" to " + concat(getATargetModule().getName(), ", "))
      else toClause = ""
    |
      result = "opens " + getOpenedPackage() + toClause + ";"
    )
  }
}

/**
 * A `uses` directive in a module declaration.
 */
class UsesDirective extends Directive, @java_uses {
  UsesDirective() { java_uses(this, _) }

  /**
   * Gets the qualified name of the service interface specified in this `uses` directive.
   */
  string getServiceInterfaceName() { java_uses(this, result) }

  override string toString() { result = "uses " + getServiceInterfaceName() + ";" }
}

/**
 * A `provides` directive in a module declaration.
 */
class ProvidesDirective extends Directive, @java_provides {
  ProvidesDirective() { java_provides(this, _) }

  /**
   * Gets the qualified name of the service interface specified in this `provides` directive.
   */
  string getServiceInterfaceName() { java_provides(this, result) }

  /**
   * Gets the qualified name of a service implementation specified in this `provides` directive.
   */
  string getServiceImplementationName() { java_providesWith(this, result) }

  override string toString() {
    result =
      "provides " + getServiceInterfaceName() + " with " +
        concat(getServiceImplementationName(), ", ") + ";"
  }
}
