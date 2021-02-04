import React from 'react';

const fullName = (course) => `${course.name} ${course.subject}`;

const CourseSelector = ({ courses, onSelectedCourse }) => (
  <div className="mb-2">
    <select className="select" onChange={onSelectedCourse}>
      {courses.map((course, index) => (
        <option key={fullName(course)} value={index}>{fullName(course)}</option>
      ))}
    </select>
  </div>
);

export default CourseSelector;
