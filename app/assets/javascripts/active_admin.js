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
        console.log(productId)
        let quantity = parseInt(quantityElement.innerText);
        quantity += 1;
        quantityElement.innerText = quantity;
        totalPriceElement.innerText = (quantity * pricePerUnit).toFixed(2);

  if (window.location.pathname.split("/")[1] == "cart"){
        const url = window.location.pathname; 
        const segments = url.split("/");      
        const product = segments[segments.length - 1]; 
        console.log(product); 

        fetch(`/update_cart_quantity`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content")
          },
          body: JSON.stringify({ id: product, quantity: quantity })
        }).then(response => {
          if (!response.ok) throw new Error("Failed to update cart");
        }).catch(console.error);
      }
      
        updateQuantityInDB(productId, quantity)
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

        if (window.location.pathname.split("/")[1] == "cart"){
          const url = window.location.pathname; 
          const segments = url.split("/");      
          const product = segments[segments.length - 1]; 
          console.log(product); 
  
          fetch(`/update_cart_quantity`, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content")
            },
            body: JSON.stringify({ id: product, quantity: quantity })
          }).then(response => {
            if (!response.ok) throw new Error("Failed to update cart");
          }).catch(console.error);
        }
  
   
        updateQuantityInDB(productId, quantity)
        updateGrandTotal();
      });
    });
  });

  function updateQuantityInDB(productId, quantity) {
    
    console.log(productId)
    fetch(`/add_to_cards/${productId}/update_quantity`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ quantity: quantity })
    })
    .then((response) => response.json())
    .then((data) => {
      if (data.success) {
        console.log(`Quantity updated in DB for cart ID ${productId}`);
      } else {
        console.error("Failed to update quantity in DB.");
      }
    });
  }

document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll(".clickable-table tbody tr").forEach(function (row) {
    row.addEventListener("click", function () {
      console.log(row.querySelector("td:first-child"));
      const productId = row.querySelector("td:first-child").textContent.trim();
      console.log(productId)
      if (productId) {
        window.location.href = "/admin/products/" + encodeURIComponent(productId);
      }
    });
  });
});


function productRating(rating){
   
   const orderId = rating.dataset.id
   window.location.href = `/admin/ratings/new?order_id=${orderId}`
}


document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".increase-btn").forEach(button => {
    button.addEventListener("click", () => {
      const id = button.dataset.id;
      const quantitySpan = document.getElementById(`quantity-${id}`);
      const totalSpan = document.getElementById(`total-pay-${id}`);
      const price = parseFloat(totalSpan.dataset.price);
      let quantity = parseInt(quantitySpan.textContent);
      quantitySpan.textContent = quantity;
      totalSpan.textContent = (quantity * price).toFixed(2);
    });
  });

  document.querySelectorAll(".decrease-btn").forEach(button => {
    button.addEventListener("click", () => {
      const id = button.dataset.id;
      const quantitySpan = document.getElementById(`quantity-${id}`);
      const totalSpan = document.getElementById(`total-pay-${id}`);
      const price = parseFloat(totalSpan.dataset.price);
      let quantity = parseInt(quantitySpan.textContent);

      if (quantity > 1) {
        quantitySpan.textContent = quantity;
        totalSpan.textContent = (quantity * price).toFixed(2);
      }
    });
  });
});


function product(item){
  urlString = item.ownerDocument.URL
  let parsedUrl = new URL(urlString);
  let orderId = parsedUrl.searchParams.get("order_id");
  

  window.location.href = `/admin/products/${orderId}`

}



document.addEventListener("DOMContentLoaded", function () {

  const radios = document.querySelectorAll("input[name='selected_address_id']");

  radios.forEach(radio => {
    radio.addEventListener("change", () => {
      const selectedRadio = document.querySelector("input[name='selected_address_id']:checked");
      if (selectedRadio) {
        const selectedId = selectedRadio.value;
        console.log("Selected Address ID:", selectedId); 

        const url = new URL(window.location.href); 
        const productId = url.searchParams.get("product_id");
        window.location.href = `/admin/buy?product_id=${productId}&selected_address_id=${selectedId}`;
      }
    });
  });
});

