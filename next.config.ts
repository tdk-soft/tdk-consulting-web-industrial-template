import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // CRITICAL: Enables the standalone build for Docker
  output: 'standalone',
  
  // Recommended for industrial templates (security & stability)
  reactStrictMode: true,
  powers: {
    // This removes the 'X-Powered-By: Next.js' header for security
    removeConsole: process.env.NODE_ENV === "production",
  }
};

export default nextConfig;