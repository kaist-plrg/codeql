#include <Python.h>

PyObject* SOURCE() {
    return PyLong_FromLong(42);
}

static PyObject*
heapModify_impl(PyObject* self, PyObject* python_arg)
{
    PyObject* data = SOURCE();
    PyObject_SetAttrString(python_arg, "data", data);
    Py_RETURN_NONE;
}

/* =========================================== */

struct PyMethodDef functions[] = {
    {
      "heapModify",
      (PyCFunction) heapModify_impl,
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
