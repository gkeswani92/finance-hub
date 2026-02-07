import { Controller } from "@hotwired/stimulus"
import * as d3 from "d3"

export default class extends Controller {
  static values = { url: String }
  static targets = ["canvas", "periods"]

  connect() {
    this.period = "all"
    this.load()
  }

  disconnect() {
    this.clearChart()
  }

  async load() {
    const raw = await fetch(this.urlValue).then(r => r.json())
    if (!raw.length) {
      this.canvasTarget.innerHTML = '<p class="text-gray-400 text-sm text-center py-8">No data yet. Add accounts and record values to see the chart.</p>'
      return
    }

    const parseDate = d3.timeParse("%Y-%m-%d")
    this.allData = raw.map(d => ({ ...d, date: parseDate(d.date) }))
    this.render()
  }

  setPeriod(event) {
    this.period = event.currentTarget.dataset.period
    this.periodsTarget.querySelectorAll("button").forEach(btn => {
      const active = btn.dataset.period === this.period
      btn.classList.toggle("bg-teal-600", active)
      btn.classList.toggle("text-white", active)
      btn.classList.toggle("text-gray-400", !active)
    })
    this.render()
  }

  filterData() {
    if (!this.allData) return []
    if (this.period === "all") return this.allData

    const now = new Date()
    let cutoff
    switch (this.period) {
      case "1m":  cutoff = new Date(now.getFullYear(), now.getMonth() - 1, now.getDate()); break
      case "3m":  cutoff = new Date(now.getFullYear(), now.getMonth() - 3, now.getDate()); break
      case "1y":  cutoff = new Date(now.getFullYear() - 1, now.getMonth(), now.getDate()); break
      case "ytd": cutoff = new Date(now.getFullYear(), 0, 1); break
      default:    return this.allData
    }
    return this.allData.filter(d => d.date >= cutoff)
  }

  clearChart() {
    const container = this.canvasTarget
    d3.select(container).selectAll("*").remove()
    // Remove any tooltip divs we appended
    container.querySelectorAll("div").forEach(el => el.remove())
  }

  render() {
    this.clearChart()
    const data = this.filterData()
    if (data.length < 2) return

    const container = this.canvasTarget
    const width = container.parentElement.clientWidth
    const height = 300
    const margin = { top: 20, right: 30, bottom: 30, left: 70 }

    const svg = d3.select(container)
      .append("svg")
      .attr("width", width)
      .attr("height", height)

    const x = d3.scaleTime()
      .domain(d3.extent(data, d => d.date))
      .range([margin.left, width - margin.right])

    const yMin = d3.min(data, d => Math.min(d.net_worth, d.assets))
    const yMax = d3.max(data, d => Math.max(d.net_worth, d.assets))
    const yPad = (yMax - yMin) * 0.1 || yMax * 0.1
    const y = d3.scaleLinear()
      .domain([Math.max(0, yMin - yPad), yMax + yPad])
      .range([height - margin.bottom, margin.top])

    // Area for assets
    const area = d3.area()
      .x(d => x(d.date))
      .y0(height - margin.bottom)
      .y1(d => y(d.assets))
      .curve(d3.curveMonotoneX)

    svg.append("path")
      .datum(data)
      .attr("fill", "rgba(13,148,136,0.08)")
      .attr("d", area)

    // Net worth line
    const line = d3.line()
      .x(d => x(d.date))
      .y(d => y(d.net_worth))
      .curve(d3.curveMonotoneX)

    svg.append("path")
      .datum(data)
      .attr("fill", "none")
      .attr("stroke", "#0d9488")
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

    // Hover tooltip
    const trackLine = svg.append("line")
      .attr("stroke", "#9ca3af")
      .attr("stroke-width", 1)
      .attr("stroke-dasharray", "4,3")
      .attr("y1", margin.top)
      .attr("y2", height - margin.bottom)
      .style("opacity", 0)

    const dot = svg.append("circle")
      .attr("r", 4)
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
        const i = Math.min(bisect(data, date), data.length - 1)
        const d = i > 0 && (date - data[i-1].date) < (data[i].date - date) ? data[i-1] : data[i]

        const cx = x(d.date)
        const cy = y(d.net_worth)

        trackLine.attr("x1", cx).attr("x2", cx).style("opacity", 1)
        dot.attr("cx", cx).attr("cy", cy).style("opacity", 1)

        const nw = d.net_worth
        const nwLabel = nw >= 1e6
          ? `$${(nw / 1e6).toFixed(3)} M`
          : `$${formatCurrency(nw)}`

        tooltip
          .html(`
            <div class="text-xs text-gray-400 font-medium">${formatDate(d.date)}</div>
            <div class="text-sm font-bold text-teal-600 mt-0.5">${nwLabel}</div>
            <div class="text-xs text-gray-500 mt-0.5">Assets: $${formatCurrency(d.assets)}</div>
          `)
          .style("opacity", 1)
          .style("left", `${Math.min(cx + 12, width - 160)}px`)
          .style("top", `${cy - 20}px`)
      })
      .on("mouseleave", () => {
        trackLine.style("opacity", 0)
        dot.style("opacity", 0)
        tooltip.style("opacity", 0)
      })
  }
}
