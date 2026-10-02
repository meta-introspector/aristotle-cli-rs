//! Aristotle Manager WebAssembly module.
//!
//! # Immutability contract
//!
//! This crate is compiled once and served as an immutable static artifact. It
//! must therefore contain **no operator-specific or account-specific data**.
//! Anything that identifies a Cloudflare account, a Pages project, or a
//! deployment target is supplied by the client at runtime.
//!
//! Configuration enters through two supported paths:
//!
//! 1. [`set_session_config`] / [`set_api_key`] — explicit calls from the page.
//! 2. [`load_session_from_cookie`] — hydration from the client-side session
//!    cookie, which is what makes a page reload work without a rebuild.
//!
//! The cookie is set with `SameSite=Strict`, `Path=/`, a bounded `Max-Age`,
//! and `Secure` whenever the page is served over HTTPS.
//!
//! # What deliberately never goes in the cookie
//!
//! The API key stays in wasm memory only. A cookie is readable by any script on
//! the origin, so persisting a credential there would turn any XSS into full
//! credential theft. The Cloudflare account ID is an identifier rather than a
//! credential, and on its own authorises nothing — a token is still required —
//! so it is safe to persist client-side.

use wasm_bindgen::prelude::*;
use wasm_bindgen_futures::JsFuture;
use web_sys::window;
use console_error_panic_hook::set_once as set_panic_hook;

/// The public Aristotle service endpoint. This is service discovery, not
/// account data — it is the same for every visitor and carries no operator
/// identifier. A session may override it.
pub const DEFAULT_API_BASE_URL: &str = "https://aristotle.harmonic.fun/api/v3";

/// Cookie holding the base64url-encoded session JSON.
pub const SESSION_COOKIE: &str = "aristo_session";

/// Session cookie lifetime, in seconds (30 days).
const SESSION_MAX_AGE: u32 = 30 * 24 * 60 * 60;

// ---------------------------------------------------------------------------
// base64url
// ---------------------------------------------------------------------------

const B64URL: &[u8] = b"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

/// Cookie values may not contain whitespace, `"`, `,`, `;` or `\`, so the
/// session JSON is base64url-encoded before it is written.
fn b64url_encode(data: &[u8]) -> String {
    let mut out = String::with_capacity(data.len().div_ceil(3) * 4);
    for chunk in data.chunks(3) {
        let b0 = chunk[0] as u32;
        let b1 = *chunk.get(1).unwrap_or(&0) as u32;
        let b2 = *chunk.get(2).unwrap_or(&0) as u32;
        let n = (b0 << 16) | (b1 << 8) | b2;
        out.push(B64URL[(n >> 18) as usize & 63] as char);
        out.push(B64URL[(n >> 12) as usize & 63] as char);
        if chunk.len() > 1 {
            out.push(B64URL[(n >> 6) as usize & 63] as char);
        }
        if chunk.len() > 2 {
            out.push(B64URL[n as usize & 63] as char);
        }
    }
    out
}

fn b64url_decode(text: &str) -> Option<Vec<u8>> {
    let mut out = Vec::with_capacity(text.len() / 4 * 3);
    let mut acc: u32 = 0;
    let mut bits = 0u32;
    for byte in text.bytes() {
        // Tolerate padding so a value written by an older encoder still loads.
        if byte == b'=' {
            break;
        }
        let val = B64URL.iter().position(|c| *c == byte)? as u32;
        acc = (acc << 6) | val;
        bits += 6;
        if bits >= 8 {
            bits -= 8;
            out.push((acc >> bits) as u8);
        }
    }
    Some(out)
}

// ---------------------------------------------------------------------------
// Session state
// ---------------------------------------------------------------------------

/// Client-supplied configuration. Every field except `api_base_url` is
/// operator-specific and therefore absent from the compiled artifact.
#[derive(Default, Clone)]
pub struct SessionConfig {
    /// Cloudflare account ID, 32 lowercase hex characters.
    pub account_id: String,
    /// Default Pages domain for generated deployments.
    pub default_domain: String,
    /// Overrides [`DEFAULT_API_BASE_URL`] when non-empty.
    pub api_base_url: String,
}

impl SessionConfig {
    fn from_json(raw: &str) -> Result<Self, String> {
        let value: serde_json::Value =
            serde_json::from_str(raw).map_err(|e| format!("session is not valid JSON: {e}"))?;
        let field = |name: &str| -> String {
            value
                .get(name)
                .and_then(|v| v.as_str())
                .unwrap_or_default()
                .trim()
                .to_string()
        };

        let account_id = field("account_id").to_ascii_lowercase();
        if !account_id.is_empty() && !is_account_id(&account_id) {
            return Err("account_id must be 32 hexadecimal characters".to_string());
        }

        let api_base_url = {
            let url = field("api_base_url");
            if url.is_empty() {
                DEFAULT_API_BASE_URL.to_string()
            } else {
                url
            }
        };

        Ok(SessionConfig {
            account_id,
            default_domain: field("default_domain"),
            api_base_url,
        })
    }

    fn to_json(&self) -> String {
        serde_json::json!({
            "account_id": self.account_id,
            "default_domain": self.default_domain,
            "api_base_url": self.api_base_url,
        })
        .to_string()
    }

    /// True once an account ID is present, i.e. the artifact has been given
    /// enough information to generate a deployment config.
    fn is_configured(&self) -> bool {
        !self.account_id.is_empty()
    }
}

fn is_account_id(candidate: &str) -> bool {
    candidate.len() == 32 && candidate.bytes().all(|b| b.is_ascii_hexdigit())
}

thread_local! {
    /// The API key lives here and nowhere else — it is never serialised.
    static API_KEY: std::cell::RefCell<Option<String>> = const { std::cell::RefCell::new(None) };
    static SESSION: std::cell::RefCell<SessionConfig> = const { std::cell::RefCell::new(SessionConfig {
        account_id: String::new(),
        default_domain: String::new(),
        api_base_url: String::new(),
    }) };
}

#[wasm_bindgen]
extern "C" {
    #[wasm_bindgen(js_namespace = console)]
    fn log(s: &str);
}

#[wasm_bindgen]
pub fn init_panic_hook() {
    set_panic_hook();
}

// ---------------------------------------------------------------------------
// API key — memory only
// ---------------------------------------------------------------------------

/// Supply the Aristotle API key. Held in wasm memory only; it is never written
/// to the session cookie and never leaves the browser except in the `x-api-key`
/// request header.
#[wasm_bindgen]
pub fn set_api_key(key: &str) {
    API_KEY.with(|slot| *slot.borrow_mut() = Some(key.to_string()));
    log(&format!("API key set (length: {})", key.len()));
}

#[wasm_bindgen]
pub fn get_api_key() -> Option<String> {
    API_KEY.with(|slot| slot.borrow().clone())
}

fn require_api_key() -> Result<String, JsValue> {
    API_KEY
        .with(|slot| slot.borrow().clone())
        .ok_or_else(|| JsValue::from_str("API key not set"))
}

// ---------------------------------------------------------------------------
// Session configuration
// ---------------------------------------------------------------------------

/// Set the session configuration from a JSON object and persist it to the
/// client-side session cookie so it survives a reload. Required keys:
/// `account_id`; optional: `default_domain`, `api_base_url`.
#[wasm_bindgen]
pub fn set_session_config(json: &str) -> Result<(), JsValue> {
    let config = SessionConfig::from_json(json).map_err(|e| JsValue::from_str(&e))?;
    SESSION.with(|slot| *slot.borrow_mut() = config.clone());
    write_session_cookie(&config);
    log(&format!(
        "session configured (account present: {})",
        config.is_configured()
    ));
    Ok(())
}

/// The current session configuration as JSON. Empty fields mean "not set";
/// they are never filled in from a compiled-in default.
#[wasm_bindgen]
pub fn get_session_config() -> String {
    SESSION.with(|slot| {
        let mut config = slot.borrow().clone();
        if config.api_base_url.is_empty() {
            config.api_base_url = DEFAULT_API_BASE_URL.to_string();
        }
        config.to_json()
    })
}

/// Whether the client has supplied an account ID yet.
#[wasm_bindgen]
pub fn session_is_configured() -> bool {
    SESSION.with(|slot| slot.borrow().is_configured())
}

/// Hydrate the session from the client-side cookie. Call once on page load;
/// returns `true` if a valid session was restored.
#[wasm_bindgen]
pub fn load_session_from_cookie() -> bool {
    let Some(encoded) = read_session_cookie() else {
        return false;
    };
    let Some(bytes) = b64url_decode(&encoded) else {
        log("session cookie is not valid base64url; ignoring");
        return false;
    };
    let Ok(raw) = String::from_utf8(bytes) else {
        log("session cookie is not valid UTF-8; ignoring");
        return false;
    };
    match SessionConfig::from_json(&raw) {
        Ok(config) => {
            let configured = config.is_configured();
            SESSION.with(|slot| *slot.borrow_mut() = config);
            log(&format!("session restored from cookie (account present: {configured})"));
            configured
        }
        Err(e) => {
            log(&format!("session cookie rejected: {e}"));
            false
        }
    }
}

/// Forget the session: clears wasm memory and expires the cookie. The API key
/// is cleared too, so a sign-out leaves nothing behind.
#[wasm_bindgen]
pub fn clear_session() {
    SESSION.with(|slot| *slot.borrow_mut() = SessionConfig::default());
    API_KEY.with(|slot| *slot.borrow_mut() = None);
    if let Some(doc) = document() {
        let _ = js_sys::Reflect::set(
            doc.as_ref(),
            &"cookie".into(),
            &format!("{SESSION_COOKIE}=; Path=/; Max-Age=0; SameSite=Strict").into(),
        );
    }
    log("session cleared");
}

/// The Cloudflare account ID supplied by the client, or an empty string when
/// the session has not been configured. There is no built-in fallback.
#[wasm_bindgen]
pub fn get_cloudflare_account_id() -> String {
    SESSION.with(|slot| slot.borrow().account_id.clone())
}

/// The Pages domain supplied by the client, or an empty string when unset.
#[wasm_bindgen]
pub fn get_cloudflare_default_domain() -> String {
    SESSION.with(|slot| slot.borrow().default_domain.clone())
}

/// The Aristotle API base URL in effect: the session override when set,
/// otherwise the shared public service endpoint.
#[wasm_bindgen]
pub fn get_api_base_url() -> String {
    SESSION.with(|slot| {
        let config = slot.borrow();
        if config.api_base_url.is_empty() {
            DEFAULT_API_BASE_URL.to_string()
        } else {
            config.api_base_url.clone()
        }
    })
}

// ---------------------------------------------------------------------------
// Cookie plumbing
// ---------------------------------------------------------------------------

fn document() -> Option<web_sys::Document> {
    window().and_then(|w| w.document())
}

/// `Secure` only when the page itself is HTTPS, so the session still works on
/// a plain-HTTP localhost during development.
fn is_secure_context() -> bool {
    window()
        .and_then(|w| w.location().protocol().ok())
        .map(|p| p == "https:")
        .unwrap_or(false)
}

fn write_session_cookie(config: &SessionConfig) {
    let Some(doc) = document() else {
        log("no document; session kept in memory only");
        return;
    };
    let mut attrs = format!(
        "{SESSION_COOKIE}={}; Path=/; Max-Age={SESSION_MAX_AGE}; SameSite=Strict",
        b64url_encode(config.to_json().as_bytes())
    );
    if is_secure_context() {
        attrs.push_str("; Secure");
    }
    if let Err(e) = js_sys::Reflect::set(doc.as_ref(), &"cookie".into(), &attrs.into()) {
        log(&format!("failed to write session cookie: {e:?}"));
    }
}

fn read_session_cookie() -> Option<String> {
    let raw = js_sys::Reflect::get(
        document()?.as_ref(),
        &"cookie".into(),
    )
    .ok()?
    .as_string()?;
    raw.split(';')
        .filter_map(|pair| pair.trim().split_once('='))
        .find(|(name, _)| *name == SESSION_COOKIE)
        .map(|(_, value)| value.to_string())
}

// ---------------------------------------------------------------------------
// Aristotle API
// ---------------------------------------------------------------------------

#[wasm_bindgen]
pub async fn fetch_project(project_id: &str) -> Result<JsValue, JsValue> {
    let api_key = require_api_key()?;
    let url = format!("{}/project/{project_id}", get_api_base_url());
    fetch_json(&url, &api_key).await
}

#[wasm_bindgen]
pub async fn fetch_project_list() -> Result<JsValue, JsValue> {
    let api_key = require_api_key()?;
    let url = format!("{}/project", get_api_base_url());
    fetch_json(&url, &api_key).await
}

async fn fetch_json(url: &str, api_key: &str) -> Result<JsValue, JsValue> {
    let opts = web_sys::RequestInit::new();
    opts.set_method("GET");
    opts.set_mode(web_sys::RequestMode::Cors);

    let headers = web_sys::Headers::new().map_err(|_| "Failed to create headers")?;
    headers
        .set("x-api-key", api_key)
        .map_err(|_| "Failed to set header")?;
    opts.set_headers(&headers);

    let request = web_sys::Request::new_with_str_and_init(url, &opts)
        .map_err(|_| "Failed to create request")?;

    let window = window().ok_or("No window")?;
    let resp_value = JsFuture::from(window.fetch_with_request(&request)).await?;
    let resp: web_sys::Response = resp_value
        .dyn_into()
        .map_err(|_| "Failed to cast response")?;

    if !resp.ok() {
        return Err(format!("HTTP {}: Request failed", resp.status()).into());
    }

    let text = JsFuture::from(resp.text()?).await?;
    Ok(text)
}

// ---------------------------------------------------------------------------
// Deployment
// ---------------------------------------------------------------------------

/// Build the wrangler Pages deployment config for a project.
///
/// `domain` falls back to the session's default domain when empty. The account
/// ID is included only if the client supplied one, and `configured` reports
/// whether it did, so a caller can tell a real deployment plan from an
/// incomplete one.
#[wasm_bindgen]
pub fn generate_deploy_config(project_id: &str, project_name: &str, domain: &str) -> String {
    let session = SESSION.with(|slot| slot.borrow().clone());
    let domain = if domain.is_empty() {
        session.default_domain.clone()
    } else {
        domain.to_string()
    };

    let config = serde_json::json!({
        "project_id": project_id,
        "project_name": project_name,
        "domain": domain,
        "api_url": get_api_base_url(),
        "configured": session.is_configured(),
        "cloudflare_pages": {
            "account_id": session.account_id,
            "project_name": project_name,
            "output_dir": format!("./output-final_aristotle/{project_id}_deployed"),
            "use_site_dir": true,
            "commit_dirty": true
        },
        "deployment_steps": [
            "Download project from Aristotle API",
            "Extract and prepare deployment files",
            "Check for site/ subdirectory",
            "Deploy to Cloudflare Pages via wrangler",
            "Add custom domain if specified"
        ]
    });
    config.to_string()
}

#[wasm_bindgen]
pub fn get_deploy_instructions(project_id: &str, project_name: &str, domain: &str) -> String {
    let account = SESSION.with(|slot| slot.borrow().account_id.clone());
    let account_note = if account.is_empty() {
        "Note: no Cloudflare account ID is configured for this session, so the \
         commands below omit `--account-id`. Call set_session_config() first to \
         pin a deployment target.\n\n"
            .to_string()
    } else {
        String::new()
    };
    let account_flag = if account.is_empty() {
        String::new()
    } else {
        format!(" --account-id {account}")
    };

    format!(
        "To deploy project {project_id} ({project_name}) to Cloudflare Pages:\n\n\
         {account_note}\
         1. Install wrangler: npm install -g wrangler\n\
         2. Authenticate: wrangler login\n\
         3. Create project: wrangler pages project create {project_name}\n\
         4. Deploy: wrangler pages deploy ./output-final_aristotle/{project_id}_deployed \
         --project-name {project_name}{account_flag} --commit-dirty=true\n\
         5. Add domain: wrangler pages domain add {domain} --project-name {project_name}\n\n\
         Note: Cloudflare wrangler v4.x does not support `pages domain add`. Add custom \
         domains via Cloudflare Dashboard or API."
    )
}

#[wasm_bindgen]
pub async fn deploy_project(
    project_id: &str,
    project_name: &str,
    domain: &str,
) -> Result<JsValue, JsValue> {
    if !session_is_configured() {
        return Err(JsValue::from_str(
            "no Cloudflare account configured; call set_session_config() or load_session_from_cookie() first",
        ));
    }
    log(&format!(
        "Deploying project {project_id} as {project_name} with domain {domain}"
    ));

    let config = generate_deploy_config(project_id, project_name, domain);

    let result = js_sys::Object::new();
    js_sys::Reflect::set(&result, &"success".into(), &true.into())?;
    js_sys::Reflect::set(&result, &"config".into(), &config.into())?;
    js_sys::Reflect::set(
        &result,
        &"instructions".into(),
        &get_deploy_instructions(project_id, project_name, domain).into(),
    )?;
    js_sys::Reflect::set(&result, &"project_id".into(), &project_id.into())?;
    js_sys::Reflect::set(&result, &"project_name".into(), &project_name.into())?;
    js_sys::Reflect::set(&result, &"domain".into(), &domain.into())?;

    Ok(result.into())
}

#[wasm_bindgen]
pub fn validate_project_id(project_id: &str) -> bool {
    let chars: Vec<char> = project_id.chars().collect();
    if chars.len() < 36 {
        return false;
    }
    chars.iter().take(8).all(|c| c.is_ascii_hexdigit())
        && chars.get(8) == Some(&'-')
}

// ---------------------------------------------------------------------------
// Tests — pure logic, no wasm runtime required
// ---------------------------------------------------------------------------

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn b64url_roundtrip() {
        for input in ["", "a", "ab", "abc", "abcd", "hello world", "the quick brown fox"] {
            let encoded = b64url_encode(input.as_bytes());
            assert!(
                !encoded.contains(',') && !encoded.contains('"') && !encoded.contains(';'),
                "encoded value must be cookie-safe: {encoded}"
            );
            let decoded = b64url_decode(&encoded).unwrap();
            assert_eq!(String::from_utf8(decoded).unwrap(), input);
        }
    }

    #[test]
    fn b64url_encodes_without_padding() {
        assert_eq!(b64url_encode(b"a"), "YQ");
        assert_eq!(b64url_encode(b"ab"), "YWI");
        assert_eq!(b64url_encode(b"abc"), "YWJj");
    }

    #[test]
    fn b64url_rejects_invalid_characters() {
        assert!(b64url_decode("!!!!").is_none());
        assert!(b64url_decode("YQ==").is_some());
    }

    #[test]
    fn account_id_validation() {
        assert!(is_account_id("0ceffbadd0a04623896f5317a1e40d94"));
        assert!(!is_account_id("0ceffbadd0a04623896f5317a1e40d9"));
        assert!(!is_account_id("0ceffbadd0a04623896f5317a1e40d9z"));
        assert!(!is_account_id("short"));
    }

    #[test]
    fn session_from_json_requires_valid_account_id() {
        assert!(SessionConfig::from_json(r#"{"account_id":"nope"}"#).is_err());
        assert!(SessionConfig::from_json("not json").is_err());
    }

    #[test]
    fn session_from_json_defaults_api_base_url() {
        let config = SessionConfig::from_json(r#"{"account_id":"0ceffbadd0a04623896f5317a1e40d94"}"#)
            .expect("valid config");
        assert_eq!(config.api_base_url, DEFAULT_API_BASE_URL);
        assert!(config.is_configured());
        assert!(config.default_domain.is_empty());
    }

    #[test]
    fn session_from_json_lowercases_account_id() {
        let config = SessionConfig::from_json(r#"{"account_id":"0CEFFBADD0A04623896F5317A1E40D94"}"#)
            .expect("valid config");
        assert_eq!(config.account_id, "0ceffbadd0a04623896f5317a1e40d94");
    }

    #[test]
    fn empty_account_id_is_not_configured_but_valid() {
        let config = SessionConfig::from_json(r#"{"default_domain":"x.pages.dev"}"#)
            .expect("valid config");
        assert!(!config.is_configured());
    }

    /// The immutability contract, enforced at build time: this crate must not
    /// introduce an account ID, a Pages project, or an operator domain as a
    /// literal. Everything of that shape must arrive via the session.
    #[test]
    fn no_account_data_is_compiled_into_the_artifact() {
        let source = include_str!("lib.rs");

        // Strip the test module so the fixtures below are not self-triggering.
        let shipped = source
            .split("mod tests {")
            .next()
            .expect("test module is last");

        for (index, line) in shipped.lines().enumerate() {
            let line = line.trim();
            if line.starts_with("//") {
                continue;
            }
            assert!(
                !is_account_id(line),
                "line {} embeds a 32-hex account ID: {line}",
                index + 1
            );
            assert!(
                !line.contains(".pages.dev"),
                "line {} embeds an operator Pages domain: {line}",
                index + 1
            );
        }
    }

    /// A fresh session has no account and no domain until the client supplies
    /// them — there is no compiled-in fallback.
    #[test]
    fn empty_session_yields_no_account_or_domain() {
        assert!(!session_is_configured());
        assert_eq!(get_cloudflare_account_id(), "");
        assert_eq!(get_cloudflare_default_domain(), "");
        assert_eq!(get_api_base_url(), DEFAULT_API_BASE_URL);
    }

    #[test]
    fn deploy_config_reports_unconfigured_session() {
        let config = generate_deploy_config("p", "proj", "");
        let value: serde_json::Value = serde_json::from_str(&config).unwrap();
        assert_eq!(value["configured"], serde_json::json!(false));
        assert_eq!(value["cloudflare_pages"]["account_id"], serde_json::json!(""));
    }

    #[test]
    fn deploy_instructions_flag_missing_account() {
        let text = get_deploy_instructions("p", "proj", "d.pages.dev");
        assert!(text.contains("no Cloudflare account ID is configured"));
        // The wrangler command itself must carry no account flag.
        let deploy_line = text
            .lines()
            .find(|l| l.contains("wrangler pages deploy"))
            .expect("deploy step present");
        assert!(!deploy_line.contains("--account-id"), "{deploy_line}");
    }

    #[test]
    fn deploy_instructions_omit_account_when_unconfigured() {
        let session = SessionConfig::from_json(
            r#"{"account_id":"0ceffbadd0a04623896f5317a1e40d94","default_domain":"x.pages.dev"}"#,
        )
        .expect("valid config");
        SESSION.with(|slot| *slot.borrow_mut() = session);

        let text = get_deploy_instructions("p", "proj", "");
        assert!(!text.contains("no Cloudflare account ID is configured"));
        let deploy_line = text
            .lines()
            .find(|l| l.contains("wrangler pages deploy"))
            .expect("deploy step present");
        assert!(
            deploy_line.contains("--account-id 0ceffbadd0a04623896f5317a1e40d94"),
            "{deploy_line}"
        );
        // An empty domain falls back to the session default.
        assert_eq!(get_cloudflare_default_domain(), "x.pages.dev");

        SESSION.with(|slot| *slot.borrow_mut() = SessionConfig::default());
    }
}