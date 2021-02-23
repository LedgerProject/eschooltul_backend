import React from 'react';
import SubmitButton from './buttons/SubmitButton';
import Button from './buttons/Button';
import { CSVLink } from "react-csv";

const GradesFooter = ({ onSave, selectedCourseID, printable, courseName }) => (
  <div className="mt-8 flex justify-between items-stretch">
    <div>
      <SubmitButton
        onClick={onSave}
        className="bg-green-500 hover:bg-green-900"
        iconClass="far fa-save"
        text="Save grades"
      />
      <CSVLink data={printable} filename={"Students"+ courseName +".csv"}>
        <SubmitButton 
          className="bg-blue-500 hover:bg-blue-900 ml-2" 
          iconClass="fas fa-file-csv" 
          text="Export to CSV"
        />
      </CSVLink>
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
