#include <Python.h>

static PyObject*
setField_impl(PyObject* self, PyObject* python_args)
{
    PyObject* wrapper;
    PyObject* otherWrapper;
    
    PyArg_ParseTuple(python_args, "OO", &wrapper, &otherWrapper);
    PyObject* data = PyObject_GetAttrString(otherWrapper, "data");

    PyObject_SetAttrString(wrapper, "data", data);

    PyObject* dataRet = PyObject_GetAttrString(wrapper, "data");
    return dataRet;
}

/* =========================================== */

struct PyMethodDef functions[] = {
    {
      "setField",
      (PyCFunction) setField_impl,
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
