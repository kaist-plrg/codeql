#include <Python.h>

PyObject* SOURCE() {
    return PyLong_FromLong(42);
}

static PyObject*
getData_impl(PyObject* self, PyObject* python_arg)
{
    return SOURCE();
}

/* =========================================== */

struct PyMethodDef functions[] = {
    {
      "getData",
      (PyCFunction) getData_impl,
      METH_NOARGS,
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
