#!/usr/bin/env python3
"""Debug: test HTML extraction from Gnostic Library files."""
import os, re
from html.parser import HTMLParser

class TextExtractor(HTMLParser):
    def __init__(self):
        super().__init__()
        self.text = []
        self.tag_stack = []
    def handle_starttag(self, tag, attrs):
        self.tag_stack.append(tag)
        if tag in ('p', 'div', 'h1', 'h2', 'h3', 'h4', 'br', 'li', 'tr'):
            self.text.append('\n')
    def handle_endtag(self, tag):
        if self.tag_stack and self.tag_stack[-1] == tag:
            self.tag_stack.pop()
        if tag in ('p', 'div', 'h1', 'h2', 'h3', 'h4', 'br', 'li', 'tr'):
            self.text.append('\n')
    def handle_data(self, data):
        # Strip script/style content by checking tag stack
        for t in self.tag_stack:
            if t in ('script', 'style'):
                return
        t = data.strip()
        if t:
            self.text.append(t + ' ')

base = os.path.expanduser("~/2026/06/22/gnostic-library/books")
# Test first 5 books
count = 0
for book_dir in sorted(os.listdir(base)):
    path = os.path.join(base, book_dir, "text.html")
    if not os.path.isfile(path):
        continue
    with open(path) as f:
        html = f.read()
    ex = TextExtractor()
    ex.feed(html)
    text = ''.join(ex.text)
    clean = re.sub(r'\s+', ' ', text).strip()
    if clean:
        count += 1
        print(f"OK {book_dir}: {len(clean)} chars → {clean[:120]}...")
    else:
        print(f"EMPTY {book_dir}: {len(html)} bytes HTML")
    if count >= 10:
        break
