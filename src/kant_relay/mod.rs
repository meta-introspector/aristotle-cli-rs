//! Kant relay module - handles room and pass management

pub mod models;
pub mod service;

// Re-export commonly used types
pub use models::{Pass, RelayConfig, Room};
pub use service::KantRelay;
