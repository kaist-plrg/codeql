/**
 * Provides classes and predicates for working with annotations in the `javax` package.
 */

import java

/*
 * Annotations in the package `javax.annotation`.
 */

/**
 * A `@java_javax.annotation.Generated` annotation.
 */
class GeneratedAnnotation extends Annotation {
  GeneratedAnnotation() { this.getType().hasQualifiedName("javax.annotation", "Generated") }
}

/**
 * A `@java_javax.annotation.PostConstruct` annotation.
 */
class PostConstructAnnotation extends Annotation {
  PostConstructAnnotation() { this.getType().hasQualifiedName("javax.annotation", "PostConstruct") }
}

/**
 * A `@java_javax.annotation.PreDestroy` annotation.
 */
class PreDestroyAnnotation extends Annotation {
  PreDestroyAnnotation() { this.getType().hasQualifiedName("javax.annotation", "PreDestroy") }
}

/**
 * A `@java_javax.annotation.Resource` annotation.
 */
class ResourceAnnotation extends Annotation {
  ResourceAnnotation() { this.getType().hasQualifiedName("javax.annotation", "Resource") }
}

/**
 * A `@java_javax.annotation.Resources` annotation.
 */
class ResourcesAnnotation extends Annotation {
  ResourcesAnnotation() { this.getType().hasQualifiedName("javax.annotation", "Resources") }
}

/**
 * A `@java_javax.annotation.ManagedBean` annotation.
 */
class JavaxManagedBeanAnnotation extends Annotation {
  JavaxManagedBeanAnnotation() {
    this.getType().hasQualifiedName("javax.annotation", "ManagedBean")
  }
}

/*
 * Annotations in the package `javax.annotation.security`.
 */

/**
 * A `@java_javax.annotation.security.DeclareRoles` annotation.
 */
class DeclareRolesAnnotation extends Annotation {
  DeclareRolesAnnotation() {
    this.getType().hasQualifiedName("javax.annotation.security", "DeclareRoles")
  }
}

/**
 * A `@java_javax.annotation.security.DenyAll` annotation.
 */
class DenyAllAnnotation extends Annotation {
  DenyAllAnnotation() { this.getType().hasQualifiedName("javax.annotation.security", "DenyAll") }
}

/**
 * A `@java_javax.annotation.security.PermitAll` annotation.
 */
class PermitAllAnnotation extends Annotation {
  PermitAllAnnotation() {
    this.getType().hasQualifiedName("javax.annotation.security", "PermitAll")
  }
}

/**
 * A `@java_javax.annotation.security.RolesAllowed` annotation.
 */
class RolesAllowedAnnotation extends Annotation {
  RolesAllowedAnnotation() {
    this.getType().hasQualifiedName("javax.annotation.security", "RolesAllowed")
  }
}

/**
 * A `@java_javax.annotation.security.RunAs` annotation.
 */
class RunAsAnnotation extends Annotation {
  RunAsAnnotation() { this.getType().hasQualifiedName("javax.annotation.security", "RunAs") }
}

/*
 * Annotations in the package `javax.interceptor`.
 */

/**
 * A `@java_javax.interceptor.AroundInvoke` annotation.
 */
class AroundInvokeAnnotation extends Annotation {
  AroundInvokeAnnotation() { this.getType().hasQualifiedName("javax.interceptor", "AroundInvoke") }
}

/**
 * A `@java_javax.interceptor.ExcludeClassInterceptors` annotation.
 */
class ExcludeClassInterceptorsAnnotation extends Annotation {
  ExcludeClassInterceptorsAnnotation() {
    this.getType().hasQualifiedName("javax.interceptor", "ExcludeClassInterceptors")
  }
}

/**
 * A `@java_javax.interceptor.ExcludeDefaultInterceptors` annotation.
 */
class ExcludeDefaultInterceptorsAnnotation extends Annotation {
  ExcludeDefaultInterceptorsAnnotation() {
    this.getType().hasQualifiedName("javax.interceptor", "ExcludeDefaultInterceptors")
  }
}

/**
 * A `@java_javax.interceptor.Interceptors` annotation.
 */
class InterceptorsAnnotation extends Annotation {
  InterceptorsAnnotation() { this.getType().hasQualifiedName("javax.interceptor", "Interceptors") }
}

/*
 * Annotations in the package `javax.jws`.
 */

/**
 * A `@java_javax.jws.WebService` annotation.
 */
class WebServiceAnnotation extends Annotation {
  WebServiceAnnotation() { this.getType().hasQualifiedName("javax.jws", "WebService") }
}

/*
 * Annotations in the package `javax.xml.ws`.
 */

/**
 * A `@java_javax.xml.ws.WebServiceRef` annotation.
 */
class WebServiceRefAnnotation extends Annotation {
  WebServiceRefAnnotation() { this.getType().hasQualifiedName("javax.xml.ws", "WebServiceRef") }
}
