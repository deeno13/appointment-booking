import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr"
export default class extends Controller {
  connect() {
    flatpickr(".start-time-field", {
      enableTime: true,
      dateFormat: "Y-m-d H:i",
      minDate: this.setDefaultDateTime(),
      altInput: true,
      altFormat: "F j, Y h:i K",
      altInputClass: "hidden",
      inline: true,
      minuteIncrement: 60,
      disableMobile: true,
      defaultDate: this.setDefaultDateTime(),
    });

    this.setEndTime();
  }

  getCurrentDateTime() {
    return new Date();
  }

  setDefaultDateTime() {
    const defaultDateTime = this.getCurrentDateTime();

    defaultDateTime.setHours(defaultDateTime.getHours() + 1);
    defaultDateTime.setMinutes(0);

    return defaultDateTime;
  }

  setEndTime() {
    const startTime = new Date(
      document.querySelector(".start-time-field").value
    );

    const endTime = startTime.setHours(startTime.getHours() + 1);

    document.querySelector(".end-time-field").value =
      this.formatUnixTimestamp(endTime);
  }

  formatUnixTimestamp(timestamp) {
    const date = new Date(timestamp);

    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    const hours = String(date.getHours()).padStart(2, "0");
    const minutes = String(date.getMinutes()).padStart(2, "0");

    return `${year}-${month}-${day} ${hours}:${minutes}`;
  }
}
