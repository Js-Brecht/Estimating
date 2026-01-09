use floem::IntoView;
use floem::prelude::*;
use floem::views::{Decorators, button, dyn_view};

fn app_view() -> impl IntoView {
    let mut counter = RwSignal::new(0);
    (
        dyn_view(move || format!("Value: {}", counter)),
        (
            button("Increment").action(move || counter += 1),
            button("Decrement").action(move || counter -= 1),
        )
            .style(|s| s.flex_row().gap(6)),
    )
        .style(|s| s.flex_col().gap(6).items_center())
}

pub fn launch_app() {
    floem::launch(app_view);
}
