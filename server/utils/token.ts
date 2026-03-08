import jwt from "jsonwebtoken"
import { env } from "../config/env"

export type JwtPayload = {
  userId: string
  role: "ADMIN" | "USER"
}

function getJwtSecret() {
  if (!env.jwtAccessSecret) {
    throw new Error("JWT_ACCESS_SECRET (or JWT_SECRET) is required")
  }
  return env.jwtAccessSecret
}

export function signAccessToken(payload: JwtPayload) {
  return jwt.sign(payload, getJwtSecret(), { expiresIn: "1d" })
}

export function verifyAccessToken(token: string) {
  return jwt.verify(token, getJwtSecret()) as JwtPayload
}
