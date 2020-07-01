package com.applicaster.xray

import com.applicaster.xray.core.formatting.message.NamedReflectionMessageFormatter
import org.junit.Test

import org.junit.Assert.*

/**
 * Example local unit test, which will execute on the development machine (host).
 *
 * See [testing documentation](http://d.android.com/tools/testing).
 */
class NamedReflectionMessageFormatterUnitTest {
    @Test
    fun testAnchorsMessageFormatter() {

        val kotlinTestClass = KotlinTestClass("Kotlin String field", 0xff, 0.1f)
        val javaTestClass = JavaTestClass("Java String field", 0xff, 0.1f)

        val formatter = NamedReflectionMessageFormatter()

        val anchorA = mutableMapOf<String, Any?>()
        val resultA = formatter.format(
            "Formatter test for Kotlin class %s&anchor names",
            anchorA,
            kotlinTestClass
        )

        assertEquals("Formatted as expected",
            "Formatter test for Kotlin class {\"fieldString\":\"Kotlin String field\",\"fieldInt\":255,\"floatField\":0.1}&anchor names",
            resultA)
        assertTrue("Anchored object found", anchorA.contains("anchor"))
        assertSame("Anchored object extracted", kotlinTestClass, anchorA["anchor"])

        val anchorAB = mutableMapOf<String, Any?>()
        val resultAB = formatter.format("Formatter test for Java class %2\$s&anchor_b Kotlin class %1\$s&anchor_a names",
            anchorAB,
            kotlinTestClass,
            javaTestClass)

        assertEquals("Formatted as expected",
            "Formatter test for Java class {\"fieldFloat\":0.1,\"fieldInt\":255,\"fieldString\":\"Java String field\"}&anchor_b Kotlin class {\"fieldString\":\"Kotlin String field\",\"fieldInt\":255,\"floatField\":0.1}&anchor_a names",
            resultAB)
        assertTrue("Anchored object A found", anchorAB.contains("anchor_a"))
        assertTrue("Anchored object B found", anchorAB.contains("anchor_b"))
        assertSame("Anchored object A extracted", kotlinTestClass, anchorAB["anchor_a"])
        assertSame("Anchored object B extracted", javaTestClass, anchorAB["anchor_b"])
    }
}