#include <Python.h>

void NOSINK(PyObject* n) { }

static PyObject*
send_impl(PyObject* self, PyObject* python_arg)
{
    NOSINK(PyList_GetItem(python_arg, 0));
    Py_RETURN_NONE;
}

/* =========================================== */

struct PyMethodDef functions[] = {
    {
      "send",
      (PyCFunction) send_impl,
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
