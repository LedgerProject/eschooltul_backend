import React, { useEffect, useState } from 'react';
import _ from 'lodash/fp';
import CourseSelector from './CourseSelector';
import TermSelector from './TermSelector';
import setCourseStudents from './students';


const GradesTable = (props) => {
  const [selectedCourse, setSelectedCourse] = useState(props.courses[0]);
  const [selectedTerm, setSelectedTerm] = useState(undefined);
  const [students, setStudents] = useState([]);

  console.log("Students: ", students);

  useEffect(() => {
    setStudents(setCourseStudents(selectedCourse, selectedTerm));
  }, [selectedCourse, selectedTerm]);
  
  const onSelectTerm = (e) => {
    if(e.target.value === -1){
      setSelectedTerm(undefined);  
    }else {
      setSelectedTerm(selectedCourse.terms[e.target.value]);  
    }
  };

  const onSelectedCourse = (e) => {
    setSelectedTerm(undefined); 
    setSelectedCourse(props.courses[e.target.value])
  };
  
  return (
    <>
      <h1 className="text-2xl md:text-5xl font-bold tracking-tighter">Grades</h1>
      <p className="text-gray-400 tracking-widest">Here you can manage your grades</p>
      <div className="">
        <CourseSelector 
          courses={props.courses}
          onSelectedCourse={onSelectedCourse}
        />
        { !_.isEmpty(selectedCourse.terms) && (
          <TermSelector 
            terms={selectedCourse.terms}
            onSelectTerm={onSelectTerm}
          />
        )}
      </div>
      {/** TODO: MERGE LESSONS, MARKS & STUDENTS */}
    </>
  )
};

export default GradesTable;
