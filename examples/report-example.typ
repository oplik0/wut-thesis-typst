// For local testing, use: #import "../src/lib.typ": simple-doc, callout
// For published package, use:
#import "@preview/wut-thesis:0.1.1": simple-doc, callout

#show: simple-doc.with(
  doc-type: "report",
  title: "Software Development Progress Report",
  author: ("Alice Johnson", "Bob Williams"),
  course: "SE 401: Software Engineering Project",
  instructor: "Dr. Michael Brown",
  date: datetime(year: 2025, month: 11, day: 4),
  lang: "en",
  show-toc: true,
  show-tables: true,
)

= Executive Summary

This report summarizes the progress of our software development project for the period October 1 - November 3, 2025. The team has completed the initial development phase and is now entering the testing phase.

#callout(type: "info")[
  Project Status: *On Track* | Completion: 65%
]

= Project Overview

== Scope

The project aims to develop a web-based task management application with the following features:
- User authentication and authorization
- Task creation, assignment, and tracking
- Real-time notifications
- Team collaboration tools
- Analytics dashboard

== Timeline

#figure(
  table(
    columns: 4,
    [*Phase*], [*Start Date*], [*End Date*], [*Status*],
    [Planning], [Sept 1], [Sept 15], [✓ Complete],
    [Design], [Sept 16], [Sept 30], [✓ Complete],
    [Development], [Oct 1], [Nov 15], [🔄 In Progress],
    [Testing], [Nov 16], [Dec 15], [⏸ Pending],
    [Deployment], [Dec 16], [Dec 20], [⏸ Pending],
  ),
  caption: [Project timeline and status]
)

= Completed Tasks

== Backend Development

The backend API has been fully implemented using Node.js and Express. Key accomplishments include:
- RESTful API endpoints for all core features
- Database schema design and implementation (PostgreSQL)
- Authentication system using JWT tokens
- Input validation and error handling
- API documentation using Swagger

== Frontend Development

Approximately 70% of the frontend has been completed:
- React-based component architecture
- Responsive design using Tailwind CSS
- User authentication flows
- Task management interface
- Basic notification system

= Current Challenges

#callout(type: "warning", title: "Integration Issues")[
  We encountered some challenges integrating the real-time notification system with the existing architecture. The WebSocket connection occasionally drops under high load.
]

== Technical Debt

Some areas require refactoring:
1. User interface components need better state management
2. Database queries could be optimized for better performance
3. Test coverage is currently at 45% (target: 80%)

= Next Steps

== Immediate Priorities (Next 2 Weeks)

- Fix WebSocket stability issues
- Complete remaining frontend features
- Increase test coverage to 80%
- Begin user acceptance testing

== Resource Requirements

We may need additional resources for:
- Cloud hosting setup and configuration
- Performance testing tools
- User testing participants

= Budget Status

#figure(
  table(
    columns: 3,
    [*Category*], [*Budgeted*], [*Spent*],
    [Development Tools], [\$2,000], [\$1,800],
    [Cloud Services], [\$1,500], [\$800],
    [Testing], [\$1,000], [\$200],
    [Miscellaneous], [\$500], [\$350],
    [*Total*], [*\$5,000*], [*\$3,150*],
  ),
  caption: [Budget breakdown]
)

Currently at 63% of budget utilized, which aligns well with our 65% completion rate.

= Risk Assessment

#figure(
  table(
    columns: 4,
    [*Risk*], [*Probability*], [*Impact*], [*Mitigation*],
    [WebSocket issues], [Medium], [High], [Consulting with expert],
    [Testing delays], [Low], [Medium], [Early start on testing],
    [Scope creep], [Medium], [High], [Strict change control],
  ),
  caption: [Risk analysis]
)

= Conclusion

The project is progressing well despite some technical challenges. With focused effort on the identified issues, we remain confident in meeting the December 20 deadline.

== Recommendations

1. Schedule a technical review session to address the WebSocket issues
2. Allocate more time for testing in the upcoming sprint
3. Begin documentation for user manual and deployment guide
