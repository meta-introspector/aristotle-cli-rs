use std::collections::HashMap;
use std::sync::Arc;
use tokio::sync::RwLock;
use anyhow::{Result, Context, bail};
use tracing::info;

use crate::kant_relay::models::{Pass, RelayConfig, Room};

/// Compare two pass secrets without leaking their contents through timing.
///
/// Pass secrets are bearer credentials (see KANT_PASTEBIN_CLOUDFLARE_TWIN_SPEC.md),
/// so a plain `==` would let an attacker who can time responses recover the
/// secret a byte at a time. Length is still observable, which is acceptable:
/// secrets are fixed-width UUID-derived strings.
fn secrets_match(candidate: &str, expected: &str) -> bool {
    let (candidate, expected) = (candidate.as_bytes(), expected.as_bytes());
    if candidate.len() != expected.len() {
        return false;
    }
    let mut diff = 0u8;
    for (a, b) in candidate.iter().zip(expected) {
        diff |= a ^ b;
    }
    diff == 0
}

/// The Kant relay service manages rooms and passes
/// for the Kant pastebin Cloudflare twin system.
pub struct KantRelay {
    /// Map of room IDs to Room objects
    rooms: Arc<RwLock<HashMap<String, Room>>>,
    /// Global configuration
    config: Arc<RwLock<RelayConfig>>,
}

impl KantRelay {
    /// Create a new Kant relay service with the given configuration
    pub fn new(config: RelayConfig) -> Self {
        Self {
            rooms: Arc::new(RwLock::new(HashMap::new())),
            config: Arc::new(RwLock::new(config)),
        }
    }
    
    /// Start the relay service (placeholder for HTTP server)
    pub async fn start(&self) -> Result<()> {
        info!("Kant relay service started");
        info!("Kant base URL: {}", self.config.read().await.kant_base_url);
        info!("Relay URL: {}", self.config.read().await.relay_url);
        
        // In a full implementation, this would start an HTTP server
        // For now, we just mark the service as started
        Ok(())
    }
    
    /// Register a new room with the given name
    pub async fn register_room(&self, room_id: String, name: String) -> Result<Room> {
        let room = Room {
            id: room_id.clone(),
            name,
            passes: Vec::new(),
            created_at: chrono::Utc::now().format("%Y-%m-%dT%H:%M:%SZ").to_string(),
        };
        
        self.rooms.write().await.insert(room_id, room.clone());
        info!("Registered room: {}", room.id);
        
        Ok(room)
    }
    
    /// Get a room by ID
    pub async fn get_room(&self, room_id: &str) -> Option<Room> {
        let rooms = self.rooms.read().await;
        rooms.get(room_id).cloned()
    }
    
    /// Add a pass to a room
    pub async fn add_pass(&self, room_id: &str, secret: String, limit: usize) -> Result<Pass> {
        let mut rooms = self.rooms.write().await;
        if let Some(room) = rooms.get_mut(room_id) {
            let pass = Pass {
                id: format!("pass-{}", uuid::Uuid::new_v4()),
                secret,
                limit,
                created_at: chrono::Utc::now().format("%Y-%m-%dT%H:%M:%SZ").to_string(),
            };
            room.passes.push(pass.clone());
            info!("Added pass {} to room {}", pass.id, room_id);
            Ok(pass)
        } else {
            bail!("Room not found: {}", room_id);
        }
    }
    
    /// Remove a room by ID
    pub async fn remove_room(&self, room_id: &str) -> Result<()> {
        let mut rooms = self.rooms.write().await;
        if rooms.remove(room_id).is_some() {
            info!("Removed room: {}", room_id);
            Ok(())
        } else {
            bail!("Room not found: {}", room_id);
        }
    }
    
    /// List all rooms
    pub async fn list_rooms(&self) -> Vec<Room> {
        let rooms = self.rooms.read().await;
        rooms.values().cloned().collect()
    }
    
    /// Validate a pass for a room (atomic consumption)
    pub async fn validate_pass(&self, room_id: &str, pass_secret: &str) -> Result<bool> {
        let mut rooms = self.rooms.write().await;
        if let Some(room) = rooms.get_mut(room_id) {
            for pass in &mut room.passes {
                if secrets_match(pass_secret, &pass.secret) {
                    if pass.limit > 0 {
                        pass.limit -= 1;
                        info!("Validated pass {} for room {}, remaining: {}", pass.id, room_id, pass.limit);
                        return Ok(true);
                    } else {
                        bail!("Pass has been spent (limit reached)");
                    }
                }
            }
            bail!("Pass not found for room {}", room_id);
        } else {
            bail!("Room not found: {}", room_id);
        }
    }
    
    /// Get the configuration
    pub async fn get_config(&self) -> RelayConfig {
        self.config.read().await.clone()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[tokio::test]
    async fn test_relay_creation() {
        let config = RelayConfig::default();
        let relay = KantRelay::new(config);
        
        // Room should not exist initially
        let room = relay.get_room("nonexistent").await;
        assert!(room.is_none());
    }
    
    #[tokio::test]
    async fn test_register_and_get_room() {
        let config = RelayConfig::default();
        let relay = KantRelay::new(config);
        
        // Register a room
        let room = relay.register_room("test-room".to_string(), "Test Room".to_string()).await.unwrap();
        assert_eq!(room.name, "Test Room");
        
        // Get the room
        let retrieved = relay.get_room("test-room").await.unwrap();
        assert_eq!(retrieved.name, "Test Room");
    }
    
    #[tokio::test]
    async fn test_add_pass() {
        let config = RelayConfig::default();
        let relay = KantRelay::new(config);

        // Register a room
        relay.register_room("test-room".to_string(), "Test Room".to_string()).await.unwrap();
        
        // Add a pass
        let pass = relay.add_pass("test-room", "secret-123".to_string(), 5).await.unwrap();
        assert_eq!(pass.limit, 5);
    }

    #[tokio::test]
    async fn test_validate_pass_consumes_limit() {
        let relay = KantRelay::new(RelayConfig::default());
        relay.register_room("r".to_string(), "R".to_string()).await.unwrap();
        relay.add_pass("r", "secret-123".to_string(), 2).await.unwrap();

        assert!(relay.validate_pass("r", "secret-123").await.is_ok());
        assert!(relay.validate_pass("r", "secret-123").await.is_ok());
        // Limit exhausted.
        assert!(relay.validate_pass("r", "secret-123").await.is_err());
    }

    #[tokio::test]
    async fn test_validate_pass_rejects_wrong_secret() {
        let relay = KantRelay::new(RelayConfig::default());
        relay.register_room("r".to_string(), "R".to_string()).await.unwrap();
        relay.add_pass("r", "secret-123".to_string(), 5).await.unwrap();

        assert!(relay.validate_pass("r", "secret-124").await.is_err());
        assert!(relay.validate_pass("r", "").await.is_err());
        assert!(relay.validate_pass("r", "secret-1234").await.is_err());
        // A rejected attempt must not consume the pass.
        assert!(relay.validate_pass("r", "secret-123").await.is_ok());
    }

    #[test]
    fn test_secrets_match() {
        assert!(secrets_match("secret-123", "secret-123"));
        assert!(!secrets_match("secret-123", "secret-124"));
        assert!(!secrets_match("secret-123", "secret-12"));
        assert!(!secrets_match("", "x"));
        assert!(secrets_match("", ""));
    }
}
