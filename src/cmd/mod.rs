//! Command implementations.
//!
//! Each CLI subcommand described by the `Commands` enum in `main.rs` gets its
//! own module here, holding one `pub fn cmd_<name>` (plus any helpers used only
//! by that command). Shared infrastructure lives in `crate::config`, `crate::api`
//! and `crate::util`.

pub mod clean;
pub mod configure;
pub mod results;
