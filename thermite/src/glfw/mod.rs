use libc::{c_char, c_int};
use std::fmt;

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

// This error bootstrapping is nasty!
extern fn preinit_error_callback(code: c_int, message: *const c_char) {
    let error = Error::new(code, message);
    fail!("glfwInit() {}", error);
}
