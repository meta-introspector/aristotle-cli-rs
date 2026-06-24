#!/usr/bin/env python3
"""Add load-decls and repl-stats to aristotle-manager. Fix match/imports."""
p = '/mnt/data1/time-2026/05-may/07/arist/src/main.rs'
m = open(p).read()

# 1. mod repl
m = m.replace('mod version;', 'mod version;\nmod repl;')

# 2. Add variants AFTER Version variant
old = '        #[arg(long)]\n        output_dir: Option<PathBuf>,\n    },'
new = old + '\n    /// Load declarations into lean4-repl shared memory\n    LoadDecls {\n        /// Directory containing .lean source files\n        dir: Option<PathBuf>,\n        /// Only show counts\n        #[arg(long)]\n        dry_run: bool,\n    },\n    /// Show lean4-repl stats\n    ReplStats,'
m = m.replace(old, new, 1)

# 3. Add match arms: replace just the `}` that closes the match (right before `// Keep the file appender`)
# The last match arm is Commands::Version - add new arms after it
old_match = '            version::cmd_version(results_dir.clone(), output_dir.clone())?;\n        }'
new_match = old_match + '\n        Commands::LoadDecls { dir, dry_run } => {\n            info!("Executing load-decls");\n            repl::cmd_load_decls(dir.clone(), *dry_run)?;\n        }\n        Commands::ReplStats => {\n            info!("Executing repl-stats");\n            repl::cmd_repl_stats()?;\n        }'
m = m.replace(old_match, new_match, 1)

open(p, 'w').write(m)
print('done')

# Fix Cargo.toml - add blocking feature
t = open('/mnt/data1/time-2026/05-may/07/arist/Cargo.toml').read()
t = t.replace('features = ["json", "multipart",', 'features = ["json", "multipart", "blocking",')
if 'glob' not in t:
    t = t.replace('reqwest =', 'glob = "0.3"\nreqwest =', 1)
open('/mnt/data1/time-2026/05-may/07/arist/Cargo.toml', 'w').write(t)
print('cargo.toml done')
