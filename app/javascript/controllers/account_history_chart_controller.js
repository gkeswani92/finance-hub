import { Controller } from "@hotwired/stimulus"
import * as d3 from "d3"

export default class extends Controller {
  static values = { data: Array }
  static targets = ["canvas"]

  connect() {
    this.draw()
  }

  disconnect() {
    d3.select(this.canvasTarget).selectAll("*").remove()
  }

  draw() {
    const data = this.dataValue
    if (!data.length) return

    const container = this.canvasTarget
    const width = container.parentElement.clientWidth
    const height = 240
    const margin = { top: 20, right: 30, bottom: 30, left: 70 }

    const svg = d3.select(container)
      .append("svg")
      .attr("width", width)
      .attr("height", height)

    const parseDate = d3.timeParse("%Y-%m-%d")
    const parsed = data.map(d => ({ date: parseDate(d.date), value: d.value }))
      .sort((a, b) => a.date - b.date)

    const x = d3.scaleTime()
      .domain(d3.extent(parsed, d => d.date))
      .range([margin.left, width - margin.right])

    const y = d3.scaleLinear()
      .domain([0, d3.max(parsed, d => d.value) * 1.1])
      .range([height - margin.bottom, margin.top])

    const line = d3.line()
      .x(d => x(d.date))
      .y(d => y(d.value))
      .curve(d3.curveMonotoneX)

    const area = d3.area()
      .x(d => x(d.date))
      .y0(y(0))
      .y1(d => y(d.value))
      .curve(d3.curveMonotoneX)

    svg.append("path")
      .datum(parsed)
      .attr("fill", "rgba(59, 130, 246, 0.1)")
      .attr("d", area)

    svg.append("path")
      .datum(parsed)
      .attr("fill", "none")
      .attr("stroke", "#2563eb")
      .attr("stroke-width", 2)
      .attr("d", line)

    // Dots
    svg.selectAll("circle")
      .data(parsed)
      .join("circle")
      .attr("cx", d => x(d.date))
      .attr("cy", d => y(d.value))
      .attr("r", 3)
      .attr("fill", "#2563eb")

    // Axes
    svg.append("g")
      .attr("transform", `translate(0,${height - margin.bottom})`)
      .call(d3.axisBottom(x).ticks(5).tickFormat(d3.timeFormat("%b %Y")))
      .attr("color", "#9ca3af")

    svg.append("g")
      .attr("transform", `translate(${margin.left},0)`)
      .call(d3.axisLeft(y).ticks(5).tickFormat(d => `$${d3.format(",")(d)}`))
      .attr("color", "#9ca3af")
  }
}
