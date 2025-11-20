import { build } from "esbuild";

await build({
  entryPoints: ["src/Main.elm"],
  outfile: "dist/main.js",
  bundle: true,
  plugins: [
    {
      name: "elm",
      setup(build) {
        const { execSync } = require("child_process");
        build.onLoad({ filter: /\.elm$/ }, async (args) => {
          execSync(`elm make ${args.path} --output=/dev/stdout`, {
            maxBuffer: 1024 * 1024 * 10,
          });
          return {
            contents: execSync(
              `elm make ${args.path} --optimize --output /dev/stdout`
            ).toString(),
            loader: "js",
          };
        });
      },
    },
  ],
});
