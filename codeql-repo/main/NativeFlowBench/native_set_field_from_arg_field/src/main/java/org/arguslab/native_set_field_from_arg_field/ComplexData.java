package org.arguslab.native_set_field_from_arg_field;

/**
 * Created by Xingwei Lin 14/01/2018.
 */

public class ComplexData {
    private int index;
    private String data;
    private Foo foo;

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public Foo getFoo() {
        return foo;
    }

    public void setFoo(Foo foo) {
        this.foo = foo;
    }
}

