extern crate thermite;
extern crate native;

use thermite::glfw;

fn main() {
    let glfw = glfw::init();
    let window = glfw.create_window(640, 480, "Thermite");
    while !window.should_close() {
        glfw.poll_events();
    }
}
