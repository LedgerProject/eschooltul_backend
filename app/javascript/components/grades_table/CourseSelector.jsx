import React from 'react';

const fullName = (course) => `${course.name} ${course.subject}`;

const CourseSelector = (props) => (
  <div className="mb-2">
    <select 
    className="select" 
    onChange={props.onSelectedCourse}
  >
    {props.courses.map((course, index) => (
      <option key={fullName(course)} value={index}>
        {fullName(course)}
      </option>
    ))}
  </select>
  </div>
);

export default CourseSelector
