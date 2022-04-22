#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <stddef.h>
#include "structmember.h"

static PyObject*
f_impl(PyObject* self, PyObject* python_arg)
{
    unsigned long c_arg = PyLong_AsUnsignedLong(python_arg);
    printf("f(%lu)\n", c_arg);
    PyObject* result = PyLong_FromUnsignedLong(c_arg);
    return result;
}

static PyObject*
g_impl(PyObject* self, PyObject* tuple)
{
    // tests various way of parsing tuple
    unsigned long n;
    
    PyObject* f1;
    PyArg_ParseTuple(tuple, "LO", &n, &f1);
    printf("g(%lu, func)\n", n);
    PyObject* args1 = Py_BuildValue("(L)", n);
    PyObject* result1 = PyObject_CallObject(f1, args1);
    
    PyObject* f2;
    f2 = PyTuple_GetItem(tuple, 1);
    PyObject* args2 = Py_BuildValue("(O)", result1);
    PyObject* result2 = PyObject_CallObject(f2, args2);
    
    PyObject* f3;
    PyArg_UnpackTuple(tuple, "", 1, 2, &n, &f3);
    PyObject* args3 = Py_BuildValue("(O)", result2);
    PyObject* result3 = PyObject_CallObject(f3, args3);
    
    PyObject* f4;
    char* k[] = {"n", "f", NULL};
    PyArg_ParseTupleAndKeywords(tuple, NULL, "LO", k, &n, &f4);
    PyObject* args4 = Py_BuildValue("(O)", result3);
    PyObject* result4 = PyObject_CallObject(f4, args4);
    
    return result4;
}

typedef struct {
  PyObject_HEAD
  unsigned long field;
} Object;

static PyObject*
h_impl(Object* self, PyObject* tuple)
{
    int n;
    PyArg_ParseTuple(tuple, "i", &n);
    self->field = n;
    Py_RETURN_NONE;
}

/* =========================================== */

struct PyMethodDef functions[] = {
    {
      "f",
      (PyCFunction) f_impl,
      METH_O,
      "identity" 
    },
    {
      "g",
      (PyCFunction) g_impl,
      METH_VARARGS,
      "apply" 
    },
    {NULL},
};

struct PyMethodDef methods[] = {
    {
      "h",
      (PyCFunction) h_impl,
      METH_VARARGS,
      "set to 42"
    },
    {NULL},
};

struct PyMemberDef members[] = {
    {
      "field",
      T_ULONG,
      offsetof(Object, field),
      0,
      "basic field" 
    },
    {NULL},
};

static PyTypeObject ObjectType = {
    PyVarObject_HEAD_INIT(NULL, 0)
    .tp_name = "cmodule.Cobject",
    .tp_doc = "C object",
    .tp_basicsize = sizeof(Object),
    .tp_itemsize = 0,
    .tp_flags = Py_TPFLAGS_DEFAULT,
    .tp_new = PyType_GenericNew,
    .tp_methods = methods,
    .tp_members = members,
};

struct PyModuleDef cmodule = {
    PyModuleDef_HEAD_INIT,
    "cmodule",
    "c module",
    -1,
    functions,
};

PyMODINIT_FUNC
PyInit_cmodule(void)
{
    PyObject* m = PyModule_Create(&cmodule);
    if (m == NULL)
        return NULL;

    if (PyType_Ready(&ObjectType) < 0)
        return NULL;

    Py_INCREF(&ObjectType);
    if (PyModule_AddObject(m, "Cobject", (PyObject *) &ObjectType) < 0)
    {
      Py_DECREF(&ObjectType);
      Py_DECREF(m);
      return NULL;
    }

    return m;
}
