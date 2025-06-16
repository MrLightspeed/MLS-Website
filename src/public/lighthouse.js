// /public/lighthouse.js
// Add 'loading="lazy"' to all images except the first hero/LCP image
// Preconnect to Google Fonts early to improve FCP
// Preload the hero image for better LCP
const fontHosts = [
  "https://static.parastorage.com",
  "https://static.wixstatic.com",
  "https://fonts.gstatic.com",
]
for (const href of fontHosts) {
  const link = document.createElement("link")
  link.rel = "preconnect"
  link.href = href
  link.crossOrigin = "anonymous"
  document.head.appendChild(link)
}

// Preload the hero image and give it high fetch priority
const heroImg = document.querySelector(".hero-section img")
if (heroImg && heroImg.src) {
  const preload = document.createElement("link")
  preload.rel = "preload"
  preload.as = "image"
  preload.href = heroImg.src
  document.head.appendChild(preload)
  heroImg.setAttribute("fetchpriority", "high")
}

function runOptimizations() {
  const images = document.querySelectorAll("img:not([loading])")
  images.forEach((img, idx) => {
    // Keep the very first hero image eager for better LCP
    if (idx === 0 && img.closest(".hero-section")) {
      img.dataset.lcpHandled = "true"
      return
    }
    img.setAttribute("loading", "lazy")
    img.setAttribute("decoding", "async")
    if (!img.hasAttribute("alt")) {
      img.setAttribute("alt", "")
    }
  })

  // Ensure the main heading remains readable for accessibility
  const h1 = document.querySelector("h1")
  if (h1) {
    const size = parseFloat(getComputedStyle(h1).fontSize)
    if (!Number.isNaN(size) && size < 20) {
      h1.style.fontSize = "24px"
    }
  }

  // Provide alt text for the Open Graph image if missing
  const ogImage = document.querySelector("meta[property='og:image']")
  if (ogImage && !document.querySelector("meta[property='og:image:alt']")) {
    const meta = document.createElement("meta")
    meta.setAttribute("property", "og:image:alt")
    const altText = heroImg?.getAttribute("alt") || "Lightspeed Listings hero image"
    meta.setAttribute("content", altText)
    document.head.appendChild(meta)
  }
}

if (document.readyState !== "loading") {
  runOptimizations()
} else {
  document.addEventListener("DOMContentLoaded", runOptimizations)
}
