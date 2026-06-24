use anyhow::Result;
use std::fs;
use std::path::PathBuf;
use std::process::Command;
use serde_json::Value;

const WORD_LIMIT: usize = 480_000;
const S: &str = "/nix/store/hagadmgn61fhbxdq2md6p1jjb5plb52v-staticsplitjson/bin/staticsplitjson";

// 66 projects — auto-generated, sorted by project ID
const PROJECTS: &[(&str, &str)] = &[
        ("0b1f914a", "aristotles_results/0b1f914a-a33d-45d5-9a31-89e0a27d19ba_aristotle/output-final_aristotle/RequestProject"),
        ("0f53cc68", "aristotles_results/0f53cc68-d944-4c79-b230-7406b2da0444_aristotle/output-final_aristotle/RequestProject"),
        ("0fd4acb0", "aristotles_results/0fd4acb0-1180-40d0-8507-186fb63b3785_aristotle/output-final_aristotle/RequestProject"),
        ("10d30754", "/mnt/data1/aristotle-results/aristo-outputs/10d30754-b3cc-4dac-8033-04ee31afacaa_aristotle/output-final_aristotle/RequestProject"),
        ("1233bb96", "aristotles_results/1233bb96-7ca9-444b-bca9-a76ce872056b_aristotle/output-final_aristotle/RequestProject"),
        ("15094d2c", "aristotles_results/15094d2c-5f52-459e-969f-e748cb82e2f2_aristotle/output-final_aristotle/RequestProject"),
        ("154149d5", "aristotles_results/154149d5-e760-491e-a320-0659477eb582_aristotle/output-final_aristotle/RequestProject"),
        ("17b38b65", "/mnt/data1/aristotle-results/aristo-outputs/17b38b65-9e5a-4c0e-9184-307b5e00f639_aristotle/output-final_aristotle/RequestProject"),
        ("188f2021", "aristotles_results/188f2021-5ed4-496d-b253-33811084c8bb_aristotle/output-final_aristotle/RequestProject"),
        ("19303e84", "aristotles_results/19303e84-6893-4f99-83f2-1b9cd9a2b69c_aristotle/output-final_aristotle/RequestProject"),
        ("19cb55b9", "aristotles_results/19cb55b9-513e-4ea5-91bd-16f84bebb60b_aristotle/output-final_aristotle/RequestProject"),
        ("2826169a", "aristotles_results/2826169a-0779-4623-95d3-0dd8170df390_aristotle/output-final_aristotle/RequestProject"),
        ("30c0ca50", "aristotles_results/30c0ca50-8b8f-44d7-9fca-5de74cb658be_aristotle/output-final_aristotle/RequestProject"),
        ("3550e92a", "aristotles_results/3550e92a-d30c-4fdd-b27d-6ce438d8fcae_aristotle/output-final_aristotle/RequestProject"),
        ("360d39a0", "aristotles_results/360d39a0-6c5e-49d6-8ff0-8fefe5d8ba01_aristotle/output-final_aristotle/RequestProject"),
        ("37060ef6", "aristotles_results/37060ef6-f5b7-4f50-b56f-313bd1b00f86_aristotle/output-final_aristotle/RequestProject"),
        ("37b1afab", "aristotles_results/37b1afab-e60f-47f8-86cf-55b495bbdd9b_aristotle/output-final_aristotle/RequestProject"),
        ("3cd7879d", "/mnt/data1/aristotle-results/aristo-outputs/3cd7879d-da6e-45e6-ae84-cef6ce7f12e2_aristotle/output-final_aristotle/RequestProject"),
        ("3dc4aa73", "aristotles_results/3dc4aa73-b7f4-484f-944e-fd9db646be5c_aristotle/output-final_aristotle/RequestProject"),
        ("4298a77c", "/mnt/data1/aristotle-results/aristo-outputs/4298a77c-933a-414a-a625-8e23a3868444_aristotle/output-final_aristotle/RequestProject"),
        ("43e820c5", "aristotles_results/43e820c5-5400-452b-9213-dd1ae00d50c9_aristotle/output-final_aristotle/RequestProject"),
        ("48a1653a", "/mnt/data1/aristotle-results/aristo-outputs/48a1653a-f1fc-4734-bf42-43d7677a0945_aristotle/output-final_aristotle/RequestProject"),
        ("4dd7233e", "aristotles_results/4dd7233e-7c92-49d3-87ce-4bf132ffd16a_aristotle/output-final_aristotle/RequestProject"),
        ("5aadfa05", "aristotles_results/5aadfa05-10ea-4318-8b63-9c1a3450c53b_aristotle/output-final_aristotle/RequestProject"),
        ("5bd4ff25", "/mnt/data1/aristotle-results/aristo-outputs/5bd4ff25-216c-4111-a888-d41cd6c0d729_aristotle/output-final_aristotle/RequestProject"),
        ("6436e0a3", "/mnt/data1/aristotle-results/aristo-outputs/6436e0a3-86b8-4d04-919f-aae13094519c_aristotle/output-final_aristotle/RequestProject"),
        ("69713c5d", "aristotles_results/69713c5d-d2df-48a9-b693-84e0f7b58352_aristotle/output-final_aristotle/RequestProject"),
        ("732e5d6a", "/mnt/data1/aristotle-results/aristo-outputs/732e5d6a-3440-4b17-85d6-1932029eaa37_aristotle/output-final_aristotle/RequestProject"),
        ("7399cc0d", "aristotles_results/7399cc0d-99f2-4516-8c9e-6da2ef861c18_aristotle/output-final_aristotle/RequestProject"),
        ("78bd0170", "aristotles_results/78bd0170-4edb-458b-8923-e263f1d6eea0_aristotle/output-final_aristotle/RequestProject"),
        ("797a17c0", "aristotles_results/797a17c0-083c-4dad-89a5-123fb1eac6b4_aristotle/output-final_aristotle/RequestProject"),
        ("7982a975", "aristotles_results/7982a975-e700-4070-8ab2-051d1cd04689_aristotle/output-final_aristotle/RequestProject"),
        ("7d0e6e16", "aristotles_results/7d0e6e16-6c89-4db8-92e7-b739566ff669_aristotle/output-final_aristotle/RequestProject"),
        ("7d5f01af", "aristotles_results/7d5f01af-866b-4f1f-870d-792601da9c7f_aristotle/output-final_aristotle/RequestProject"),
        ("7dc508f3", "aristotles_results/7dc508f3-7f85-4026-9d27-607f1a3488d1_aristotle/output-final_aristotle/RequestProject"),
        ("83c33a8c", "aristotles_results/83c33a8c-e7c8-42ad-b89a-f5d3e1936db5_aristotle/output-final_aristotle/RequestProject"),
        ("899e7815", "aristotles_results/899e7815-31c3-43bf-9e07-7e8199572a89_aristotle/output-final_aristotle/RequestProject"),
        ("89f87210", "/mnt/data1/aristotle-results/aristo-outputs/89f87210-0cbf-4bc8-b3cd-e87b94b872bd_aristotle/output-final_aristotle/RequestProject"),
        ("93038611", "aristotles_results/93038611-e9b9-4781-8f93-7048ecd105b4_aristotle/output-final_aristotle/RequestProject"),
        ("93aab411", "aristotles_results/93aab411-fd06-406c-8a97-248feb451e6b_aristotle/output-final_aristotle/RequestProject"),
        ("9aac8698", "/mnt/data1/aristotle-results/aristo-outputs/9aac8698-8a2d-43dd-9667-5bda134265c8_aristotle/output-final_aristotle/RequestProject"),
        ("a705ad1b", "aristotles_results/a705ad1b-ed1d-4ab4-b0f6-aa90e668a8f0_aristotle/output-final_aristotle/RequestProject"),
        ("a80e73c0", "aristotles_results/a80e73c0-b6ca-4453-b261-50436e894545_aristotle/output-final_aristotle/RequestProject"),
        ("b4115e89", "/mnt/data1/aristotle-results/aristo-outputs/b4115e89-6293-4fdc-9f54-46b03fabb9c1_aristotle/output-final_aristotle/RequestProject"),
        ("b49ee870", "aristotles_results/b49ee870-ac86-465b-8f68-a126e124429a_aristotle/output-final_aristotle/RequestProject"),
        ("be3886cf", "aristotles_results/be3886cf-1746-4535-9a4c-718fdef80175_aristotle/output-final_aristotle/RequestProject"),
        ("bf8c7107", "aristotles_results/bf8c7107-3cbc-4907-9ef8-de091ecd00bf_aristotle/output-final_aristotle/RequestProject"),
        ("c038a247", "aristotles_results/c038a247-0542-496d-82c2-a226995f4a82_aristotle/output-final_aristotle/RequestProject"),
        ("c363e369", "aristotles_results/c363e369-48d9-4d39-958d-26c00731cf21_aristotle/output-final_aristotle/RequestProject"),
        ("cb4f0854", "aristotles_results/cb4f0854-e338-4df2-9e17-795cc4afd8f7_aristotle/output-final_aristotle/RequestProject"),
        ("cbfa21c9", "/mnt/data1/aristotle-results/aristo-outputs/cbfa21c9-1b78-4466-965e-f942ad67b4ec_aristotle/output-final_aristotle/RequestProject"),
        ("ce554602", "aristotles_results/ce554602-7017-4d97-9aa0-9cbfa4643422_aristotle/output-final_aristotle/RequestProject"),
        ("cf7316f4", "aristotles_results/cf7316f4-0bf3-4e38-b8b0-34f430244c28_aristotle/output-final_aristotle/RequestProject"),
        ("d321acb2", "aristotles_results/d321acb2-ecab-4637-bbd3-408e35f0287f_aristotle/output-final_aristotle/RequestProject"),
        ("d40f4c4a", "aristotles_results/d40f4c4a-b226-43c4-a783-ddf14bbb1c71_aristotle/output-final_aristotle/RequestProject"),
        ("d7fb51e9", "/mnt/data1/aristotle-results/aristo-outputs/d7fb51e9-c3d6-43f7-b198-ee067d0eab5e_aristotle/output-final_aristotle/RequestProject"),
        ("d929441d", "aristotles_results/d929441d-c0d0-45ef-aa84-e6a4792107ec_aristotle/output-final_aristotle/RequestProject"),
        ("dc171534", "aristotles_results/dc171534-0a1e-4bdc-8307-12dd3917df0f_aristotle/output-final_aristotle/RequestProject"),
        ("e0147fc6", "/mnt/data1/aristotle-results/aristo-outputs/e0147fc6-5f99-40ce-b002-addb74023bee_aristotle/output-final_aristotle/RequestProject"),
        ("e15ece7d", "aristotles_results/e15ece7d-0382-46da-8774-d6f7dab9380e_aristotle/output-final_aristotle/RequestProject"),
        ("e40780fd", "/mnt/data1/aristotle-results/aristo-outputs/e40780fd-0a5e-4a42-85db-e9a7588f8110_aristotle/output-final_aristotle/RequestProject"),
        ("eb2c3eea", "aristotles_results/eb2c3eea-18ff-464f-b7d9-92acdb1fd2b6_aristotle/output-final_aristotle/RequestProject"),
        ("f7d43246", "/mnt/data1/aristotle-results/aristo-outputs/f7d43246-6c46-4331-9206-5f151284901b_aristotle/output-final_aristotle/RequestProject"),
        ("f82c2362", "aristotles_results/f82c2362-13f7-44dd-9f8d-4f1f66e320e8_aristotle/output-final_aristotle/RequestProject"),
        ("f8a964ea", "/mnt/data1/aristotle-results/aristo-outputs/f8a964ea-7b28-4b5a-a9f5-70fc5f43349a_aristotle/output-final_aristotle/RequestProject"),
        ("fa51bcab", "aristotles_results/fa51bcab-be78-4427-b05c-27c58cdd8584_aristotle/output-final_aristotle/RequestProject"),
];

pub fn cmd_notebooklm_cross(_o: Option<PathBuf>) -> Result<()> {
    let out = PathBuf::from("/mnt/data1/notebooklm/2026/06-june/24-dasl-proofs");
    fs::create_dir_all(&out)?;

    let mut file_num = 1;
    let mut buffer = String::new();
    buffer.push_str("# DASL Full Proof Corpus\n\n");

    for (name, dir) in PROJECTS {
        let output = Command::new(S).arg("--dir").arg(dir).output()?;
        if !output.status.success() { continue; }

        let stdout = String::from_utf8_lossy(&output.stdout);
        let decls: Vec<Value> = stdout.lines()
            .filter(|l| !l.trim().is_empty())
            .filter_map(|l| serde_json::from_str(l).ok())
            .collect();

        // Estimate word count for this project section
        let header = format!("\n# Project: {} ({} declarations)\n\n", name, decls.len());
        let mut section = header;
        section.push_str("## Declarations\n\n");
        for d in &decls {
            let dname = d["name"].as_str().unwrap_or("?");
            let kind = d["kind"].as_str().unwrap_or("?");
            let imports: Vec<&str> = d["imports"].as_array()
                .map(|a| a.iter().filter_map(|v| v.as_str()).collect())
                .unwrap_or_default();
            section.push_str(&format!("  {} {} | imports: {}\n", kind, dname, imports.join(", ")));
        }

        section.push_str("\n## Source Files\n\n");
        for leanf in glob::glob(&format!("{}/*.lean", dir))?.filter_map(|p| p.ok()) {
            let fname = leanf.file_name().unwrap_or_default().to_string_lossy();
            if let Ok(content) = fs::read_to_string(&leanf) {
                // Truncate very large files
                let content = if content.len() > 100_000 { &content[..100_000] } else { &content };
                section.push_str(&format!("\n### {}\n```lean\n{}\n```\n", fname, content));
            }
        }

        let section_words = section.split_whitespace().count();

        // Flush BEFORE adding if this section would push us over 480K
        let current = buffer.split_whitespace().count();
        if current + section_words > WORD_LIMIT && current > 10000 {
            let path = out.join(format!("part_{:02}.txt", file_num));
            fs::write(&path, &buffer)?;
            println!("  → part_{:02}.txt: {}K words", file_num, current/1000);
            file_num += 1;
            buffer = format!("# DASL Proof Corpus — Part {}\n\n", file_num);
        }

        buffer.push_str(&section);
        println!("  {}: {} decls", name, decls.len());
    }

    if !buffer.is_empty() {
        let path = out.join(format!("part_{:02}.txt", file_num));
        let wc = buffer.split_whitespace().count();
        fs::write(&path, &buffer)?;
        println!("  → part_{:02}.txt: {}K words", file_num, wc/1000);
    }

    let index = format!("# DASL Full Proof Corpus\n\n**Files**: {}\n**Projects**: {}\n\nEach file ≤480K words for NotebookLM.\n", file_num, PROJECTS.len());
    fs::write(out.join("INDEX.md"), &index)?;
    println!("\nDone: {} files → {}", file_num, out.display());
    Ok(())
}
