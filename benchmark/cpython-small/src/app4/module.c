#include <Python.h>

static PyObject*
f_impl(PyObject* self, PyObject* python_arg)
{
    return Py_BuildValue("O", python_arg);
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
