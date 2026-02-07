import { Controller } from "@hotwired/stimulus"
import * as d3 from "d3"
import { sankey, sankeyLinkHorizontal, sankeyJustify } from "d3-sankey"

export default class extends Controller {
  static values = { url: String }
  static targets = ["canvas"]

  connect() {
    this.draw()
  }

  disconnect() {
    d3.select(this.canvasTarget).selectAll("*").remove()
  }

  formatDollars(value) {
    if (value >= 1_000_000) return `$${(value / 1_000_000).toFixed(3)}M`
    if (value >= 1_000) return `$${d3.format(",")(Math.round(value))}`
    return `$${Math.round(value)}`
  }

  async draw() {
    const raw = await fetch(this.urlValue).then(r => r.json())
    if (!raw.links.length) {
      this.canvasTarget.innerHTML = '<p class="text-gray-400 text-sm text-center py-8">No data yet. Add accounts and record values to see the Sankey diagram.</p>'
      return
    }

    const container = this.canvasTarget
    const width = container.parentElement.clientWidth
    const height = 530
    const margin = { top: 10, right: 150, bottom: 10, left: 150 }

    const svg = d3.select(container)
      .append("svg")
      .attr("width", width)
      .attr("height", height)

    const sankeyGenerator = sankey()
      .nodeId(d => d.name)
      .nodeAlign(sankeyJustify)
      .nodeWidth(12)
      .nodePadding(14)
      .extent([[margin.left, margin.top], [width - margin.right, height - margin.bottom]])

    const { nodes, links } = sankeyGenerator(raw)

    const color = d3.scaleOrdinal(d3.schemeTableau10)

    // Links
    svg.append("g")
      .selectAll("path")
      .data(links)
      .join("path")
      .attr("d", sankeyLinkHorizontal())
      .attr("fill", "none")
      .attr("stroke", d => color(d.source.name))
      .attr("stroke-opacity", 0.35)
      .attr("stroke-width", d => Math.max(1, d.width))
      .append("title")
      .text(d => `${d.source.name} → ${d.target.name}: ${this.formatDollars(d.value)}`)

    // Nodes
    svg.append("g")
      .selectAll("rect")
      .data(nodes)
      .join("rect")
      .attr("x", d => d.x0)
      .attr("y", d => d.y0)
      .attr("height", d => d.y1 - d.y0)
      .attr("width", d => d.x1 - d.x0)
      .attr("fill", d => color(d.name))
      .append("title")
      .text(d => `${d.name}: ${this.formatDollars(d.value)}`)

    // Labels with dollar amounts
    svg.append("g")
      .selectAll("text")
      .data(nodes)
      .join("text")
      .attr("x", d => d.x0 < width / 2 ? d.x1 + 8 : d.x0 - 8)
      .attr("y", d => (d.y1 + d.y0) / 2)
      .attr("dy", "0.35em")
      .attr("text-anchor", d => d.x0 < width / 2 ? "start" : "end")
      .attr("font-size", "12px")
      .attr("font-weight", "500")
      .attr("fill", "#374151")
      .text(d => `${d.name}: ${this.formatDollars(d.value)}`)
  }
}
