#include <Python.h>

void SINK(PyObject* n) {
    printf("%d\n", _PyLong_AsInt(n));
}

typedef struct {
    PyObject_HEAD
} Object;

static PyObject*
f_impl(Object* self, PyObject* python_arg)
{
    SINK(python_arg);
    Py_RETURN_NONE;
}

/* =========================================== */

struct PyMethodDef methods[] = {
    {
      "f",
      (PyCFunction) f_impl,
      METH_O,
      "" 
    },
    {NULL},
};

static PyTypeObject ObjectType = {
    PyVarObject_HEAD_INIT(NULL, 0)
    .tp_name = "module.Object",
    .tp_doc = "C object",
    .tp_basicsize = sizeof(Object),
    .tp_itemsize = 0,
    .tp_flags = Py_TPFLAGS_DEFAULT,
    .tp_new = PyType_GenericNew,
    .tp_methods = methods,
};

struct PyModuleDef module = {
    PyModuleDef_HEAD_INIT,
    "module",
    "c module",
    -1,
};

PyMODINIT_FUNC
PyInit_module(void)
{
    PyObject* m = PyModule_Create(&module);
    PyType_Ready(&ObjectType);
    Py_INCREF(&ObjectType);
    PyModule_AddObject(m, "Object", (PyObject*) &ObjectType);
    return m;
}
