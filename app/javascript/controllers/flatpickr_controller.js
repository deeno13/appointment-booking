import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr"
export default class extends Controller {
  // Set a flatpickr datetime picker instance for the start time field
  connect() {
    flatpickr(".start-time-field", {
      enableTime: true,
      dateFormat: "Y-m-d H:i",
      minDate: this.setDefaultDateTime(), // Set the minimum date to the current date and time
      altInput: true,
      altFormat: "F j, Y h:i K",
      altInputClass: "hidden", // Hide the input field
      inline: true, // Show the calendar inline
      minuteIncrement: 60, // Only allow selection of hours
      disableMobile: true,
      defaultDate: this.setDefaultDateTime(),
    });

    // Set the end time for first page load
    this.setEndTime();
  }

  getDateParam() {
    const url = new URL(window.location.href);
    return new Date("2023-10-23");
  }

  getCurrentDateTime() {
    return new Date();
  }

  setDefaultDateTime() {
    const defaultDateTime = this.getCurrentDateTime();

    //  Set the default date to the current date and time with the time rounded up to the next hour
    //  e.g. if it's 10:30am, set the default and minimum time to 11:00am
    defaultDateTime.setHours(defaultDateTime.getHours() + 1);
    defaultDateTime.setMinutes(0);

    return defaultDateTime;
  }

  setEndTime() {
    const startTime = new Date(
      document.querySelector(".start-time-field").value
    );

    // Automatically set the end time to 1 hour after the start time so the user doesn't have to
    const endTime = startTime.setHours(startTime.getHours() + 1);

    document.querySelector(".end-time-field").value =
      this.formatUnixTimestamp(endTime);
  }

  // Format a unix timestamp to YYYY-MM-DD HH:MM format so flatpickr can parse it
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
