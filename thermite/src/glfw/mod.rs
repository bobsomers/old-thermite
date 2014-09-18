use libc::{c_char, c_int};

mod ffi;
mod platform;

// Public API

pub enum Error {
    NotInitialized,
    NoCurrentContext,
    InvalidEnum,
    InvalidValue,
    OutOfMemory,
    ApiUnavailable,
    VersionUnavailable,
    PlatformError,
    FormatUnavailable
}

pub fn init() -> bool {
    unsafe {
        ffi::glfwSetErrorCallback(Some(fail_on_error_callback));
        ffi::glfwInit() == ffi::TRUE
    }
}

// Internals

impl Error {
    fn from_code(err_code: c_int) -> Error {
        match err_code {
            ffi::NOT_INITIALIZED => NotInitialized,
            ffi::NO_CURRENT_CONTEXT => NoCurrentContext,
            ffi::INVALID_ENUM => InvalidEnum,
            ffi::INVALID_VALUE => InvalidValue,
            ffi::OUT_OF_MEMORY => OutOfMemory,
            ffi::API_UNAVAILABLE => ApiUnavailable,
            ffi::VERSION_UNAVAILABLE => VersionUnavailable,
            ffi::PLATFORM_ERROR => PlatformError,
            ffi::FORMAT_UNAVAILABLE => FormatUnavailable,
            _ => fail!("Unknown GLFW error code.")
        }
    }

    fn to_string(&self) -> &str {
        match *self {
            NotInitialized => "NotInitialized",
            NoCurrentContext => "NoCurrentContext",
            InvalidEnum => "InvalidEnum",
            InvalidValue => "InvalidValue",
            OutOfMemory => "OutOfMemory",
            ApiUnavailable => "ApiUnavailable",
            VersionUnavailable => "VersionUnavailable",
            PlatformError => "PlatformError",
            FormatUnavailable => "FormatUnavailable"
        }
    }
}

extern fn fail_on_error_callback(err_code: c_int, err_msg: *const c_char) {
    use std::string::raw;

    let error = Error::from_code(err_code);
    let message = unsafe { raw::from_buf(err_msg as *const u8) };
    fail!("GLFW Error: {}, {}", error.to_string(), message);
}
