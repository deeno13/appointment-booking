import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="appointments"
export default class extends Controller {
  connect() {
    Turbo.visit(window.location.href, { frame: "slots" });
  }

  addDateQueryParam(event) {
    const newUrl = new URL(window.location.href);
    const dateTime = document.getElementById("appointment_start_time").value;
    const date = dateTime.split(" ")[0];
    newUrl.searchParams.set("date", date);
    window.history.pushState({}, "", newUrl);
    Turbo.visit(window.location.href, { frame: "slots" });
  }
}
