extern crate thermite;

use thermite::glfw;

fn main() {
    let glfw = glfw::init();

    glfw.on_error = |e: Error| {
        println!("Oh noes, error! {}", e);
    }

    let window = glfw.create_window(-1, -1, "Thermite");
    while !window.should_close() {
        glfw.poll_events();
    }
}
