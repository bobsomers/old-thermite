extern crate thermite;

use thermite::glfw;

fn main() {
    let result = glfw::init();
    println!("GLFW initialized: {}", result)
}
