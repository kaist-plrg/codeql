/**
 * Provides predicates for identifying suggested replacements for unsupported JDK-internal APIs.
 */

/**
 * Provides a QL encoding of the suggested replacements for unsupported JDK-internal APIs listed at:
 *
 * http://hg.openjdk.java.net/jdk9/jdk9/langtools/file/6ba2130e87bd/src/jdk.jdeps/share/classes/com/sun/tools/jdeps/resources/jdkinternals.properties
 */
predicate jdkInternalReplacement(string old, string new) {
  exists(string r, int eqIdx | jdkInternalReplacement(r) and eqIdx = r.indexOf("=") |
    old = r.prefix(eqIdx) and
    new = r.suffix(eqIdx + 1)
  )
}

private predicate jdkInternalReplacement(string r) {
  r =
    "com.sun.crypto.provider.SunJCE=Use java.security.Security.getProvider(provider-name) @java_since 1.3" or
  r = "com.sun.org.apache.xml.internal.security=Use java.xml.crypto @java_since 1.6" or
  r = "com.sun.org.apache.xml.internal.security.utils.Base64=Use java.util.Base64 @java_since 1.8" or
  r = "com.sun.org.apache.xml.internal.resolver=Use javax.xml.catalog @java_since 9" or
  r = "com.sun.net.ssl=Use javax.net.ssl @java_since 1.4" or
  r =
    "com.sun.net.ssl.internal.ssl.Provider=Use java.security.Security.getProvider(provider-name) @java_since 1.3" or
  r = "com.sun.rowset=Use javax.sql.rowset.RowSetProvider @java_since 1.7" or
  r = "com.sun.tools.javac.tree=Use com.sun.source @java_since 1.6" or
  r = "com.sun.tools.javac=Use javax.tools and javax.lang.model @java_since 1.6" or
  r = "java.awt.peer=Should not use. See https://bugs.openjdk.java.net/browse/JDK-8037739" or
  r = "java.awt.dnd.peer=Should not use. See https://bugs.openjdk.java.net/browse/JDK-8037739" or
  r =
    "jdk.internal.ref.Cleaner=Use java.lang.ref.PhantomReference @java_since 1.2 or java.lang.ref.Cleaner @java_since 9" or
  r = "sun.awt.CausedFocusEvent=Use java.awt.event.FocusEvent::getCause @java_since 9" or
  r = "sun.font.FontUtilities=See java.awt.Font.textRequiresLayout @java_since 9" or
  r = "sun.reflect.Reflection=Use java.lang.StackWalker @java_since 9" or
  r = "sun.reflect.ReflectionFactory=See http://openjdk.java.net/jeps/260" or
  r = "sun.misc.Unsafe=See http://openjdk.java.net/jeps/260" or
  r = "sun.misc.Signal=See http://openjdk.java.net/jeps/260" or
  r = "sun.misc.SignalHandler=See http://openjdk.java.net/jeps/260" or
  r = "sun.security.action=Use java.security.PrivilegedAction @java_since 1.1" or
  r = "sun.security.krb5=Use com.sun.security.jgss" or
  r =
    "sun.security.provider.PolicyFile=Use java.security.Policy.getInstance(\"JavaPolicy\", new URIParameter(uri)) @java_since 1.6" or
  r = "sun.security.provider.Sun=Use java.security.Security.getProvider(provider-name) @java_since 1.3" or
  r =
    "sun.security.util.HostnameChecker=Use javax.net.ssl.SSLParameters.setEndpointIdentificationAlgorithm(\"HTTPS\") @java_since 1.7 or javax.net.ssl.HttpsURLConnection.setHostnameVerifier() @java_since 1.4" or
  r =
    "sun.security.util.SecurityConstants=Use appropriate java.security.Permission subclass @java_since 1.1" or
  r = "sun.security.x509.X500Name=Use javax.security.auth.x500.X500Principal @java_since 1.4" or
  r = "sun.tools.jar=Use java.util.jar or jar tool @java_since 1.2" or
  // Internal APIs removed in JDK 9
  r = "com.apple.eawt=Use java.awt.Desktop and JEP 272 @java_since 9" or
  r = "com.apple.concurrent=Removed. See https://bugs.openjdk.java.net/browse/JDK-8148187" or
  r = "com.sun.image.codec.jpeg=Use javax.imageio @java_since 1.4" or
  r = "sun.awt.image.codec=Use javax.imageio @java_since 1.4" or
  r = "sun.misc.BASE64Encoder=Use java.util.Base64 @java_since 1.8" or
  r = "sun.misc.BASE64Decoder=Use java.util.Base64 @java_since 1.8" or
  r =
    "sun.misc.Cleaner=Use java.lang.ref.PhantomReference @java_since 1.2 or java.lang.ref.Cleaner @java_since 9" or
  r = "sun.misc.Service=Use java.util.ServiceLoader @java_since 1.6" or
  r = "sun.misc=Removed. See http://openjdk.java.net/jeps/260" or
  r = "sun.reflect=Removed. See http://openjdk.java.net/jeps/260"
}
