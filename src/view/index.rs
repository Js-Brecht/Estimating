use dioxus::prelude::*;


#[derive(Routable, Clone, PartialEq, Debug)]
#[rustfmt::skip]
pub enum Route {
    #[layout(AppSidebar)]
        #[route("/")]
        Home {},
        #[route("/jobs")]
        Jobs {},
    #[end_layout]
    #[route("/..route")]
    NotFound {
        route: Vec<String>,
    }
}

#[component]
pub fn AppSidebar() -> Element {
    return rsx! {
        body {
            Link {
                to: Route::Home {},
                "Home"
            }
            Link {
                to: Route::Jobs {},
                "Jobs"
            }

            Outlet::<Route> {}
        }
    }
}

#[component]
pub fn Home() -> Element {
    return rsx! {
        p { "Hello, World!" }
    }
}

#[component]
pub fn Jobs() -> Element {
    rsx! {
        p { "Here be jobs" }
    }
}

#[component]
pub fn NotFound(route: Vec<String>) -> Element {
    rsx! {

    }
}
