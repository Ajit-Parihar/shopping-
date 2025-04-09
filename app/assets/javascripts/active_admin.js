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

  document.addEventListener("DOMContentLoaded", function () {
    function updateGrandTotal() {
      let grandTotal = 0;
      document.querySelectorAll("[id^='total-pay-']").forEach((totalElement) => {
        grandTotal += parseFloat(totalElement.innerText);
      });
      const grandTotalEl = document.getElementById("grand-total");
      if (grandTotalEl) {
        grandTotalEl.innerText = grandTotal.toFixed(2);
      }
    }
  
    document.querySelectorAll(".increase-btn").forEach((button) => {
      button.addEventListener("click", function () {
        let productId = this.dataset.id;
        let quantityElement = document.getElementById(`quantity-${productId}`);
        let totalPriceElement = document.getElementById(`total-pay-${productId}`);
        let pricePerUnit = parseFloat(totalPriceElement.dataset.price);
  
        let quantity = parseInt(quantityElement.innerText);
        quantity += 1;
        quantityElement.innerText = quantity;
        totalPriceElement.innerText = (quantity * pricePerUnit).toFixed(2);
  
        updateGrandTotal();
      });
    });
  
    document.querySelectorAll(".decrease-btn").forEach((button) => {
      button.addEventListener("click", function () {
        let productId = this.dataset.id;
        let quantityElement = document.getElementById(`quantity-${productId}`);
        let totalPriceElement = document.getElementById(`total-pay-${productId}`);
        let pricePerUnit = parseFloat(totalPriceElement.dataset.price);
  
        let quantity = parseInt(quantityElement.innerText);
        if (quantity > 1) {
          quantity -= 1;
          quantityElement.innerText = quantity;
          totalPriceElement.innerText = (quantity * pricePerUnit).toFixed(2);
        }
  
        updateGrandTotal();
      });
    });
  
    updateGrandTotal();
  });
  
  function cardAddBuyProduct(button) {
    const productId = button.dataset.productId;
    const quantity = parseInt(document.getElementById(`quantity-${productId}`).textContent);
   console.log(productId)
   console.log(quantity)
    alert(`Buying product with ID: ${productId} and quantity: ${quantity}`);
  
    fetch(`/admin/products/${productId}/buy_product`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        quantity: quantity
      })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error("Request failed");
      }
      return response.json(); 
    })
    .then(data => {
      console.log("Buy successful:", data);
      alert("Purchase successful!");
    })
    .catch(error => {
      console.error("Error:", error);
      alert("There was an error processing your purchase.");
    });
  }
  