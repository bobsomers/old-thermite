#![allow(bad_style)]

extern crate libc;

use self::libc::{c_char, c_int};

type GLFWerrorfun = extern fn(c_int, *const c_char);

extern {
    pub fn glfwInit() -> c_int;
    //pub fn glfwTerminate();

    pub fn glfwSetErrorCallback(cbfun: Option<GLFWerrorfun>) -> Option<GLFWerrorfun>;
}
