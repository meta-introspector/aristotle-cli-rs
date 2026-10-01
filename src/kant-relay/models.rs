use serde::{Deserialize, Serialize};

/// A Kant pass represents a one-time access token for a Kant pastebin room
#[derive(Serialize, Deserialize)]
pub struct Pass {
    pub id: String,
    pub secret: String,
    pub limit: usize,
    pub created_at: String,
}

/// A Kant room contains a set of passes for its members
#[derive(Serialize, Deserialize)]
pub struct Room {
    pub id: String,
    pub name: String,
    pub passes: Vec<Pass>,
    pub created_at: String,
}

/// Configuration for the Kant relay service
#[derive(Serialize, Deserialize)]
pub struct RelayConfig {
    pub kant_base_url: String,
    pub relay_url: String,
    pub pass_limit: usize,
}
