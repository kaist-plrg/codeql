#include <Python.h>

void SINK(PyObject* n) {
    printf("%d\n", _PyLong_AsInt(n));
}

static PyObject*
f1_impl(PyObject* self, PyObject* python_args)
{
    PyObject* e1;
    PyObject* e2;

    PyArg_ParseTuple(python_args, "OO", &e1, &e2);
    SINK(e2);
    Py_RETURN_NONE;
}

static PyObject*
f2_impl(PyObject* self, PyObject* python_args)
{
    PyObject* e1;
    PyObject* e2;

    PyArg_UnpackTuple(python_args, "f2", 1, 2, &e1, &e2);
    SINK(e2);
    Py_RETURN_NONE;
}

static PyObject*
f3_impl(PyObject* self, PyObject* python_args)
{
    SINK(PyTuple_GetItem(python_args, 1));
    Py_RETURN_NONE;
}

/* =========================================== */

struct PyMethodDef functions[] = {
    {
      "f1",
      (PyCFunction) f1_impl,
      METH_VARARGS,
      "PyArg_ParseTuple"
    },
    {
      "f2",
      (PyCFunction) f2_impl,
      METH_VARARGS,
      "PyArg_UnpapckTuple"
    },
    {
      "f3",
      (PyCFunction) f3_impl,
      METH_VARARGS,
      "PyTuple_GetItem"
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
