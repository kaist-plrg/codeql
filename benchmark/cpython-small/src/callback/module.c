#include <Python.h>

void SINK(PyObject* n) {
    printf("%d\n", _PyLong_AsInt(n));
}

static PyObject*
f_impl(PyObject* self, PyObject* python_args)
{
    PyObject* func;
    PyObject* arg1;
    PyObject* arg2;

    PyArg_ParseTuple(python_args, "OOO", &func, &arg1, &arg2);

    PyObject* c_args = Py_BuildValue("(OO)", arg1, arg2);
    PyObject* ret = PyObject_CallObject(func, c_args);

    SINK(ret);
    Py_RETURN_NONE;
}

// TODO: Add other protocols, i.e., PyObject_CallMethod / PyObject_Call / ...

/* =========================================== */

struct PyMethodDef functions[] = {
    {
      "f",
      (PyCFunction) f_impl,
      METH_VARARGS,
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
