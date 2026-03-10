import { runHandler } from "@/server/next-adapter"
import { attributeReferral, getReferral, trackReferralClick } from "@/server/controllers/referralController"
import { requireAuth } from "@/server/middleware/auth"
import { validate } from "@/server/middleware/validate"
import { z } from "zod"

const trackSchema = z.object({
  body: z.object({
    refCode: z.string().min(3),
  }),
})

const attributeSchema = z.object({
  body: z.object({
    refCode: z.string().min(3),
    orderId: z.string().min(1),
    customerId: z.string().optional(),
  }),
})

const withAuth = [requireAuth]

export const dynamic = "force-dynamic"

type Params = { path?: string[] }

export async function GET(request: Request, { params }: { params: Promise<Params> }) {
  const { path = [] } = await params
  if (path[0] !== "me") return notFound()
  return runHandler(request, {}, [...withAuth, getReferral], undefined)
}

export async function POST(request: Request, { params }: { params: Promise<Params> }) {
  const { path = [] } = await params
  const segment = path[0]
  if (segment === "track") {
    return runHandler(request, {}, [...withAuth, validate(trackSchema), trackReferralClick], undefined)
  }
  if (segment === "attribute") {
    return runHandler(request, {}, [...withAuth, validate(attributeSchema), attributeReferral], undefined)
  }
  return notFound()
}

export async function OPTIONS() {
  return new Response(null, {
    status: 204,
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type, Authorization",
    },
  })
}

function notFound() {
  return new Response(JSON.stringify({ success: false, error: "Not found" }), {
    status: 404,
    headers: { "Content-Type": "application/json" },
  })
}
