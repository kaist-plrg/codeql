#include <Python.h>

static PyObject*
getData_impl(PyObject* self, PyObject* python_arg)
{
    return PyLong_FromLong(43);
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
