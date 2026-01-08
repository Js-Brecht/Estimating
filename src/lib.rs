use floem::prelude::*;
use floem::{views::button, IntoView};

fn app_view() -> impl IntoView {
    let mut counter = RwSignal::new(0);
    ("Value: ", button("Increment"), button("Decrement"))
}

pub fn launch_app() {
    floem::launch(app_view);
}
