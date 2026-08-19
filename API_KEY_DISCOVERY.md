# Aristotle API key discovery

The manager never executes shell startup files. It checks these sources in
order:

1. An in-process key set by configure.
2. The ARISTOTLE_API_KEY environment variable.
3. The file named by ARISTOTLE_API_KEY_FILE.
4. The Aristotle config directory: api_key, .env, and config.toml.
5. The home files .aristotle_api_key, .bashrc, .bash_profile, .profile, and
   .zshrc.

Plain key files contain only the key. Shell and TOML files may contain a simple
assignment such as export ARISTOTLE_API_KEY='value'. The loader ignores command
substitution and does not source or evaluate any file.

Environment variables and explicit files remain the preferred choices for CI.
Keep key files private and never commit them.
