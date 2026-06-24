#!/usr/bin/env python3
"""Add NotebooklmCross command to aristotle-manager CLI."""
p = '/mnt/data1/time-2026/05-may/07/arist/src/main.rs'
t = open(p).read()

# 1. Add mod declaration
t = t.replace('mod notebooklm;', 'mod notebooklm;\nmod notebooklm_cross;')

# 2. Add enum variant before LoadDecls (last struct-like variant)
old = '    /// Load declarations into lean4-repl shared memory'
new_variant = '''    /// Generate cross-project NotebookLM files from all REPL declarations
    NotebooklmCross {
        #[arg(long)]
        output_dir: Option<PathBuf>,
    },
    /// Load declarations into lean4-repl shared memory'''
t = t.replace(old, new_variant)

# 3. Add match arm before the Notebooklm match arm
old_match = 'Commands::Notebooklm { project_dir } => {\n            info!("Executing notebooklm command");\n            notebooklm::cmd_notebooklm(project_dir)?;'
new_match = '''Commands::NotebooklmCross { output_dir } => {
            info!("Executing notebooklm-cross command");
            notebooklm_cross::cmd_notebooklm_cross(output_dir.clone())?;
        }
        Commands::Notebooklm { project_dir } => {
            info!("Executing notebooklm command");
            notebooklm::cmd_notebooklm(project_dir)?;'''
t = t.replace(old_match, new_match)

open(p, 'w').write(t)
print('ok')
