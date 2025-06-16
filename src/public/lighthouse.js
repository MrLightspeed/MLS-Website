// /public/lighthouse.js
// Add 'loading="lazy"' to all images except the first hero/LCP image
window.addEventListener("load", () => {
  // Preconnect to Google Fonts to improve FCP
  const fonts = document.createElement("link")
  fonts.rel = "preconnect"
  fonts.href = "https://fonts.gstatic.com"
  fonts.crossOrigin = "anonymous"
  document.head.appendChild(fonts)

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
})
