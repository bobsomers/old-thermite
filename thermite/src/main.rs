extern crate thermite;
extern crate native;

use thermite::glfw;

fn main() {
    let glfw = glfw::init().expect("Failed to initialize GLFW");
    println!("Yay!")
}
