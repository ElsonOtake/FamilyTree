// Send page views after Turbo navigation, including the initial page load.
// Disable Enhanced Measurement in GA4 to avoid duplicate automatic events.
function analyticsUrl(value) {
  if (!value) return ""

  try {
    const url = new URL(value)
    return `${url.origin}${url.pathname}`
  } catch {
    return ""
  }
}

let initialized = false
let previousUrl = analyticsUrl(document.referrer)

document.addEventListener("turbo:load", () => {
  const measurementId = document.querySelector(
    'meta[name="ga-measurement-id"]'
  )?.content

  if (!measurementId) return

  if (!initialized) {
    window.dataLayer = window.dataLayer || []
    window.gtag = function () { window.dataLayer.push(arguments) }
    window.gtag("js", new Date())
  }

  const pageLocation = analyticsUrl(window.location.href)

  // Set sanitized URLs on the configuration so subsequent engagement events
  // also omit search terms, account tokens, and URL fragments.
  window.gtag("config", measurementId, {
    send_page_view: false,
    page_location: pageLocation,
    page_referrer: previousUrl,
    page_title: "FamilyTree",
    allow_google_signals: false,
    allow_ad_personalization_signals: false
  })

  window.gtag("event", "page_view", { send_to: measurementId })
  previousUrl = pageLocation

  if (!initialized) {
    const script = document.createElement("script")
    script.async = true
    script.src = `https://www.googletagmanager.com/gtag/js?id=${encodeURIComponent(measurementId)}`
    document.head.appendChild(script)
    initialized = true
  }
})
