import React from 'react';
import SubmitButton from './buttons/SubmitButton';
import Button from './buttons/Button';

const GradesFooter = ({ onSave, selectedCourseID }) => (
  <div className="mt-8 flex justify-between items-stretch">
    <div>
      <SubmitButton
        onClick={onSave}
        className="bg-green-500 hover:bg-green-900"
        iconClass="far fa-save"
        text="Save grades"
      />
    </div>
    <div>
      <Button
        url={`/grades/courses/${selectedCourseID}/lessons`}
        className="bg-purple-500 hover:bg-purple-900"
        iconClass="fas fa-book"
        text="Lessons"
      />
      <Button
        url={`/grades/courses/${selectedCourseID}/terms`}
        className="bg-blue-500 hover:bg-blue-900 ml-2"
        iconClass="fas fa-calendar-alt"
        text="Terms"
      />
    </div>
  </div>
);

export default GradesFooter;
