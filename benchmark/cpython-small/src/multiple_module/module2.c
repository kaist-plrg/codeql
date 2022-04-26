#include <Python.h>

void SINK(PyObject* n) {}

static PyObject*
send2_impl(PyObject* self, PyObject* python_arg)
{
    SINK(NULL);
    Py_RETURN_NONE;
}

/* =========================================== */

struct PyMethodDef functions[] = {
    {
      "send2",
      (PyCFunction) send2_impl,
      METH_O,
      "" 
    },
    {NULL},
};

struct PyModuleDef module2 = {
    PyModuleDef_HEAD_INIT,
    "module2",
    "c module 2",
    -1,
    functions,
};

PyMODINIT_FUNC
PyInit_module2(void)
{
    return PyModule_Create(&module2);
}
