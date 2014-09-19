extern crate thermite;
extern crate native;

use thermite::glfw;
use std::io::timer;
use std::time;

fn main() {
    let glfw = glfw::init();
    glfw.create_window(640, 480, "Thermite");
    timer::sleep(time::Duration::seconds(10));
}
