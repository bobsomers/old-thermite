extern crate libc;

#[link(name = "glfw3")]
#[allow(non_snake_case)]
extern {
    fn glfwInit() -> libc::c_int;
}

pub fn init() -> bool {
    unsafe {
        glfwInit() != 0
    }
}
