
#[tokio::main]
async fn main() {
    estimating::launch().await.expect("Application failed to launch!");
}
