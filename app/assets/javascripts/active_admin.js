//= require active_admin/base
//= require chartkick
//= require Chart.bundle

function highlightImage(image){
 
    const overlay = document.createElement("div");
    overlay.classList.add("image-overlay");
  
    const bigImage = document.createElement("img");
    bigImage.src = image.src;
    bigImage.classList.add("image-zoomed");
  
    overlay.appendChild(bigImage);
    document.body.appendChild(overlay);
  
    // Remove overlay on click
    overlay.addEventListener("click", () => {
      bigImage.classList.remove("image-zoomed");
      document.body.removeChild(overlay);
    });
}

document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll("tr.clickable-row").forEach((row) => {
      row.addEventListener("click", (e) => {
        if (e.target.closest(".product-thumb")) return;
  
        const linkEl = row.querySelector(".row-link");
        if (linkEl) {
          const url = linkEl.dataset.href;
          if (url) {
            window.location.href = url;
          }
        }
      });
    });
  });

  function buyProduct(el) {

    const productId = el.dataset.productId;


    alert("Buying product with ID: " + productId);
  
    fetch(`/admin/products/${productId}/buy_product`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Content-Type": "application/json"
      }
    })
    .then(response => response.json())
    .then(data => alert(data.message));
  }


  function addToCard(el) {

    const productId = el.dataset.productId;


    alert("Product add to card with ID: " + productId);
  
    fetch(`/admin/products/${productId}/buy_product`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Content-Type": "application/json"
      }
    })
    .then(response => response.json())
    .then(data => alert(data.message));
  }


