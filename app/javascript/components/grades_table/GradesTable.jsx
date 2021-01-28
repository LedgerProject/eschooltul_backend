import React, { useEffect, useState } from 'react';
import _ from 'lodash/fp';
import CourseSelector from './CourseSelector';
import TermSelector from './TermSelector';
import setCourseStudents from './students';
import StudentsTable from './StudentsTable';

const GradesTable = (props) => {
  const [selectedCourse, setSelectedCourse] = useState(props.courses[0]);
  const [selectedTerm, setSelectedTerm] = useState(undefined);
  const [courseMembers, setcourseMembers] = useState([]);

  console.log("Students: ", courseMembers);

  useEffect(() => {
    setcourseMembers(
      setCourseStudents(selectedCourse, selectedTerm)
    );
  }, [selectedCourse, selectedTerm]);
  
  const onSelectTerm = (e) => {
    if(e.target.value === -1){
      setSelectedTerm(undefined);  
      return;
    }
      
    setSelectedTerm(selectedCourse.terms[e.target.value]);  
  };

  const onSelectedCourse = (e) => {
    setSelectedTerm(undefined); 
    setSelectedCourse(props.courses[e.target.value])
  };

  return (
    <>
      <h1 className="text-2xl md:text-5xl font-bold tracking-tighter">Grades</h1>
      <p className="text-gray-400 tracking-widest mb-2">Here you can manage your grades</p>
      <CourseSelector 
        courses={props.courses}
        onSelectedCourse={onSelectedCourse}
      />
      { !_.isEmpty(selectedCourse.terms) && (
        <TermSelector 
          terms={selectedCourse.terms}
          onSelectTerm={onSelectTerm}
          selectedTerm={selectedTerm}
        />
      )}
      <StudentsTable 
        courseMembers={courseMembers}
        selectedCourse={selectedCourse}
      />
    </>
  )
};

export default GradesTable;
