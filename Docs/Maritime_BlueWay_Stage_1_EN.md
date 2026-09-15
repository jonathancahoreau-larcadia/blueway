# Maritime BlueWay --- Condensed Stage 1 Report

**Portfolio Project --- HBTN France**\
**Team:** Vadim Gavet --- Jonathan Cahoreau --- Brice Fontaine\
**Project:** Maritime BlueWay\
**Stage 1:** Team Formation, Brainstorming and MVP

------------------------------------------------------------------------

## 1. Project Presentation

**BlueWay** is a community mobile application for all sailors.

Its goal is to create a real **"Waze for the sea"** that allows users to
quickly share geolocated information about:

-   marine animals;
-   obstructions;
-   pollution.

The project answers a real need observed while sailing: when an event
happens at sea, it is often difficult to quickly share recent
information with other sailors and link it to an accurate position.

One example that inspired the project is **interactions with orcas**,
where sailors may not have recent information about the affected areas.

------------------------------------------------------------------------

## 2. Team Formation and Roles

  -----------------------------------------------------------------------
  Member                  Main Role               Reason
  ----------------------- ----------------------- -----------------------
  **Jonathan Cahoreau**   Project Manager,        BlueWay is his idea; he
                          Product Owner, Backend  leads the product
                                                  vision and is more
                                                  comfortable with
                                                  backend development.

  **Vadim Gavet**         Frontend, Backend,      Experience in frontend
                          Linear organization     and backend; manages
                                                  work tracking in
                                                  Linear.

  **Brice Fontaine**      Backend, Database       Experience in backend
                                                  development and
                                                  databases.
  -----------------------------------------------------------------------

The team remains flexible: each member has a main responsibility, but
can work on other parts if necessary.

### Organization

-   **Discord**: main communication tool.
-   **Daily meeting**: work completed, planned work, and blockers.
-   **Linear**: task organization and tracking.
-   **GitHub**: code, Pull Requests, and branch management.
-   **Decisions**: the team tries to reach an agreement; Jonathan makes
    the final decision if necessary.

### Git Workflow

``` text
feature/... -> Pull Request -> dev -> tests / validation -> Pull Request -> main
```

A feature is considered finished when:

-   the code works;
-   the tests pass;
-   the Pull Request is reviewed and approved;
-   the code is merged into `dev`.

------------------------------------------------------------------------

## 3. Brainstorming and Idea Selection

BlueWay was first proposed by Jonathan.

The team did not compare several different project ideas: all three
members quickly agreed on BlueWay. The idea was mainly evaluated using
two criteria:

-   **real usefulness**;
-   **technical challenge**.

### Reasons for Choosing BlueWay

-   answer a real need at sea;
-   work in the maritime field;
-   improve navigation support;
-   take on a technical challenge combining mobile development, GPS,
    mapping, notifications, backend development, and camera data
    processing.

------------------------------------------------------------------------

## 4. MVP Definition

BlueWay must allow an authenticated user to view a map and create a
report in two ways:

### Manual Mode

The user directly touches the map to place the report.

### Photo Mode

The user takes a photo of an object or an animal. The application then
tries to estimate its position using:

-   the phone's GPS position;
-   orientation / compass;
-   phone tilt;
-   focal length / zoom;
-   focus.

The user can manually correct the estimated position before publishing
the report.

Once published, the report is visible on the map and sends a
notification to users located within a radius of **10 nautical miles**.

------------------------------------------------------------------------

## 5. Main MVP Features

### User Account

-   username;
-   email;
-   password;
-   boat name;
-   boat type;
-   email address verification;
-   forgotten password;
-   email / password login;
-   Google / Apple login considered for the future.

### Reports

Required categories:

-   **marine animal**;
-   **obstruction**;
-   **pollution**.

A report contains:

-   a position;
-   a category;
-   a creation time;
-   a required photo in photo mode;
-   an optional photo in manual mode;
-   an optional description;
-   the author's username.

Users can edit or delete their own reports.

### Map and Notifications

-   real-time GPS position;
-   nearby reports grouped into **clusters**;
-   automatic zoom when opening a cluster;
-   push notifications within a radius of **10 NM**;
-   the notification shows the report type and its distance;
-   opening the notification directly displays the report on the map;
-   background geolocation planned for nearby alerts.

### Life Cycle

-   **0 to 24 h**: active report;
-   **24 h to 72 h**: expired report, displayed in grey;
-   after that: removed from the public map;
-   personal history visible for **30 days**;
-   after 30 days: hidden from the user but kept on the server for
    future analysis.

------------------------------------------------------------------------

## 6. Initial Technical Stack

  Element            Choice
  ------------------ ------------------------------------------------
  Application        Native mobile
  Platforms          Android + iOS
  Mobile framework   Flutter
  Backend            Python
  API framework      To be decided
  Database           PostgreSQL
  Mapping            To be decided
  Hosting            To be decided
  Photos             Dedicated cloud storage, service to be decided

------------------------------------------------------------------------

## 7. MVP Scope

### Included

-   Flutter application for Android and iOS;
-   authentication;
-   map with GPS;
-   manual reports;
-   photo reports with position estimation;
-   marine animal / obstruction / pollution categories;
-   notifications within a 10 NM radius;
-   clusters;
-   report life cycle management;
-   user history;
-   administrative moderation on the backend;
-   cloud photo storage.

### After the MVP

-   AI recognition;
-   confidence score based on recognition of the same object;
-   user reputation system;
-   routing / navigation;
-   marine weather;
-   GRIB data;
-   offline mode and delayed synchronization;
-   official reports from ports, CROSS, or authorities;
-   dedicated administration area in the application.

------------------------------------------------------------------------

## 8. Main Risks

  -----------------------------------------------------------------------
  Risk                                Planned Response
  ----------------------------------- -----------------------------------
  Inaccurate position estimation from Tests in real conditions and
  a photo                             adjustments

  False information / abuse           Moderation, content removal,
                                      account suspension

  Battery / GPS consumption           Adjust the frequency of GPS updates
  -----------------------------------------------------------------------

Estimating a position from a photo is the main technical challenge of
the MVP.

------------------------------------------------------------------------

## 9. Potential Stakeholders

The following organizations are not involved in the project yet, but
they could be involved in the future:

-   **Ports / harbour master's offices**: share safety information.
-   **SNSM**: view reports and receive useful information for rescue
    operations.
-   **CROSS**: monitor high-risk areas, use reports, and send alerts.
-   **Nautical clubs**: encourage people to use the application.
-   **Sailing schools**: raise awareness about maritime safety.
-   **Environmental organizations**: monitor pollution, marine animals,
    and sensitive areas.
-   **Local authorities**: analyze sensitive coastal areas.
-   **Armed forces**: use some reports related to maritime safety.

In the future, some organizations could publish clearly identified
**official reports** in the application.

------------------------------------------------------------------------

## 10. MVP Validation

The three team members plan to carry out **tests in real conditions on a
boat**.

The tests will check:

-   the GPS position;
-   the display of the report on the map;
-   the reception of notifications within the 10 NM radius;
-   the use of photo-based position estimation.

### Demo Scenario

A user logs in, views the map, and creates a report either manually or
from a photo. In the second case, BlueWay estimates the position,
publishes the report, and users within a 10 NM radius see it appear and
receive a notification.

### Success Criteria

The MVP is considered successful when the main features work **from end
to end** and can be demonstrated **without major blockers**.

------------------------------------------------------------------------

## Conclusion

BlueWay aims to turn individual observations into community information
that sailors can quickly use.

The MVP focuses on a clear set of core features: **authentication, map,
GPS, geolocated reports, photo-based position estimation, and nearby
notifications**.

In the longer term, BlueWay could become a real **"Waze for the sea"**,
be used by ports or rescue services, and become a platform for
monitoring sensitive areas.
