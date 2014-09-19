use libc::{c_char, c_int};
use std::fmt;
use std::ptr;

mod ffi;
mod platform;

pub enum Error {
    NotInitialized(String),
    NoCurrentContext(String),
    InvalidEnum(String),
    InvalidValue(String),
    OutOfMemory(String),
    ApiUnavailable(String),
    VersionUnavailable(String),
    PlatformError(String),
    FormatUnavailable(String)
}

pub struct Context;

pub struct Window {
    ptr: ffi::GLFWwindow
}

pub fn init() -> Context {
    unsafe {
        ffi::glfwSetErrorCallback(Some(preinit_error_callback));
        if ffi::glfwInit() == ffi::FALSE {
            fail!("glfwInit() failed");
        }
    }
    Context
}

impl Error {
    fn new(code: c_int, message: *const c_char) -> Error {
        use std::string::raw;
        use std::mem;
        let msg = unsafe { raw::from_buf(mem::transmute(message)) };

        match code {
            ffi::NOT_INITIALIZED => NotInitialized(msg),
            ffi::NO_CURRENT_CONTEXT => NoCurrentContext(msg),
            ffi::INVALID_ENUM => InvalidEnum(msg),
            ffi::INVALID_VALUE => InvalidValue(msg),
            ffi::OUT_OF_MEMORY => OutOfMemory(msg),
            ffi::API_UNAVAILABLE => ApiUnavailable(msg),
            ffi::VERSION_UNAVAILABLE => VersionUnavailable(msg),
            ffi::PLATFORM_ERROR => PlatformError(msg),
            ffi::FORMAT_UNAVAILABLE => FormatUnavailable(msg),
            _ => fail!("Unknown GLFW error code.")
        }
    }
}

impl fmt::Show for Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            NotInitialized(ref msg) => write!(f, "NotInitialized: {}", msg),
            NoCurrentContext(ref msg) => write!(f, "NoCurrentContext: {}", msg),
            InvalidEnum(ref msg) => write!(f, "InvalidEnum: {}", msg),
            InvalidValue(ref msg) => write!(f, "InvalidValue: {}", msg),
            OutOfMemory(ref msg) => write!(f, "OutOfMemory: {}", msg),
            ApiUnavailable(ref msg) => write!(f, "ApiUnavailable: {}", msg),
            VersionUnavailable(ref msg) => write!(f, "VersionUnavailable: {}", msg),
            PlatformError(ref msg) => write!(f, "PlatformError: {}", msg),
            FormatUnavailable(ref msg) => write!(f, "FormatUnavailable: {}", msg)
        }
    }
}

impl Drop for Context {
    fn drop(&mut self) {
        unsafe {
            ffi::glfwTerminate();
        }
    }
}

impl Context {
    // TODO: implement last two parameters, monitor and share
    // TODO: error handling if c_window is null (glfwTerminate)
    pub fn create_window(&self, width: int, height: int, title: &str) -> Window {
        let c_title = title.to_c_str();
        unsafe {
            let c_window = ffi::glfwCreateWindow(
                    width as c_int, height as c_int, c_title.as_ptr(),
                    ptr::mut_null(), ptr::mut_null());
            Window { ptr: c_window }
        }
    }

    pub fn poll_events(&self) {
        unsafe {
            ffi::glfwPollEvents();
        }
    }
}

impl Window {
    pub fn should_close(&self) -> bool {
        let result = unsafe { ffi::glfwWindowShouldClose(self.ptr) };
        match result {
            0 => false,
            _ => true
        }
    }
}

extern fn preinit_error_callback(code: c_int, message: *const c_char) {
    let error = Error::new(code, message);
    fail!("glfwInit() {}", error);
}
