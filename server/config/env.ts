// Next.js loads .env automatically; no dotenv needed
export const env = {
  mongoUri: process.env.MONGODB_URI || "",
  jwtAccessSecret:
    process.env.JWT_ACCESS_SECRET || process.env.JWT_SECRET || "",
  jwtRefreshSecret: process.env.JWT_REFRESH_SECRET || "",
  clientOrigin: process.env.CLIENT_ORIGIN || "http://localhost:3000",
  port: Number(process.env.PORT || 5000),
  // Shipping
  shiprocketEmail: process.env.SHIPROCKET_EMAIL || "",
  shiprocketPassword: process.env.SHIPROCKET_PASSWORD || "",
  shiprocketBaseUrl: process.env.SHIPROCKET_BASE_URL || "https://apiv2.shiprocket.in",
  rapidshypApiKey: process.env.RAPIDSHYP_API_KEY || "",
  rapidshypBaseUrl: process.env.RAPIDSHYP_BASE_URL || "https://api.rapidshyp.com",
  defaultShippingProvider: (process.env.DEFAULT_SHIPPING_PROVIDER || "SHIPROCKET") as "SHIPROCKET" | "RAPIDSHYP",
  publicAppUrl: process.env.PUBLIC_APP_URL || "http://localhost:3000",
  // Razorpay
  razorpayKeyId: process.env.RAZORPAY_KEY_ID || "",
  razorpayKeySecret: process.env.RAZORPAY_KEY_SECRET || "",
  razorpayWebhookSecret: process.env.RAZORPAY_WEBHOOK_SECRET || "",
}

// Validate environment variables only at runtime, not during build
// This prevents build-time errors when env vars aren't available
export function validateEnv() {
  if (typeof window === "undefined") {
    if (!env.mongoUri) {
      throw new Error("MONGODB_URI is required")
    }
    if (!env.jwtAccessSecret) {
      throw new Error("JWT_ACCESS_SECRET (or JWT_SECRET) is required")
    }
  }
}
