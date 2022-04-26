#include <Python.h>

void SINK(PyObject* n) {
    printf("%d\n", _PyLong_AsInt(n));
}

static PyObject*
propagate_impl(PyObject* self, PyObject* python_args)
{
    PyObject* obj;
    PyObject* callback;
    PyArg_ParseTuple(python_args, "OO", &obj, &callback);
    PyObject_CallObject(callback, Py_BuildValue("(O)", PyObject_GetAttrString(obj, "v")));
    Py_RETURN_NONE;
}

static PyObject*
leak_impl(PyObject* self, PyObject* python_arg)
{
    SINK(python_arg);
    Py_RETURN_NONE;
}

/* =========================================== */

struct PyMethodDef functions[] = {
    {
      "propagate",
      (PyCFunction) propagate_impl,
      METH_VARARGS,
      ""
    },
    {
      "leak",
      (PyCFunction) leak_impl,
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
