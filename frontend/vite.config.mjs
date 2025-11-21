import { defineConfig } from "vite";
import elmPlugin from "vite-plugin-elm";
import { fileURLToPath } from "url";
import path from "path";

const elmHome = process.env.ELM_HOME
  || path.resolve(path.dirname(fileURLToPath(import.meta.url)), "./.elm-home");

process.env.ELM_HOME = elmHome;

export default defineConfig({
  plugins: [elmPlugin()],
  build: {
    outDir: "dist",
  }
});
