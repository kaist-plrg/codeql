#include <Python.h>
#include <stddef.h>
#include "structmember.h"

typedef struct {
    PyObject_HEAD
    PyObject* field1;
    PyObject* field2;
} Object;

static PyObject*
f_impl(Object* self, PyObject* _python_arg)
{
    self->field2 = Py_BuildValue("O",self->field1);
    Py_RETURN_NONE;
}

/* =========================================== */

struct PyMethodDef methods[] = {
    {
      "f",
      (PyCFunction) f_impl,
      METH_NOARGS,
      "" 
    },
    {NULL},
};

struct PyMemberDef members[] = {
    {
      "f1",
      T_OBJECT_EX,
      offsetof(Object, field1),
      0,
      ""
    },
    {
      "f2",
      T_OBJECT_EX,
      offsetof(Object, field2),
      0,
      ""
    },
    {NULL},
};


static PyTypeObject ObjectType = {
    PyVarObject_HEAD_INIT(NULL, 0)
    .tp_name = "module.Object",
    .tp_doc = "C object",
    .tp_basicsize = sizeof(Object),
    .tp_itemsize = 0,
    .tp_flags = Py_TPFLAGS_DEFAULT,
    .tp_new = PyType_GenericNew,
    .tp_methods = methods,
    .tp_members = members,
};

struct PyModuleDef module = {
    PyModuleDef_HEAD_INIT,
    "module",
    "c module",
    -1,
};

PyMODINIT_FUNC
PyInit_module(void)
{
    PyObject* m = PyModule_Create(&module);
    PyType_Ready(&ObjectType);
    Py_INCREF(&ObjectType);
    PyModule_AddObject(m, "Object", (PyObject*) &ObjectType);
    return m;
}
