extern crate libc;

mod ffi;
mod platform;

extern fn preinit_error_callback(code: libc::c_int, msg: *const libc::c_char) {
    use std::string::raw;

    let err_code = code as int;
    let err_msg = unsafe { raw::from_buf(msg as *const u8) };

    fail!("GLFW preinit failure: {}, {}", err_code, err_msg);
}

pub fn init() -> bool {
    unsafe {
        ffi::glfwSetErrorCallback(Some(preinit_error_callback));
        ffi::glfwInit() != 0
    }
}
