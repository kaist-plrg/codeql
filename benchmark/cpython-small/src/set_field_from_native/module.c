#include <Python.h>

PyObject* SOURCE() {
    return PyLong_FromLong(42);
}

static PyObject*
setField_impl(PyObject* self, PyObject* wrapper)
{
    PyObject* data = PyObject_GetAttrString(wrapper, "data");
    PyObject_SetAttrString(data, "value", SOURCE());
    PyObject_SetAttrString(wrapper, "data", data);

    PyObject* dataRet = PyObject_GetAttrString(wrapper, "data");
    return dataRet;
}

/* =========================================== */

struct PyMethodDef functions[] = {
    {
      "setField",
      (PyCFunction) setField_impl,
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
