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
      .attr("fill", "rgba(13,148,136,0.08)")
      .attr("d", area)

    svg.append("path")
      .datum(parsed)
      .attr("fill", "none")
      .attr("stroke", "#0d9488")
      .attr("stroke-width", 2)
      .attr("d", line)

    // Dots
    svg.selectAll(".dot")
      .data(parsed)
      .join("circle")
      .attr("class", "dot")
      .attr("cx", d => x(d.date))
      .attr("cy", d => y(d.value))
      .attr("r", 3)
      .attr("fill", "#0d9488")

    // Axes
    svg.append("g")
      .attr("transform", `translate(0,${height - margin.bottom})`)
      .call(d3.axisBottom(x).ticks(5).tickFormat(d3.timeFormat("%b %Y")))
      .attr("color", "#9ca3af")

    svg.append("g")
      .attr("transform", `translate(${margin.left},0)`)
      .call(d3.axisLeft(y).ticks(5).tickFormat(d => `$${d3.format(",")(d)}`))
      .attr("color", "#9ca3af")

    // Hover tooltip
    const trackLine = svg.append("line")
      .attr("stroke", "#9ca3af")
      .attr("stroke-width", 1)
      .attr("stroke-dasharray", "4,3")
      .attr("y1", margin.top)
      .attr("y2", height - margin.bottom)
      .style("opacity", 0)

    const hoverDot = svg.append("circle")
      .attr("r", 5)
      .attr("fill", "#0d9488")
      .attr("stroke", "white")
      .attr("stroke-width", 2)
      .style("opacity", 0)

    const tooltip = d3.select(container)
      .append("div")
      .attr("class", "absolute pointer-events-none bg-white border border-gray-200 rounded-lg shadow-lg px-3 py-2 text-sm")
      .style("opacity", 0)

    container.style.position = "relative"

    const bisect = d3.bisector(d => d.date).left
    const formatCurrency = d3.format(",.0f")
    const formatDate = d3.timeFormat("%b %d, %Y")

    svg.append("rect")
      .attr("fill", "none")
      .attr("pointer-events", "all")
      .attr("x", margin.left)
      .attr("y", margin.top)
      .attr("width", width - margin.left - margin.right)
      .attr("height", height - margin.top - margin.bottom)
      .on("mousemove", (event) => {
        const [mx] = d3.pointer(event)
        const date = x.invert(mx)
        const i = Math.min(bisect(parsed, date), parsed.length - 1)
        const d = i > 0 && (date - parsed[i-1].date) < (parsed[i].date - date) ? parsed[i-1] : parsed[i]

        const cx = x(d.date)
        const cy = y(d.value)

        trackLine.attr("x1", cx).attr("x2", cx).style("opacity", 1)
        hoverDot.attr("cx", cx).attr("cy", cy).style("opacity", 1)

        tooltip
          .html(`
            <div class="text-xs text-gray-400 font-medium">${formatDate(d.date)}</div>
            <div class="text-sm font-bold text-teal-600 mt-0.5">$${formatCurrency(d.value)}</div>
          `)
          .style("opacity", 1)
          .style("left", `${Math.min(cx + 12, width - 150)}px`)
          .style("top", `${cy - 16}px`)
      })
      .on("mouseleave", () => {
        trackLine.style("opacity", 0)
        hoverDot.style("opacity", 0)
        tooltip.style("opacity", 0)
      })
  }
}
