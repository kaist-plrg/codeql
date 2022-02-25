#define PY_SSIZE_T_CLEAN
#include <Python.h>

static PyObject*
f_impl(PyObject* self, PyObject* python_arg)
{
    unsigned long c_arg = PyLong_AsUnsignedLong(python_arg);
    printf("f(%lu)\n", c_arg);
    PyObject* result = PyLong_FromUnsignedLong(c_arg);
    return result;
}

static PyObject*
g_impl(PyObject* self, PyObject* tuple)
{
    unsigned long elem1, elem2;
    PyArg_ParseTuple(tuple, "LL", &elem1, &elem2);
    printf("g(%lu, %lu)\n", elem1, elem2);
    PyObject* result2 = PyLong_FromUnsignedLong(elem2);
    return result2;
}

/* =========================================== */

struct PyMethodDef methods[] = {
    {
      "f",
      (PyCFunction) f_impl,
      METH_O,
      "identity" 
    },
    {
      "g",
      (PyCFunction) g_impl,
      METH_VARARGS,
      "second arg" 
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
