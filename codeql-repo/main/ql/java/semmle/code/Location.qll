/**
 * Provides classes and predicates for working with locations.
 *
 * Locations represent parts of files and are used to map elements to their source location.
 */

import FileSystem
import semmle.code.java.Element
private import semmle.code.SMAP

/** Holds if element `e` has name `name`. */
predicate hasName(Element e, string name) {
  java_classes(e, name, _, _)
  or
  java_interfaces(e, name, _, _)
  or
  java_primitives(e, name)
  or
  java_constrs(e, name, _, _, _, _)
  or
  java_methods(e, name, _, _, _, _)
  or
  java_fields(e, name, _, _, _)
  or
  java_packages(e, name)
  or
  java_files(e, _, name, _, _)
  or
  java_paramName(e, name)
  or
  exists(int pos |
    java_params(e, _, pos, _, _) and
    not java_paramName(e, _) and
    name = "p" + pos
  )
  or
  java_localvars(e, name, _, _)
  or
  java_typeVars(e, name, _, _, _)
  or
  java_wildcards(e, name, _)
  or
  java_arrays(e, name, _, _, _)
  or
  java_modifiers(e, name)
}

/**
 * Top is the root of the QL type hierarchy; it defines some default
 * methods for obtaining locations and a standard `toString()` method.
 */
class Top extends @java_top {
  /** Gets the source location for this element. */
  Location getLocation() { fixedHasLocation(this, result, _) }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    hasLocationInfoAux(filepath, startline, startcolumn, endline, endcolumn)
    or
    exists(string outFilepath, int outStartline, int outEndline |
      hasLocationInfoAux(outFilepath, outStartline, _, outEndline, _) and
      hasSmapLocationInfo(filepath, startline, startcolumn, endline, endcolumn, outFilepath,
        outStartline, outEndline)
    )
  }

  private predicate hasLocationInfoAux(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(File f, Location l | fixedHasLocation(this, l, f) |
      java_locations_default(l, f, startline, startcolumn, endline, endcolumn) and
      filepath = f.getAbsolutePath()
    )
  }

  /** Gets the file associated with this element. */
  File getFile() { fixedHasLocation(this, _, result) }

  /**
   * Gets the total number of lines that this element ranges over,
   * including lines of code, comment and whitespace-only lines.
   */
  int getTotalNumberOfLines() { java_numlines(this, result, _, _) }

  /** Gets the number of lines of code that this element ranges over. */
  int getNumberOfLinesOfCode() { java_numlines(this, _, result, _) }

  /** Gets the number of comment lines that this element ranges over. */
  int getNumberOfCommentLines() { java_numlines(this, _, _, result) }

  /** Gets a textual representation of this element. */
  cached
  string toString() { hasName(this, result) }

  /**
   * Gets the name of a primary CodeQL class to which this element belongs.
   *
   * For most elements, this is simply the most precise syntactic category to
   * which they belong; for example, `AddExpr` is a primary class, but
   * `BinaryExpr` is not.
   *
   * This predicate always has a result. If no primary class can be
   * determined, the result is `"???"`. If multiple primary classes match,
   * this predicate can have multiple results.
   */
  string getAPrimaryQlClass() { result = "???" }
}

/** A location maps language elements to positions in source files. */
class Location extends @java_location {
  /** Gets the 1-based line number (inclusive) where this location starts. */
  int getStartLine() { java_locations_default(this, _, result, _, _, _) }

  /** Gets the 1-based column number (inclusive) where this location starts. */
  int getStartColumn() { java_locations_default(this, _, _, result, _, _) }

  /** Gets the 1-based line number (inclusive) where this location ends. */
  int getEndLine() { java_locations_default(this, _, _, _, result, _) }

  /** Gets the 1-based column number (inclusive) where this location ends. */
  int getEndColumn() { java_locations_default(this, _, _, _, _, result) }

  /**
   * Gets the total number of lines that this location ranges over,
   * including lines of code, comment and whitespace-only lines.
   */
  int getNumberOfLines() {
    exists(@java_sourceline s | java_hasLocation(s, this) |
      java_numlines(s, result, _, _)
      or
      not java_numlines(s, _, _, _) and result = 0
    )
  }

  /** Gets the number of lines of code that this location ranges over. */
  int getNumberOfLinesOfCode() {
    exists(@java_sourceline s | java_hasLocation(s, this) |
      java_numlines(s, _, result, _)
      or
      not java_numlines(s, _, _, _) and result = 0
    )
  }

  /** Gets the number of comment lines that this location ranges over. */
  int getNumberOfCommentLines() {
    exists(@java_sourceline s | java_hasLocation(s, this) |
      java_numlines(s, _, _, result)
      or
      not java_numlines(s, _, _, _) and result = 0
    )
  }

  /** Gets the file containing this location. */
  File getFile() { java_locations_default(this, result, _, _, _, _) }

  /** Gets a string representation containing the file and range for this location. */
  string toString() {
    exists(File f, int startLine, int startCol, int endLine, int endCol |
      java_locations_default(this, f, startLine, startCol, endLine, endCol)
    |
      if endLine = startLine
      then
        result =
          f.toString() + ":" + startLine.toString() + "[" + startCol.toString() + "-" +
            endCol.toString() + "]"
      else
        result =
          f.toString() + ":" + startLine.toString() + "[" + startCol.toString() + "]-" +
            endLine.toString() + "[" + endCol.toString() + "]"
    )
  }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(File f | java_locations_default(this, f, startline, startcolumn, endline, endcolumn) |
      filepath = f.getAbsolutePath()
    )
  }
}

private predicate hasSourceLocation(Top l, Location loc, File f) {
  java_hasLocation(l, loc) and f = loc.getFile() and f.getExtension() = "java"
}

cached
private predicate fixedHasLocation(Top l, Location loc, File f) {
  hasSourceLocation(l, loc, f)
  or
  java_hasLocation(l, loc) and not hasSourceLocation(l, _, _) and java_locations_default(loc, f, _, _, _, _)
}
