import { FlatCompat } from "@eslint/eslintrc";

const compat = new FlatCompat({
  baseDirectory: import.meta.dirname,
});

const eslintConfig = [
  ...compat.extends("next/core-web-vitals", "next/typescript"),
  {
    // Remplace le .eslintignore
    ignores: [".next/*", "node_modules/*", "dist/*", "out/*"],
  },
];

export default eslintConfig;