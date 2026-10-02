#!/usr/bin/env node
import { createServer } from 'http';
import { readFile } from 'fs';
import { join, extname } from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const PORT = parseInt(process.argv[2]) || 8080;
const ROOT = __dirname;

const MIME_TYPES = {
    '.html': 'text/html',
    '.js': 'text/javascript',
    '.wasm': 'application/wasm',
    '.json': 'application/json',
    '.css': 'text/css',
    '.png': 'image/png',
    '.ico': 'image/x-icon',
};

const server = createServer((req, res) => {
    let filePath = join(ROOT, decodeURIComponent(req.url).split('?')[0]);
    
    if (filePath.endsWith('/')) {
        filePath = join(filePath, 'index.html');
    }
    
    readFile(filePath, (err, data) => {
        if (err) {
            res.writeHead(404, { 'Content-Type': 'text/plain' });
            res.end('Not Found');
            return;
        }
        
        const ext = extname(filePath).toLowerCase();
        const contentType = MIME_TYPES[ext] || 'application/octet-stream';
        
        res.writeHead(200, { 'Content-Type': contentType });
        res.end(data);
    });
});

server.listen(PORT, () => {
    console.log(`Aristotle Web UI serving at http://localhost:${PORT}`);
    console.log(`WASM module: http://localhost:${PORT}/aristotle_wasm.js`);
    console.log(`Web UI: http://localhost:${PORT}/index.html`);
});