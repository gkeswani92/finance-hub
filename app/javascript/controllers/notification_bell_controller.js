import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown", "badge", "list"]

  connect() {
    this.loadNotifications()
    this.handleClickOutside = (e) => {
      if (!this.element.contains(e.target)) {
        this.dropdownTarget.classList.add("hidden")
      }
    }
    document.addEventListener("click", this.handleClickOutside)
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside)
  }

  toggle() {
    this.dropdownTarget.classList.toggle("hidden")
  }

  async loadNotifications() {
    try {
      const resp = await fetch("/api/notifications")
      const data = await resp.json()

      const unread = data.filter(n => !n.is_read)
      if (unread.length > 0) {
        this.badgeTarget.textContent = unread.length
        this.badgeTarget.classList.remove("hidden")
      } else {
        this.badgeTarget.classList.add("hidden")
      }

      if (data.length > 0) {
        this.listTarget.innerHTML = data.map(n => `
          <div class="px-4 py-3 border-b border-gray-50 ${n.is_read ? 'opacity-60' : ''} hover:bg-gray-50 cursor-pointer"
               data-action="click->notification-bell#markRead" data-id="${n.id}">
            <p class="text-sm font-medium text-gray-900">${n.title}</p>
            <p class="text-xs text-gray-500 mt-0.5">${n.body || ''}</p>
          </div>
        `).join("")
      }
    } catch (e) {
      // Silently fail if notifications API isn't available
    }
  }

  async markRead(event) {
    const id = event.currentTarget.dataset.id
    if (!id) return
    try {
      await fetch(`/api/notifications/${id}/read`, {
        method: "PATCH",
        headers: { "X-CSRF-Token": document.querySelector("[name='csrf-token']")?.content }
      })
      this.loadNotifications()
    } catch (e) {
      // Ignore
    }
  }

  async markAllRead() {
    try {
      await fetch("/api/notifications/mark_all_read", {
        method: "PATCH",
        headers: { "X-CSRF-Token": document.querySelector("[name='csrf-token']")?.content }
      })
      this.loadNotifications()
    } catch (e) {
      // Ignore
    }
  }
}
