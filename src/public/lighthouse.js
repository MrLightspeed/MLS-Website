// /public/lighthouse.js
// Add 'loading="lazy"' to all images except the first hero/LCP image
// Preconnect to Google Fonts early to improve FCP
// Preload the hero image for better LCP
const fonts = document.createElement("link")
fonts.rel = "preconnect"
fonts.href = "https://fonts.gstatic.com"
fonts.crossOrigin = "anonymous"
document.head.appendChild(fonts)

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

window.addEventListener("load", () => {
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
