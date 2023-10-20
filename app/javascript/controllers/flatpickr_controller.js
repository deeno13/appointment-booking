import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr"
export default class extends Controller {
  connect() {
    console.log("connected");

    flatpickr(".start-time-field", {
      enableTime: true,
      dateFormat: "Y-m-d H:i",
      minDate: this.setDefaultDateTime(),
      altInput: true,
      altFormat: "F j, Y h:i K",
      maxTime: this.setDefaultDateTime(),
      minuteIncrement: 60,
      disableMobile: true,
      defaultDate: this.setDefaultDateTime(),
    });

    flatpickr(".end-time-field", {
      enableTime: true,
      dateFormat: "Y-m-d H:i",
      minDate: "today",
      altInput: true,
      altFormat: "F j, Y h:i K",
      minuteIncrement: 60,
      disableMobile: true,
      defaultDate: this.setEndTime(),
    });
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

    return startTime.setHours(startTime.getHours() + 1);
  }
}
