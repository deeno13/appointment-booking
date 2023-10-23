import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="appointments"
export default class extends Controller {
  // Loads the slots frame when the page loads
  connect() {
    Turbo.visit(window.location.href, { frame: "slots" });
  }

  // Sets the date query param to the selected date in datepicker
  //  and reload the slots frame so it can show the time slots for that day
  addDateQueryParam(event) {
    const newUrl = new URL(window.location.href);
    const dateTime = document.getElementById("appointment_start_time").value;
    const date = dateTime.split(" ")[0];
    newUrl.searchParams.set("date", date);
    window.history.pushState({}, "", newUrl);
    Turbo.visit(window.location.href, { frame: "slots" });
  }
}
