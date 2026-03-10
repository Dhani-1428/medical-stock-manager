import mongoose from "mongoose"

// Cache connection for serverless (Next.js) to avoid creating new connection per request
declare global {
  var mongoose: { conn: typeof mongoose | null; promise: Promise<typeof mongoose> | null }
}

const cached = global.mongoose ?? { conn: null, promise: null }
if (process.env.NODE_ENV !== "production") global.mongoose = cached

export async function connectDb(): Promise<typeof mongoose> {
  const MONGODB_URI = process.env.MONGODB_URI || ""
  
  if (!MONGODB_URI) {
    throw new Error(
      "MONGODB_URI is required. Please set it in your .env file. " +
      "Example: MONGODB_URI=mongodb://localhost:27017/erp-medical or use MongoDB Atlas connection string."
    )
  }
  
  if (cached.conn) return cached.conn
  if (!cached.promise) {
    mongoose.set("strictQuery", true)
    cached.promise = mongoose.connect(MONGODB_URI).catch((error) => {
      // Clear the promise on error so we can retry
      cached.promise = null
      
      // Provide helpful error messages
      if (error.message?.includes("ECONNREFUSED") || error.message?.includes("connect")) {
        throw new Error(
          `Cannot connect to MongoDB at ${MONGODB_URI}. ` +
          `Please ensure MongoDB is running locally or use a MongoDB Atlas connection string. ` +
          `Error: ${error.message}`
        )
      }
      throw error
    })
  }
  cached.conn = await cached.promise
  return cached.conn
}

export function getDbStatus(): string {
  const state = mongoose.connection.readyState
  if (state === 1) return "connected"
  if (state === 2) return "connecting"
  if (state === 3) return "disconnecting"
  return "disconnected"
}
