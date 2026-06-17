---
name: "rust-async"
description: "Production patterns for async Rust with Tokio: tasks, channels, streams, error handling, graceful shutdown. Enforces TigerBeetle coding standard: typed errors, assertion density ≥2, no unwrap in production paths. Use when building async Rust services, implementing concurrent systems, or debugging async code."
---

# Rust Async Patterns — TigerBeetle-Aligned

Production patterns for async Rust with Tokio. All code follows the
TigerBeetle coding standard from `agent/prompts/tigerbeetle.md`:
typed errors (never strings), assertion density ≥ 2, no `.unwrap()`
in production paths, units in variable names.

---

## When to Use

- Building async Rust applications
- Implementing concurrent network services
- Using Tokio for async I/O
- Handling async errors properly
- Debugging async code issues

## Core Model

```
Future (lazy) → poll() → Ready(value) | Pending
                ↑           ↓
              Waker ← Runtime schedules
```

| Concept    | Purpose                                  |
| ---------- | ---------------------------------------- |
| `Future`   | Lazy computation that may complete later |
| `async fn` | Function returning impl Future           |
| `await`    | Suspend until future completes           |
| `Task`     | Spawned future running concurrently      |
| `Runtime`  | Executor that polls futures              |

## Quick Start

```toml
# Cargo.toml
[dependencies]
tokio = { version = "1", features = ["full"] }
futures = "0.3"
async-trait = "0.1"
thiserror = "2"       # Typed errors — never anyhow for library code
tracing = "0.1"
tracing-subscriber = "0.3"
```

```rust
use tokio::time::{sleep, Duration};
use std::assert;

#[tokio::main]
async fn main() -> Result<(), ServiceError> {
    tracing_subscriber::fmt().init();

    let result = fetch_data("https://api.example.com").await?;
    assert!(!result.is_empty(), "fetch_data returned empty");
    tracing::info!(bytes = result.len(), "fetched data");

    Ok(())
}
```

## Pattern 1: Concurrent Task Execution

```rust
use tokio::task::JoinSet;

/// Fetch all URLs concurrently with bounded parallelism.
/// Returns all successful results; logs failures.
async fn fetch_all_concurrent(urls: Vec<String>, max_concurrent: usize) -> Result<Vec<String>, ServiceError> {
    assert!(!urls.is_empty(), "urls must not be empty");
    assert!(max_concurrent > 0, "max_concurrent must be > 0");

    let mut set = JoinSet::new();

    for url in urls {
        set.spawn(async move { fetch_data(&url).await });
    }

    let mut results = Vec::with_capacity(set.len());
    while let Some(res) = set.join_next().await {
        match res {
            Ok(Ok(data)) => results.push(data),
            Ok(Err(e)) => tracing::error!(error = %e, "task failed"),
            Err(e) => tracing::error!(error = %e, "join error"),
        }
    }

    Ok(results)
}

// With concurrency limit via semaphore
use futures::stream::{self, StreamExt};
use tokio::sync::Semaphore;

async fn fetch_with_limit(urls: Vec<String>, limit: usize) -> Vec<Result<String, ServiceError>> {
    assert!(limit > 0, "limit must be > 0");
    let semaphore = Arc::new(Semaphore::new(limit));

    stream::iter(urls)
        .map(|url| {
            let sem = semaphore.clone();
            async move {
                let _permit = sem.acquire().await.assert("semaphore acquire");
                fetch_data(&url).await
            }
        })
        .buffer_unordered(limit)
        .collect()
        .await
}

// Select first to complete
use tokio::select;

async fn race_requests(url1: &str, url2: &str) -> Result<String, ServiceError> {
    select! {
        result = fetch_data(url1) => result,
        result = fetch_data(url2) => result,
    }
}
```

## Pattern 2: Channels for Communication

```rust
use tokio::sync::{mpsc, broadcast, oneshot, watch};

// Multi-producer, single-consumer
async fn mpsc_example() {
    let (tx, mut rx) = mpsc::channel::<String>(100);

    let tx2 = tx.clone();
    tokio::spawn(async move {
        tx2.send("Hello".to_string()).await.assert("mpsc send");
    });

    while let Some(msg) = rx.recv().await {
        tracing::info!(msg = %msg, "received");
    }
}

// Oneshot: single value, single use
async fn oneshot_example() -> String {
    let (tx, rx) = oneshot::channel::<String>();

    tokio::spawn(async move {
        tx.send("Result".to_string()).assert("oneshot send");
    });

    rx.await.assert("oneshot recv")
}

// Watch: single producer, multi-consumer, latest value
async fn watch_example() {
    let (tx, mut rx) = watch::channel("initial".to_string());

    tokio::spawn(async move {
        loop {
            rx.changed().await.assert("watch changed");
            tracing::info!(value = %*rx.borrow(), "new value");
        }
    });

    tx.send("updated".to_string()).assert("watch send");
}
```

## Pattern 3: Typed Error Handling

TigerBeetle rule: **typed errors, not strings.** Never return
`Result<(), &str>` or use anyhow in library code.

```rust
use thiserror::Error;

#[derive(Error, Debug)]
pub enum ServiceError {
    #[error("Network error: {0}")]
    Network(#[from] reqwest::Error),

    #[error("Database error: {0}")]
    Database(#[from] sqlx::Error),

    #[error("Not found: {0}")]
    NotFound(String),

    #[error("Timeout after {timeout_ms}ms")]
    Timeout { timeout_ms: u64 },
}

// Application code: use typed errors with context
async fn process_request(id: &str) -> Result<Response, ServiceError> {
    let data = fetch_data(id).await?;

    assert!(!data.is_empty(), "process_request: empty response for {id}");

    let parsed = parse_response(&data)?;
    Ok(parsed)
}

// Timeout wrapper
use tokio::time::timeout;

async fn with_timeout<T, F>(timeout_ms: u64, future: F) -> Result<T, ServiceError>
where
    F: std::future::Future<Output = Result<T, ServiceError>>,
{
    assert!(timeout_ms > 0, "timeout_ms must be > 0");

    timeout(Duration::from_millis(timeout_ms), future)
        .await
        .map_err(|_| ServiceError::Timeout { timeout_ms })?
}
```

## Pattern 4: Graceful Shutdown

```rust
use tokio::signal;
use tokio_util::sync::CancellationToken;

async fn run_server() -> Result<(), ServiceError> {
    let token = CancellationToken::new();
    let token_clone = token.clone();

    tokio::spawn(async move {
        loop {
            tokio::select! {
                _ = token_clone.cancelled() => {
                    tracing::info!("task shutting down");
                    break;
                }
                _ = do_work() => {}
            }
        }
    });

    signal::ctrl_c().await?;
    tracing::info!("shutdown signal received");
    token.cancel();

    // Give tasks time to cleanup
    tokio::time::sleep(Duration::from_secs(5)).await;

    Ok(())
}
```

## Pattern 5: Async Traits

```rust
use async_trait::async_trait;

#[async_trait]
pub trait Repository: Send + Sync {
    async fn get(&self, id: &str) -> Result<Entity, ServiceError>;
    async fn save(&self, entity: &Entity) -> Result<(), ServiceError>;
    async fn delete(&self, id: &str) -> Result<(), ServiceError>;
}

pub struct PostgresRepository {
    pool: sqlx::PgPool,
}

#[async_trait]
impl Repository for PostgresRepository {
    async fn get(&self, id: &str) -> Result<Entity, ServiceError> {
        assert!(!id.is_empty(), "id must not be empty");

        sqlx::query_as!(Entity, "SELECT * FROM entities WHERE id = $1", id)
            .fetch_one(&self.pool)
            .await
            .map_err(ServiceError::from)
    }

    async fn save(&self, entity: &Entity) -> Result<(), ServiceError> {
        assert!(!entity.id.is_empty(), "entity id must not be empty");

        sqlx::query!(
            "INSERT INTO entities (id, data) VALUES ($1, $2)
             ON CONFLICT (id) DO UPDATE SET data = $2",
            entity.id,
            entity.data
        )
        .execute(&self.pool)
        .await?;

        Ok(())
    }

    async fn delete(&self, id: &str) -> Result<(), ServiceError> {
        assert!(!id.is_empty(), "id must not be empty");

        sqlx::query!("DELETE FROM entities WHERE id = $1", id)
            .execute(&self.pool)
            .await?;

        Ok(())
    }
}
```

## Pattern 6: Streams and Async Iteration

```rust
use futures::stream::{self, Stream, StreamExt};
use async_stream::stream;

fn numbers_stream(count: usize) -> impl Stream<Item = i32> {
    assert!(count > 0, "count must be > 0");

    stream! {
        for i in 0..count {
            tokio::time::sleep(Duration::from_millis(100)).await;
            yield i;
        }
    }
}

// Chunked processing
async fn process_in_chunks(chunk_size: usize) {
    assert!(chunk_size > 0, "chunk_size must be > 0");

    let stream = numbers_stream(10);
    let mut chunks = stream.chunks(chunk_size);

    while let Some(chunk) = chunks.next().await {
        tracing::info!(len = chunk.len(), "processing chunk");
    }
}
```

## Pattern 7: Resource Management

```rust
use std::sync::Arc;
use tokio::sync::{Mutex, RwLock, Semaphore};

// Shared state with RwLock (prefer for read-heavy)
struct Cache {
    data: RwLock<HashMap<String, String>>,
}

impl Cache {
    async fn get(&self, key: &str) -> Option<String> {
        self.data.read().await.get(key).cloned()
    }

    async fn set(&self, key: String, value: String) {
        self.data.write().await.insert(key, value);
    }
}

// Connection pool with semaphore
struct Pool {
    max_connections: usize,
    semaphore: Semaphore,
    connections: Mutex<Vec<Connection>>,
}

impl Pool {
    fn new(pool_size: usize) -> Self {
        assert!(pool_size > 0, "pool_size must be > 0");

        Self {
            max_connections: pool_size,
            semaphore: Semaphore::new(pool_size),
            connections: Mutex::new(
                (0..pool_size).map(|_| Connection::new()).collect()
            ),
        }
    }

    async fn acquire(&self) -> Result<PooledConnection<'_>, ServiceError> {
        let permit = self.semaphore.acquire().await
            .map_err(|_| ServiceError::Timeout { timeout_ms: 5000 })?;

        let conn = self.connections.lock().await.pop()
            .assert("pool: no connection available");

        Ok(PooledConnection { pool: self, conn: Some(conn), _permit: permit })
    }
}
```

## Debugging

```rust
// Enable tokio-console for runtime debugging
// Cargo.toml: tokio = { features = ["tracing"] }
// Run: RUSTFLAGS="--cfg tokio_unstable" cargo run
// Then: tokio-console

// Instrument async functions
use tracing::instrument;

#[instrument(skip(pool), fields(id = %id))]
async fn fetch_user(pool: &PgPool, id: &str) -> Result<User, ServiceError> {
    tracing::debug!("fetching user");
    // ...
}

// Track task spawning
let span = tracing::info_span!("worker", id = %worker_id);
tokio::spawn(async move {
    // ...
}.instrument(span));
```

## TigerBeetle Checklist

Before committing async Rust code, verify:

- [ ] Typed errors (thiserror), not strings or anyhow in library code
- [ ] Assertion density ≥ 2 per function (preconditions + postconditions)
- [ ] No `.unwrap()` in production paths — use `.assert()` for invariant violations only
- [ ] Units in variable names: `timeout_ms`, `max_concurrent`, `pool_size`
- [ ] Function length ≤ 70 lines
- [ ] No `// TODO` or `// FIXME` — ship it clean
- [ ] Graceful shutdown handled (CancellationToken or broadcast)

## Guardrails

- Never use `std::thread::sleep` in async code — use `tokio::time::sleep`
- Never hold locks across `.await` points — causes deadlocks
- Never spawn unboundedly — use semaphores for limits
- Never ignore errors — propagate with `?` or log
- Never forget `Send` bounds for spawned futures
- `.assert()` is for invariant violations (programmer error), not runtime data

## Related

- `agent/prompts/tigerbeetle.md` — the full coding standard
- `nix-build` — for building Rust projects via nix flakes
- `librarian` — for researching Tokio/async crate internals
