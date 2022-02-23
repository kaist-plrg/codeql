#define PY_SSIZE_T_CLEAN
#include <Python.h>

static PyObject*
f_impl(PyObject* self, PyObject* python_arg)
{
    unsigned long c_arg = PyLong_AsUnsignedLong(python_arg);
    PyObject* result = PyLong_FromUnsignedLong(c_arg);
    return result;
}

/* =========================================== */

struct PyMethodDef methods[] = {
    {
      "f",
      (PyCFunction) f_impl,
      METH_O,
      "identity" 
    },
    {NULL},
};

struct PyModuleDef cmodule = {
    PyModuleDef_HEAD_INIT,
    "cmodule",
    "c module",
    -1,
    methods,
};

PyMODINIT_FUNC
PyInit_cmodule(void)
{
    return PyModule_Create(&cmodule);
}
