use std::sync::Arc;
use tokio::sync::RwLock;

/// The Kant relay service maintains a collection of rooms and passes
/// and provides APIs for managing them.
pub struct KantRelay {
    /// Map of room IDs to Room objects
    rooms: RwLock<HashMap<String, Room>>,
    /// Global configuration
    config: RwLock<RelayConfig>,
}

impl KantRelay {
    pub fn new(config: RelayConfig) -> Self {
        Self {
            rooms: RwLock::new(std::collections::HashMap::new()),
            config: RwLock::new(config),
        }
    }

    /// Register a new room
    pub async fn register_room(&self, room_id: String, name: String) -> Result<Room> {
        let room = Room {
            id: room_id,
            name,
            passes: vec![],
            created_at: format!("2026-05-07T00:00:00Z"),
        };
        self.rooms.write().await.insert(room_id, room);
        Ok(room)
    }

    /// Get a room by ID
    pub async fn get_room(&self, room_id: &str) -> Option<Room> {
        self.rooms.read().await.get(room_id).cloned()
    }

    /// Add a pass to a room
    pub async fn add_pass(&self, room_id: &str, secret: String, limit: usize) -> Result<()> {
        let room = self.rooms.write().await.get(room_id).cloned();
        if let Some(room) = room {
            room.passes.push(Pass {
                id: "pass-".to_string(),
                secret,
                limit,
                created_at: format!("2026-05-07T00:00:00Z"),
            });
            Ok(())
        } else {
            return Err("Room not found".to_string());
        }
    }

    /// Remove a room
    pub async fn remove_room(&self, room_id: &str) -> Result<()> {
        self.rooms.write().await.remove(room_id);
        Ok(())
    }

    /// Get all rooms
    pub async fn list_rooms(&self) -> Vec<Room> {
        self.rooms.read().await.values().copied().collect()
    }
}
