#![allow(bad_style)]

use libc::{c_char, c_int};

// C boolean values.
//pub static FALSE: c_int = 0;
pub static TRUE: c_int = 1;

// Error codes.
pub static NOT_INITIALIZED    : c_int = 0x00010001;
pub static NO_CURRENT_CONTEXT : c_int = 0x00010002;
pub static INVALID_ENUM       : c_int = 0x00010003;
pub static INVALID_VALUE      : c_int = 0x00010004;
pub static OUT_OF_MEMORY      : c_int = 0x00010005;
pub static API_UNAVAILABLE    : c_int = 0x00010006;
pub static VERSION_UNAVAILABLE: c_int = 0x00010007;
pub static PLATFORM_ERROR     : c_int = 0x00010008;
pub static FORMAT_UNAVAILABLE : c_int = 0x00010009;

type GLFWerrorfun = extern fn(c_int, *const c_char);

extern {
    pub fn glfwInit() -> c_int;
    //pub fn glfwTerminate();

    pub fn glfwSetErrorCallback(cbfun: Option<GLFWerrorfun>) -> Option<GLFWerrorfun>;
}
