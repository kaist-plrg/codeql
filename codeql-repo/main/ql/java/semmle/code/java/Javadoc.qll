/**
 * Provides classes and predicates for working with Javadoc documentation.
 */

import semmle.code.Location
import Element

/** A Javadoc parent is an element whose child can be some Javadoc documentation. */
class JavadocParent extends @java_javadocParent, Top {
  /** Gets a documentation element attached to this parent. */
  JavadocElement getAChild() { result.getParent() = this }

  /** Gets the child documentation element at the specified (zero-based) position. */
  JavadocElement getChild(int index) { result = this.getAChild() and result.getIndex() = index }

  /** Gets the number of documentation elements attached to this parent. */
  int getNumChild() { result = count(getAChild()) }

  /** Gets a documentation element with the specified Javadoc tag name. */
  JavadocTag getATag(string name) { result = this.getAChild() and result.getTagName() = name }

  /*abstract*/ override string toString() { result = "Javadoc" }
}

/** A Javadoc comment. */
class Javadoc extends JavadocParent, @java_javadoc {
  /** Gets the number of lines in this Javadoc comment. */
  int getNumberOfLines() { result = this.getLocation().getNumberOfCommentLines() }

  /** Gets the value of the `@java_version` tag, if any. */
  string getVersion() { result = this.getATag("@java_version").getChild(0).toString() }

  /** Gets the value of the `@java_author` tag, if any. */
  string getAuthor() { result = this.getATag("@java_author").getChild(0).toString() }

  override string toString() { result = toStringPrefix() + getChild(0) + toStringPostfix() }

  private string toStringPrefix() {
    if java_isEolComment(this)
    then result = "//"
    else (
      if java_isNormalComment(this) then result = "/* " else result = "/** "
    )
  }

  private string toStringPostfix() {
    if java_isEolComment(this)
    then result = ""
    else (
      if strictcount(getAChild()) = 1 then result = " */" else result = " ... */"
    )
  }

  /** Gets the Java code element that is commented by this piece of Javadoc. */
  Documentable getCommentedElement() { result.getJavadoc() = this }

  override string getAPrimaryQlClass() { result = "Javadoc" }
}

/** A documentable element that can have an attached Javadoc comment. */
class Documentable extends Element, @java_member {
  /** Gets the Javadoc comment attached to this element. */
  Javadoc getJavadoc() { java_hasJavadoc(this, result) and not java_isNormalComment(result) }

  /** Gets the name of the author(s) of this element, if any. */
  string getAuthor() { result = this.getJavadoc().getAuthor() }
}

/** A common super-class for Javadoc elements, which may be either tags or text. */
abstract class JavadocElement extends @java_javadocElement, Top {
  /** Gets the parent of this Javadoc element. */
  JavadocParent getParent() { java_javadocTag(this, _, result, _) or java_javadocText(this, _, result, _) }

  /** Gets the index of this child element relative to its parent. */
  int getIndex() { java_javadocTag(this, _, _, result) or java_javadocText(this, _, _, result) }

  /** Gets a printable representation of this Javadoc element. */
  /*abstract*/ override string toString() { result = "Javadoc element" }

  /** Gets the line of text associated with this Javadoc element. */
  abstract string getText();
}

/** A Javadoc block tag. This does not include inline tags. */
class JavadocTag extends JavadocElement, JavadocParent, @java_javadocTag {
  /** Gets the name of this Javadoc tag. */
  string getTagName() { java_javadocTag(this, result, _, _) }

  /** Gets a printable representation of this Javadoc tag. */
  override string toString() { result = this.getTagName() }

  /** Gets the text associated with this Javadoc tag. */
  override string getText() { result = this.getChild(0).toString() }

  override string getAPrimaryQlClass() { result = "JavadocTag" }
}

/** A Javadoc `@java_param` tag. */
class ParamTag extends JavadocTag {
  ParamTag() { this.getTagName() = "@java_param" }

  /** Gets the name of the parameter. */
  string getParamName() { result = this.getChild(0).toString() }

  /** Gets the documentation for the parameter. */
  override string getText() { result = this.getChild(1).toString() }
}

/** A Javadoc `@java_throws` or `@java_exception` tag. */
class ThrowsTag extends JavadocTag {
  ThrowsTag() { this.getTagName() = "@java_throws" or this.getTagName() = "@java_exception" }

  /** Gets the name of the exception. */
  string getExceptionName() { result = this.getChild(0).toString() }

  /** Gets the documentation for the exception. */
  override string getText() { result = this.getChild(1).toString() }
}

/** A Javadoc `@java_see` tag. */
class SeeTag extends JavadocTag {
  SeeTag() { getTagName() = "@java_see" }

  /** Gets the name of the entity referred to. */
  string getReference() { result = getChild(0).toString() }
}

/** A Javadoc `@java_author` tag. */
class AuthorTag extends JavadocTag {
  AuthorTag() { this.getTagName() = "@java_author" }

  /** Gets the name of the author. */
  string getAuthorName() { result = this.getChild(0).toString() }
}

/** A piece of Javadoc text. */
class JavadocText extends JavadocElement, @java_javadocText {
  /** Gets the Javadoc comment that contains this piece of text. */
  Javadoc getJavadoc() { result.getAChild+() = this }

  /** Gets the text itself. */
  override string getText() { java_javadocText(this, result, _, _) }

  /** Gets a printable representation of this Javadoc element. */
  override string toString() { result = this.getText() }

  override string getAPrimaryQlClass() { result = "JavadocText" }
}
