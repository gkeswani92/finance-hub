import { Controller } from "@hotwired/stimulus"
import * as d3 from "d3"

export default class extends Controller {
  static values = { url: String }
  static targets = ["canvas"]

  connect() {
    this.load()
  }

  disconnect() {
    d3.select(this.canvasTarget).selectAll("*").remove()
  }

  async load() {
    const data = await fetch(this.urlValue).then(r => r.json())
    if (!data.length) {
      this.canvasTarget.innerHTML = '<p class="text-gray-400 text-sm text-center py-4">No data</p>'
      return
    }
    this.render(data)
  }

  render(data) {
    const container = this.canvasTarget
    d3.select(container).selectAll("*").remove()

    const width = 200
    const height = 200
    const radius = Math.min(width, height) / 2
    const innerRadius = radius * 0.6

    const colors = d3.scaleOrdinal()
      .domain(data.map(d => d.name))
      .range(data.map((d, i) => d.color || d3.schemeTableau10[i % 10]))

    const pie = d3.pie()
      .value(d => d.value)
      .sort(null)
      .padAngle(0.02)

    const arc = d3.arc()
      .innerRadius(innerRadius)
      .outerRadius(radius)

    const svg = d3.select(container)
      .append("svg")
      .attr("width", width)
      .attr("height", height)
      .append("g")
      .attr("transform", `translate(${width / 2},${height / 2})`)

    svg.selectAll("path")
      .data(pie(data))
      .join("path")
      .attr("d", arc)
      .attr("fill", d => colors(d.data.name))
      .attr("stroke", "white")
      .attr("stroke-width", 2)

    // Total in center
    const total = data.reduce((sum, d) => sum + d.value, 0)
    const formatted = total >= 1e6
      ? `$${(total / 1e6).toFixed(1)}M`
      : `$${d3.format(",")(Math.round(total))}`

    svg.append("text")
      .attr("text-anchor", "middle")
      .attr("dy", "-0.2em")
      .attr("fill", "#111827")
      .attr("font-size", "14px")
      .attr("font-weight", "700")
      .text(formatted)

    svg.append("text")
      .attr("text-anchor", "middle")
      .attr("dy", "1.2em")
      .attr("fill", "#9ca3af")
      .attr("font-size", "10px")
      .text("Total")

    // Legend
    const legend = d3.select(container)
      .append("div")
      .attr("class", "mt-4 space-y-1.5 w-full")

    data.forEach(d => {
      const pct = ((d.value / total) * 100).toFixed(1)
      const val = d.value >= 1e6
        ? `$${(d.value / 1e6).toFixed(1)}M`
        : `$${d3.format(",")(Math.round(d.value))}`

      legend.append("div")
        .attr("class", "flex items-center justify-between text-xs")
        .html(`
          <div class="flex items-center gap-2">
            <span class="w-2.5 h-2.5 rounded-full flex-shrink-0" style="background-color: ${colors(d.name)}"></span>
            <span class="text-gray-700">${d.name}</span>
          </div>
          <div class="flex items-center gap-2">
            <span class="text-gray-500">${pct}%</span>
            <span class="text-gray-900 font-medium">${val}</span>
          </div>
        `)
    })
  }
}
