use floem::{views::button, IntoView};
use floem::prelude::*;

fn app_view() -> impl IntoView {
    let mut counter = RwSignal::new(0);
    (
        "Value: ",
        button("Increment"),
        button("Decrement"),
    )
}

fn main() {
    floem::launch(app_view);
}
