#include <Python.h>

static PyObject*
sourceClean_impl(PyObject* self, PyObject* python_arg)
{
    PyObject_SetAttrString(python_arg, "value", PyLong_FromLong(42));
    Py_RETURN_NONE;
}

/* =========================================== */

struct PyMethodDef functions[] = {
    {
      "sourceClean",
      (PyCFunction) sourceClean_impl,
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
