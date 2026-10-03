use serde::{Deserialize, Serialize};

/// A Kant pass represents a one-time access token for a Kant pastebin room
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Pass {
    /// Unique identifier for the pass
    pub id: String,
    /// Secret used for verification
    pub secret: String,
    /// Maximum number of posts allowed with this pass
    pub limit: usize,
    /// ISO 8601 timestamp of creation
    pub created_at: String,
}

/// A Kant room contains a set of passes for its members
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Room {
    /// Unique identifier for the room
    pub id: String,
    /// Human-readable name for the room
    pub name: String,
    /// List of passes associated with this room
    pub passes: Vec<Pass>,
    /// ISO 8601 timestamp of creation
    pub created_at: String,
}

/// Configuration for the Kant relay service
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RelayConfig {
    /// Base URL for the Kant pastebin (public static site)
    pub kant_base_url: String,
    /// URL for the Kant relay service
    pub relay_url: String,
    /// Default pass limit when not specified
    pub pass_limit: usize,
}

impl Default for RelayConfig {
    fn default() -> Self {
        Self {
            kant_base_url: "https://kant-zk-pastebin.pages.dev".to_string(),
            relay_url: "https://kant-zk-relay.jmikedupont2.workers.dev".to_string(),
            pass_limit: 100,
        }
    }
}
