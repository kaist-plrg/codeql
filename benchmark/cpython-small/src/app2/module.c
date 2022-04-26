#include <Python.h>

void SINK(PyObject* n) {
    printf("%d\n", _PyLong_AsInt(n));
}

static PyObject*
f_impl(PyObject* self, PyObject* python_arg)
{
    SINK(python_arg);
    Py_RETURN_NONE;
}

/* =========================================== */

struct PyMethodDef functions[] = {
    {
      "f",
      (PyCFunction) f_impl,
      METH_O,
      "" 
    },
    {NULL},
};

struct PyModuleDef module = {
    PyModuleDef_HEAD_INIT,
    "module",
    "c module",
    -1,
    functions,
};

PyMODINIT_FUNC
PyInit_module(void)
{
    return PyModule_Create(&module);
}
