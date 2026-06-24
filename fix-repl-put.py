#!/usr/bin/env python3
"""Fix PUT handler: clone block before match to avoid move."""
p = '/home/mdupont/dasl/ipld-car-ipc-shmem-linux/src/bin/lean4-repl.rs'
text = open(p).read()

old = '''                        match state.push_to_shmem(&block) {
                            Ok(cid) => { loaded.push(name); }
                            Err(e) => { errors.push(format!("{name}: {e}")); loaded.push(name); }
                        }
                        state.declarations.insert(name.clone(), block);'''

new = '''                        state.declarations.insert(name.clone(), block.clone());
                        match state.push_to_shmem(&block) {
                            Ok(cid) => { loaded.push(name); }
                            Err(e) => { errors.push(format!("{name}: {e}")); loaded.push(name); }
                        }'''

text = text.replace(old, new)
open(p, 'w').write(text)
print('fixed')
