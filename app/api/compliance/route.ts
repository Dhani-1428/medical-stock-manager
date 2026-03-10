import { runHandler } from "@/server/next-adapter"
import { listComplianceLogs } from "@/server/controllers/complianceController"
import { requireAuth } from "@/server/middleware/auth"
import { requireRole } from "@/server/middleware/role"

const withAuth = [requireAuth, requireRole("ADMIN")]

export const dynamic = "force-dynamic"

export async function GET(request: Request) {
  return runHandler(request, {}, [...withAuth, listComplianceLogs], undefined)
}

export async function OPTIONS() {
  return new Response(null, {
    status: 204,
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type, Authorization",
    },
  })
}
