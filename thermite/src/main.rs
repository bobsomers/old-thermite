extern crate thermite;
extern crate native;

use thermite::glfw;

fn main() {
    let result = glfw::init();
    println!("GLFW initialized: {}", result)
}
