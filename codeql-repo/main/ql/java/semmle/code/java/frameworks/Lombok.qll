/**
 * Provides classes and predicates for identifying use of the Lombok framework.
 */

import java

/*
 * Lombok annotations.
 */

/**
 * An annotation from the Lombok framework.
 */
class LombokAnnotation extends Annotation {
  LombokAnnotation() {
    getType().getPackage().hasName("lombok") or
    getType().getPackage().getName().matches("lombok.%")
  }
}

/**
 * A Lombok `@java_NonNull` annotation.
 */
class LombokNonNullAnnotation extends LombokAnnotation {
  LombokNonNullAnnotation() { getType().hasName("NonNull") }
}

/**
 * A Lombok `@java_Cleanup` annotation.
 *
 * Local variable declarations annotated with `@java_Cleanup` are
 * automatically closed by Lombok in a generated try-finally block.
 */
class LombokCleanupAnnotation extends LombokAnnotation {
  LombokCleanupAnnotation() { getType().hasName("Cleanup") }
}

/**
 * A Lombok `@java_Getter` annotation.
 *
 * For fields annotated with `@java_Getter`, Lombok automatically
 * generates a corresponding getter method.
 *
 * For classes annotated with `@java_Getter`, Lombok automatically
 * generates corresponding getter methods for all non-static
 * fields in the annotated class, unless this behavior is
 * overridden by specifying `AccessLevel.NONE` for a field.
 */
class LombokGetterAnnotation extends LombokAnnotation {
  LombokGetterAnnotation() { getType().hasName("Getter") }
}

/**
 * A Lombok `@java_Setter` annotation.
 *
 * For fields annotated with `@java_Setter`, Lombok automatically
 * generates a corresponding setter method.
 *
 * For classes annotated with `@java_Setter`, Lombok automatically
 * generates corresponding setter methods for all non-static
 * fields in the annotated class, unless this behavior is
 * overridden by specifying `AccessLevel.NONE` for a field.
 */
class LombokSetterAnnotation extends LombokAnnotation {
  LombokSetterAnnotation() { getType().hasName("Setter") }
}

/**
 * A Lombok `@java_ToString` annotation.
 *
 * For classes annotated with `@java_ToString`, Lombok automatically
 * generates a `toString()` method.
 */
class LombokToStringAnnotation extends LombokAnnotation {
  LombokToStringAnnotation() { getType().hasName("ToString") }
}

/**
 * A Lombok `@java_EqualsAndHashCode` annotation.
 *
 * For classes annotated with `@java_EqualsAndHashCode`, Lombok automatically
 * generates suitable `equals` and `hashCode` methods.
 */
class LombokEqualsAndHashCodeAnnotation extends LombokAnnotation {
  LombokEqualsAndHashCodeAnnotation() { getType().hasName("EqualsAndHashCode") }
}

/**
 * A Lombok `@java_NoArgsConstructor` annotation.
 *
 * For classes annotated with `@java_NoArgsConstructor`, Lombok automatically
 * generates a constructor with no parameters.
 */
class LombokNoArgsConstructorAnnotation extends LombokAnnotation {
  LombokNoArgsConstructorAnnotation() { getType().hasName("NoArgsConstructor") }
}

/**
 * A Lombok `@java_RequiredArgsConstructor` annotation.
 *
 * For classes annotated with `@java_RequiredArgsConstructor`, Lombok automatically
 * generates a constructor with a parameter for each non-initialized final
 * field as well as any field annotated with `@java_NonNull` that is not initialized
 * where it is declared.
 */
class LombokRequiredArgsConstructorAnnotation extends LombokAnnotation {
  LombokRequiredArgsConstructorAnnotation() { getType().hasName("RequiredArgsConstructor") }
}

/**
 * A Lombok `@java_AllArgsConstructor` annotation.
 *
 * For classes annotated with `@java_AllArgsConstructor`, Lombok automatically
 * generates a constructor with a parameter for each field in the class.
 */
class LombokAllArgsConstructorAnnotation extends LombokAnnotation {
  LombokAllArgsConstructorAnnotation() { getType().hasName("AllArgsConstructor") }
}

/**
 * A Lombok `@java_Data` annotation.
 *
 * A shortcut for `@java_ToString`, `@java_EqualsAndHashCode`, `@java_Getter` on all
 * fields, `@java_Setter` on all non-final fields, and `@java_RequiredArgsConstructor`.
 */
class LombokDataAnnotation extends LombokAnnotation {
  LombokDataAnnotation() { getType().hasName("Data") }
}

/**
 * A Lombok `@java_Value` annotation.
 *
 * Effectively a shortcut for:
 *
 * ```
 * final @java_ToString @java_EqualsAndHashCode @java_AllArgsConstructor
 * @java_FieldDefaults(makeFinal=true,level=AccessLevel.PRIVATE) @java_Getter
 * ```
 */
class LombokValueAnnotation extends LombokAnnotation {
  LombokValueAnnotation() { getType().hasName("Value") }
}

/**
 * A Lombok `@java_Builder` annotation.
 *
 * For classes annotated with `@java_Builder`, Lombok automatically
 * generates complex builder APIs for the class.
 */
class LombokBuilderAnnotation extends LombokAnnotation {
  LombokBuilderAnnotation() { getType().hasName("Builder") }
}

/**
 * A Lombok `@java_SneakyThrows` annotation.
 *
 * This annotation allows throwing checked exceptions
 * without declaring them in a `throws` clause.
 */
class LombokSneakyThrowsAnnotation extends LombokAnnotation {
  LombokSneakyThrowsAnnotation() { getType().hasName("SneakyThrows") }
}

/**
 * A Lombok `@java_Synchronized` annotation.
 *
 * This annotation is treated by Lombok as a variant of the
 * `synchronized` modifier. Lombok automatically generates
 * suitable lock objects and `synchronized` statements for
 * methods annotated with `@java_Synchronized`.
 */
class LombokSynchronizedAnnotation extends LombokAnnotation {
  LombokSynchronizedAnnotation() { getType().hasName("Synchronized") }
}

/**
 * A Lombok `@java_Log` annotation.
 *
 * For classes annotated with `@java_Log`, Lombok automatically
 * generates a logger field named `log` with a specified type.
 */
class LombokLogAnnotation extends LombokAnnotation {
  LombokLogAnnotation() { getType().hasName("Log") }
}

/*
 * Elements annotated with Lombok annotations.
 */

/**
 * A field for which a getter method is generated by the Lombok framework.
 *
 * Specifically, a field that is either directly annotated with a Lombok
 * `@java_Getter` annotation or is declared in a class annotated with a Lombok
 * `@java_Getter`, `@java_Data` or `@java_Value` annotation.
 */
class LombokGetterAnnotatedField extends Field {
  LombokGetterAnnotatedField() {
    getAnAnnotation() instanceof LombokGetterAnnotation
    or
    exists(LombokAnnotation a |
      a instanceof LombokGetterAnnotation or
      a instanceof LombokDataAnnotation or
      a instanceof LombokValueAnnotation
    |
      a = getDeclaringType().getSourceDeclaration().getAnAnnotation()
    )
  }
}

/**
 * A class for which `equals` and `hashCode` methods are generated
 * by the Lombok framework.
 *
 * Specifically, a class with one of the following annotations:
 * `@java_EqualsAndHashCode`, `@java_Data`, or `@java_Value`.
 */
class LombokEqualsAndHashCodeGeneratedClass extends Class {
  LombokEqualsAndHashCodeGeneratedClass() {
    getAnAnnotation() instanceof LombokEqualsAndHashCodeAnnotation or
    getAnAnnotation() instanceof LombokDataAnnotation or
    getAnAnnotation() instanceof LombokValueAnnotation
  }
}
