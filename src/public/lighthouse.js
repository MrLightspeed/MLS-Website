// /public/lighthouse.js
// Add 'loading="lazy"' to all images except the first hero/LCP image
window.addEventListener('load', () => {
  const images = document.querySelectorAll('img:not([loading])');
  images.forEach((img, idx) => {
    // Keep the very first hero image eager for better LCP
    if (idx === 0 && img.closest('.hero-section')) {
      img.dataset.lcpHandled = 'true';
      return;
    }
    img.setAttribute('loading', 'lazy');
  });