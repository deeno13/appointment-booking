# Book.app: Appointment Booking Software

## Overview

Book.app is an appointment booking software developed using Ruby on Rails. This application allows trainers to set their availabilities within a specified time range for a day of the week and enables users to book appointments within those availabilities.

## Requirements

- Ruby 3.2.2
- Rails 7.1.1
- TailwindCSS
- PostgreSQL
- [Flatpickr](https://flatpickr.js.org/)

## Getting Started

1. Clone the repository and `cd` into the directory

```bash
git clone https://github.com/deeno13/appointment-booking.git
cd appointment-booking
```

2. Install dependencies

```bash
bundle install
```

3. Create and migrate the database

```bash
rails db:create && rails db:migrate
```

4. Seed the database with sample data: `rails db:seed` (optional)
5. Start the Rails server

```bash
bin/dev
```

Visit `http://localhost:3000` to access the application.

## Models

### 1. Trainer

The `Trainer` model represents the trainer or service who sets that users can book their appointments with.

#### Attributes

- `name:string` - The name of the trainer.

#### Associations

```ruby
has_many :availabilities # A trainer can have multiple availabilities.
has_many :appointments # A trainer can have multiple appointments.
```

#### Example Usage

```ruby
trainer = Trainer.create(name: 'John Doe')
```

### 2. Availability

The `Availability` model represents the availabilities set by trainers.

#### Attributes

- `trainer:references` - Foreign key linking the availability to a trainer.
- `day_of_week:integer` - The day of which the availability is set for.
- `start_time:datetime` - The start time of the availability.
- `end_time:datetime` - The end time of the availability.

#### Associations

Each availability can only belong to one trainer

```ruby
belongs_to :trainer
```

#### Example Usage

```ruby
availability = Availability.create(trainer_id: 1, day_of_week: 1, start_time: '09:00', end_time: '17:00')
```

### 3. Appointment

The `Appointment` model represents booked appointments.

#### Attributes

- `trainer:references` - Foreign key linking the appointment to a trainer.
- `start_time:datetime` - The start time of the appointment.
- `end_time:datetime` - The end time of the appointment.

#### Associations

Each appointment can only belong to one trainer

```ruby
belongs_to :trainer
```

#### Example Usage

```ruby
appointment = Appointment.create(trainer_id: 1, start_time: '2023-10-23 10:00', end_time: '2023-10-23 11:00')
```

## Future Considerations

### Availability Overrides

Currently, when a trainer sets an availability for a day of the week (e.g. Monday), it sets that time range for all Mondays onwards. If there happens to be times when a trainer is unavailable on a particular Monday, they're unable to override the availability for that day.

One approach I can think of for now is to

- Add an `Override` model below attributes:
  - `trainer:references`
  - `start_time:datetime`
  - `end_time:datetime`
- Modify the existing validations and queries to also account for overrides along with existing appointments.
- Display the time slots list appropriately with something like "Trainer is unavailable on that day", similar to the current validation for when no availability is found for a day.

### Problem with Overlapping Availabilities

At the moment, a trainer adds an availability for a day of the week by selecting the day, start time, and end time with select dropdowns and this can cause overlapping availabilities to be submitted to the database.

One solution I can think of right now is to validate the `day_of_week` attribute of the `Availability` model to have `uniqeness: true` to prevent saving duplicate availabilities for the same day.

A better solution I think would be to do something similar to [Cal.com](https://cal.com/) where each day of the week have toggles and time range fields ready instead of having to create one for a certain day of the week.

### User Authentication and Authorization

As of now, the users for the system are not specified and anyone can create, edit, or destroy any trainer, availability, or appointments. By using [Devise](https://github.com/heartcombo/devise), this can be done either by using:

- **Unimodel approach** with integer roles where both a User and Trainer share the same model so there's no need to customize views and controllers individually.
- **Multimodel approach** where User and Trainer have their own models which can be useful for more complex needs like custom login pages for each of them.

### User Specific Timezones

The software currently uses "Asia/Kuala Lumpur" which is GMT+8 as the default timezone. Having the dates and times adjust according to different user timezones would be convenient. Although not tested, but instead of setting the default timezone in the application level

```ruby
module AppointmentBooking
  class Application < Rails::Application
    config.time_zone = "Asia/Kuala_Lumpur"
  end
end
```

Maybe the time zone can be set in the controller level instead, with the help of `current_user` from Devise

```ruby
before_action :set_current_user_timezone

def set_current_user_timezone
  if current_user
    Time.zone = current_user.time_zone
  end
end
```

### Different Types of Appointments

Currently users can only create 1-hour appointments with trainers. Also inspired by Cal.com, appointments of different durations might be doable in the future.

One approach I can think of is to:

- Add a `duration:integer` attribute to the `Appointment` model
- Set the duration as a query parameter so the Stimulus controllers can determine the duration to set the value of the end time field:
  ```javascript
  // e.g. ?duration=30
  const durationParam = new URL(window.location.href).searchParams.get(
    "duration"
  );
  const duration = parseInt(durationParam);
  const endTime = startTime.setHours(startTime.getMinutes() + duration);
  ```

### Notifications and Alerts

The success and error messages for when a record is submitted can be further improved to provide more context or clarity to the user as to what's wrong with their form submission.

### Testing

For some reason, my development machine is unable to perform tests properly which is probably due to my current setup of WSL2 in Windows and the selenium drivers can't quite do the tests from a headless Ubuntu installation.

### Code Maintainability

A lot parts of the project have very long lines of codes and it will be difficult to read as the project grows. I'm considering using [RuboCop](https://github.com/rubocop/rubocop) to lint and format my code in a more standardized manner. My IDE setup doesn't seem to work with RuboCop and more investigation is needed to see why.

There are also some parts of the project like the `AvailabilitiesHelper` that uses SQL queries probably can be improved to use `scope` in the future. This also applies to some of the models that may look a little cluttered at the moment.

The query for getting a trainer's availabilities in the `AvailabilitiesHelper` is quite a hacky solution and is not something I'm proud of. It definitely needs further refactoring when I manage to understand the process better.

### UI/UX Improvements

The current state for the project is very messy with no clear direction of aesthetics. As the project is heavily inspired by Cal.com, some of the elements may need better styling.

The project is currently **NOT** optimized for mobile devices and that is definitely a priority consideration in the future.

The views could also use empty states for when there are no trainers, availabilities, or appointments rendered because as of now there is no logic or implementation to cover that situation.
