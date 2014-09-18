#[cfg(target_os = "linux")]
#[link(name = "glfw")]
extern {}

#[cfg(target_os = "macos")]
#[link(name = "glfw3")]
extern {}
