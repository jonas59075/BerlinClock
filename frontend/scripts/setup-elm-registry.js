const fs = require('fs');
const path = require('path');

const registryPath = path.join(__dirname, '..', '..', 'elm.tmp', '0.19.1', 'packages', 'registry.dat');
const registryDir = path.dirname(registryPath);

const base64Registry =
  'AAAAAAAAAAwAAAAAAAAADANlbG0HYnJvd3NlcgEAAgAAAAAAAAAAA2VsbQVieXRlcwEACAAAAAAAAAAAA2VsbQRjb3JlAQAFAAAAAAAAAAADZWxtBGZpbGUBAAUAAAAAAAAAAANlbG0EaHRtbAEAAQAAAAAAAAAAA2VsbQRodHRwAgAAAAAAAAAAAAADZWxtBGpzb24BAQQAAAAAAAAAAANlbG0GcmFuZG9tAQAAAAAAAAAAAAADZWxtBHRpbWUBAAAAAAAAAAAAAANlbG0DdXJsAQAAAAAAAAAAAAADZWxtC3ZpcnR1YWwtZG9tAQAFAAAAAAAAAAAQZWxtLWV4cGxvcmF0aW9ucwR0ZXN0AgIAAAAAAAAAAAA=';

function ensureRegistry() {
  if (!fs.existsSync(registryDir)) {
    fs.mkdirSync(registryDir, { recursive: true });
  }

  const contents = Buffer.from(base64Registry, 'base64');
  const existing = fs.existsSync(registryPath) ? fs.readFileSync(registryPath) : null;

  if (!existing || !existing.equals(contents)) {
    fs.writeFileSync(registryPath, contents);
  }
}

ensureRegistry();
