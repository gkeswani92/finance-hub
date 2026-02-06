import { Controller } from "@hotwired/stimulus"
import * as d3 from "d3"

export default class extends Controller {
  static values = { url: String }
  static targets = ["canvas"]

  connect() {
    this.draw()
  }

  disconnect() {
    d3.select(this.canvasTarget).selectAll("*").remove()
  }

  async draw() {
    const data = await fetch(this.urlValue).then(r => r.json())
    if (!data.length) {
      this.canvasTarget.innerHTML = '<p class="text-gray-400 text-sm text-center py-8">No data yet. Add accounts and record values to see the chart.</p>'
      return
    }

    const container = this.canvasTarget
    const width = container.parentElement.clientWidth
    const height = 300
    const margin = { top: 20, right: 30, bottom: 30, left: 70 }

    const svg = d3.select(container)
      .append("svg")
      .attr("width", width)
      .attr("height", height)

    const parseDate = d3.timeParse("%Y-%m-%d")
    data.forEach(d => { d.date = parseDate(d.date) })

    const x = d3.scaleTime()
      .domain(d3.extent(data, d => d.date))
      .range([margin.left, width - margin.right])

    const y = d3.scaleLinear()
      .domain([0, d3.max(data, d => d.assets) * 1.1])
      .range([height - margin.bottom, margin.top])

    // Area for assets
    const area = d3.area()
      .x(d => x(d.date))
      .y0(y(0))
      .y1(d => y(d.assets))
      .curve(d3.curveMonotoneX)

    svg.append("path")
      .datum(data)
      .attr("fill", "rgba(59, 130, 246, 0.15)")
      .attr("d", area)

    // Net worth line
    const line = d3.line()
      .x(d => x(d.date))
      .y(d => y(d.net_worth))
      .curve(d3.curveMonotoneX)

    svg.append("path")
      .datum(data)
      .attr("fill", "none")
      .attr("stroke", "#2563eb")
      .attr("stroke-width", 2)
      .attr("d", line)

    // Axes
    svg.append("g")
      .attr("transform", `translate(0,${height - margin.bottom})`)
      .call(d3.axisBottom(x).ticks(6).tickFormat(d3.timeFormat("%b %Y")))
      .attr("color", "#9ca3af")

    svg.append("g")
      .attr("transform", `translate(${margin.left},0)`)
      .call(d3.axisLeft(y).ticks(5).tickFormat(d => `$${d3.format(",")(d)}`))
      .attr("color", "#9ca3af")
  }
}
