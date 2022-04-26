#include <Python.h>
#include <string.h>

void SINK(PyObject* n) {
    printf("%d\n", _PyLong_AsInt(n));
}

static PyObject*
send_impl(PyObject* self, PyObject* python_arg)
{
    char *p1 = "da";
    char *p2 = "ta";
    char name[10];
    strcpy(name, p1); // copy string one into the result.
    strcat(name, p2);

    PyObject* data = PyObject_GetAttrString(python_arg, name);
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
