package org.picocontainer.tests.integration;

import com.intellij.util.pico.DefaultPicoContainer;
import org.junit.Test;
import org.junit.Assert;
import org.jetbrains.annotations.Nullable;

public class MyTests {

    @Test
    public void testIt() {

        DefaultPicoContainer dpc = new DefaultPicoContainer();
        dpc.registerComponentInstance(String.class, "hello");
        dpc.registerComponentImplementation(NeedsString.class);
        @Nullable Object ns = dpc.getComponentInstance(NeedsString.class);
        Assert.assertEquals("NeedsString{aString='hello'}", ns.toString());

    }

    public static class NeedsString {
        private String aString;

        public NeedsString(String aString) {
            this.aString = aString;
        }

        @Override
        public String toString() {
            return "NeedsString{" +
                    "aString='" + aString + '\'' +
                    '}';
        }
    }
}
