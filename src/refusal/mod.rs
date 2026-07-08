pub mod audit;
pub mod extract;
pub mod failure;
pub mod fix;
pub mod glossary;

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RefusalInstance {
    pub project_id: String,
    pub file: String,
    pub pattern: String,
    pub context: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct HelpInstance {
    pub project_id: String,
    pub file: String,
    pub pattern: String,
    pub context: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MissingInstance {
    pub project_id: String,
    pub file: String,
    pub pattern: String,
    pub context: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AuditReport {
    pub refusals: Vec<RefusalInstance>,
    pub help_requests: Vec<HelpInstance>,
    pub missing_deps: Vec<MissingInstance>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FixStrategy {
    pub refusal_id: String,
    pub projects: Vec<String>,
    pub category: String,
    pub pattern: String,
    pub original_context: String,
    pub root_cause: String,
    pub fix_strategy: String,
    pub fix_result: serde_json::Value,
    pub prompt_template: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FailureEntry {
    pub project_id: String,
    pub run_index: usize,
    pub run_header: String,
    pub classification: String,
    pub description: String,
    pub created_at: String,
    pub mystical_themes: Vec<String>,
    pub lean_files_count: usize,
    pub summary_excerpt: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GlossaryEntry {
    pub term: String,
    pub frequency: usize,
    pub categories: Vec<String>,
    pub wordnet: serde_json::Value,
    pub usage_contexts: Vec<UsageContext>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct UsageContext {
    pub project: String,
    pub file: String,
    pub context: String,
}

impl AuditReport {
    pub fn total(&self) -> usize {
        self.refusals.len() + self.help_requests.len() + self.missing_deps.len()
    }
}

pub fn safe_slice(s: &str, start: usize, end: usize) -> &str {
    let start = if s.is_char_boundary(start) {
        start
    } else {
        let mut i = start;
        while i > 0 && !s.is_char_boundary(i) {
            i -= 1;
        }
        i
    };
    let end = if s.is_char_boundary(end) {
        end
    } else {
        let mut i = end;
        while i < s.len() && !s.is_char_boundary(i) {
            i += 1;
        }
        i
    };
    if start > end {
        &s[0..0]
    } else {
        &s[start..end]
    }
}

pub fn safe_truncate(s: &str, max_len: usize) -> &str {
    if s.len() <= max_len {
        return s;
    }
    let mut end = max_len;
    while end > 0 && !s.is_char_boundary(end) {
        end -= 1;
    }
    &s[..end]
}
