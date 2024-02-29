import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3004,
    fs: {
      strict: false,
    },
    proxy: {
      '/ws': {
        target: 'ws://127.0.0.1:8545',
        ws: true,
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/ws/, ''),
      },
      '/api': {
        target: 'http://127.0.0.1:8545',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, ''),
      }
    },
  },
  build: {
    target: "es2022",
    minify: true,
    sourcemap: true,
  },
});
