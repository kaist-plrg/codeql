#include <Python.h>

void SINK(PyObject* n) {
    printf("%d\n", _PyLong_AsInt(n));
}

static PyObject*
send_impl(PyObject* self, PyObject* python_arg)
{
    PyObject* data = PyObject_CallMethod(python_arg, "getData", NULL);
    SINK(data);
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
