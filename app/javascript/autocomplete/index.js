window.addEventListener('DOMContentLoaded', (event) => {
  const input = document.querySelector("#autocomplete__input")
  const results = document.querySelector("#autocomplete__results")

  input.addEventListener('input', async (event) => {
    // fetch results
    const qs = (new URLSearchParams({q: input.value})).toString()
    const response = await fetch(`http://localhost:3000/subjects/complete.json?${qs}`, {
      "Content-type": "application/json",
      "Accept": "application/json"
    })
    const hits = await response.json()

    // empty previous menu items
    while (results.firstChild) {
      results.removeChild(results.firstChild)
    }

    // add new menu items
    hits.forEach(hit => {
      // <li>
      const item = document.createElement("li")
      item.classList.add("autocomplete__results__hit")
      // <a>
      const link = document.createElement("a")
      link.innerText = hit._source.name
      link.setAttribute("href", `http://localhost:3000/subjects/${hit._id}`)
      // add li > a to dom
      item.appendChild(link)
      results.appendChild(item)
    })
  })
});
