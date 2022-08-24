package net.medrag.springmvntemplate.annotations;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.ElementType.TYPE;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

/**
 * Types and methods annotated with this annotation will be excluded from JaCoCo reports.
 *
 * @author Stanislav Tretyakov
 * 24.08.2022
 */
@Retention(RUNTIME)
@Target({TYPE, METHOD})
public @interface NotGeneratedButJaCoCoExclusion {
}
