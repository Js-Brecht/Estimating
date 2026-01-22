fn main() {
    println!("cargo:rerun-if-changed=migrations");
    slint_build::compile("src/view/main.slint").expect("Slint compilation failed for `main.slint`");
}
